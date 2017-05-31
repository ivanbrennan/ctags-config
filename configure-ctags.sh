#!/usr/bin/env bash

set -eu

main() {
  config_file=$HOME/.ctags

  if [ -e "$config_file" ]; then
    backup_file="$config_file.backup.$(date +%s)"
    echo "### Backing up existing to .ctags to $backup_file"
    cp "$config_file" "$backup_file"
  else
    echo "### Creating $config_file"
    touch "$config_file"
  fi

  options=(--languages=-javascript,sql,json,svg
           --exclude=.git
           --exclude=*.min.css)

  echo "### Setting sensible defaults in $config_file"
  for opt in ${options[@]}; do
    if ! line_exists "$opt" "$config_file"; then
       echo "$opt" >> "$config_file"
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
