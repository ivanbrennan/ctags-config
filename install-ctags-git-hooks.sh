#!/usr/bin/env bash

set -eu

TEMP_DIR=$1

col_red="\033[31;01m"
col_reset="\033[39;49;00m"

main() {
  printf 'Writing ctags generation script...\n'

  source_dir=$TEMP_DIR/ctags-config/templates

  envvar_template_dir=${GIT_TEMPLATE_DIR-}
  config_template_dir=$(git config --global --get --path init.templateDir || :)
  template_dir=${envvar_template_dir:-${config_template_dir}}

  if [ -z "$template_dir" ]; then
    printf '%bx%b No git template directory configured.\n' "$col_red" "$col_reset"
    printf '  Run `bash configure-git-template-directory.sh`\n'
    exit 1
  fi

  target_dir=$template_dir/hooks
  mkdir -p "$target_dir"

  if [ -e "$target_dir/ctags" ]; then
    backup_file="$target_dir/ctags.backup.$(date +%s)"
    printf '· Backing up %s/ctags\n' "$target_dir"
    (set -x; mv "$target_dir/ctags" "$backup_file")
  fi

  printf '· Creating %s/ctags\n' "$target_dir"
  cp "$source_dir/ctags" "$target_dir/ctags"
  chmod +x "$target_dir/ctags"

  printf 'Writing hooks...\n'
  for file in post-checkout post-commit post-merge; do
    add_or_create_hook "$source_dir/async-ctags-command" \
                       "$target_dir/$file"
  done

  add_or_create_hook "$source_dir/rebase-command" \
                     "$target_dir/post-rewrite"
}

add_or_create_hook() {
  local src=$1
  local dest=$2
  local name=$(basename "$dest")

  if [ -e "$dest" ]; then
    if ! contains_match "$src" "$dest"; then
      printf '\n' >> "$dest"
      cat "$src"  >> "$dest"
    fi
  else
    touch "$dest"
    chmod +x "$dest"
    printf '#!/bin/sh\n\n' >> "$dest"
    cat "$src"             >> "$dest"
  fi
  printf '· %s ✓\n' "$name"
}

contains_match() {
  local subfile=$1
  local superfile=$2
  local pattern="*$(<$subfile)*"

  [[ "$(<$superfile)" = $pattern ]]
}

main
