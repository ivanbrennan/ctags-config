### Install Ctags and configure automatic re-indexing via git hooks

``` Shell
curl -fsSL -H "Accept: application/vnd.github-blob.raw" \
  https://api.github.com/repos/ivanbrennan/ctags-config/contents/base-install.sh \
  > /tmp/base-install.sh \
  && bash /tmp/base-install.sh --github-host github.com
```
If you're using an SSH config file to manage multiple identities, you can use the `--github-host` flag to specify the appropriate Host.

### Editor integration

The above installation script sets up git hooks to keep an up-to-date tags file in `.git/tags`. Vim will automatically locate this file if you've installed the [fugitive](https://github.com/tpope/vim-fugitive) plugin.
