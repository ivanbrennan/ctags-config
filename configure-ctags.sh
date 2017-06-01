#!/usr/bin/env bash

set -eu

main() {
  echo 'Setting sensible defaults...'

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

  echo "· Backing up $file"
  (set -x; cp "$file" "$backup")
}

create_file() {
  local file=$1
  echo "· Creating $file"
  touch "$file"
}

write_options_to_file() {
  local file=$1
  echo "· Writing options to $file"

  options=(--languages=-javascript,sql,json,svg
           --exclude=.git
           --exclude=*.min.css)

  for opt in ${options[@]}; do
    if ! line_exists "$opt" "$file"; then
      echo "$opt" >> "$file"
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
