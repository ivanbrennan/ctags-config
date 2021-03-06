#!/usr/bin/env bash

# The git template directory contains files and directories that will be copied
# to a repo's .git/ directory after it is created.

set -eu

main() {
  printf 'Checking for Git template directory...\n'

  envvar_template_dir=${GIT_TEMPLATE_DIR-}
  config_template_dir=$(git config --global --get --path init.templateDir || :)
  template_dir=${envvar_template_dir:-${config_template_dir}}

  if [ -z "$template_dir" ]; then
    if use_xdg_config; then
      template_dir=$XDG_CONFIG_HOME/git/templates
    elif use_dot_config; then
      template_dir=$HOME/.config/git/templates
    else
      template_dir=~/.git_templates
    fi

    printf '· Configuring Git template directory...\n'
    (
      set -x
      git config --global init.templateDir "$template_dir"
    )
  else
    printf '· Git template directory already configured: %s\n' "$template_dir"
  fi
}

use_xdg_config() {
  no_gitconfig_file &&
    xdg_config_home_set &&
    xdg_git_config_file_exists
}

no_gitconfig_file() {
  [ ! -e "$HOME/.gitconfig" ]
}

xdg_config_home_set() {
  [ ! -z "${XDG_CONFIG_HOME+x}" ]
}

xdg_git_config_file_exists() {
  [ -e "$XDG_CONFIG_HOME/git/config" ]
}

use_dot_config() {
  no_gitconfig_file &&
    dot_config_git_config_file_exists
}

dot_config_git_config_file_exists() {
  [ -e "$HOME/.config/git/config" ]
}

main
