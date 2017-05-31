``` Shell
curl -fsSL -H "Accept: application/vnd.github-blob.raw" \
  https://api.github.com/repos/ivanbrennan/ctags-config/contents/base-install.sh \
  > /tmp/base-install.sh \
  && bash /tmp/base-install.sh --github-host github.com
```
If you're using an SSH config file to manage multiple identities, you can specify the appropriate Host via the `--github-host` flag.
