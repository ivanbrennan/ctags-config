#!/usr/bin/env bash

set -eu

main() {
  echo 'Setting sensible defaults...'

  config_file=$HOME/.ctags

  if [ -e "$config_file" ]; then
    create_backup "$config_file"
  else
    echo "· Creating $config_file"
    touch "$config_file"
  fi

  options=(--languages=-javascript,sql,json,svg
           --exclude=.git
           --exclude=*.min.css)

  echo "· Writing to $config_file"
  for opt in ${options[@]}; do
    if ! line_exists "$opt" "$config_file"; then
       echo "$opt" >> "$config_file"
    fi
  done
}

create_backup() {
  local file=$1
  local backup="$file.backup.$(date +%s)"

  echo "· Backing up $file"
  (set -x; cp "$file" "$backup")
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
