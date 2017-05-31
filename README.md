### Install Ctags and configure automatic re-indexing via git hooks

``` Shell
( url='https://api.github.com/repos/ivanbrennan/ctags-config/contents/base-install.sh'
  bash -c "$(curl -fsSL -H 'Accept: application/vnd.github-blob.raw' $url)" \
       base-install.sh --github-host github.com )
```
If you're using an SSH config file to manage multiple identities, you can use the `--github-host` flag to specify the appropriate Host.

### Editor integration

The above installation script sets up git hooks to keep an up-to-date tags file in `.git/tags`. Vim will automatically locate this file if you've installed the [fugitive](https://github.com/tpope/vim-fugitive) plugin.
