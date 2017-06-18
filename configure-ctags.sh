#!/usr/bin/env bash

set -eu

main() {
  printf 'Setting sensible defaults...\n'

  config_file=$HOME/.ctags

  if [ -e "$config_file" ]; then
    create_backup "$config_file"
  else
    create_file "$config_file"
  fi

  write_options_to_file "$config_file"
}

create_backup() {
  local file=$1
  local backup="$file.backup.$(date +%s)"

  printf '· Backing up %s\n' "$file"
  (set -x; cp "$file" "$backup")
}

create_file() {
  local file=$1
  printf '· Creating %s\n' "$file"
  touch "$file"
}

write_options_to_file() {
  local file=$1
  printf '· Writing options to %s\n' "$file"

  options=(--languages=-javascript,sql,json,svg
           --exclude=.git
           --exclude=*.min.css)

  for opt in ${options[@]}; do
    if ! line_exists "$opt" "$file"; then
      printf '%s\n' "$opt" >> "$file"
    fi
  done
}

line_exists() {
  local line=$1
  local file=$2

  grep --files-with-matches \
       --fixed-strings      \
       -e "$line"           \
       "$file"              \
       >/dev/null 2>&1
}

main
