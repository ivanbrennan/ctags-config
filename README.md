```
curl -fsSL -H "Accept: application/vnd.github-blob.raw" \
  https://api.github.com/repos/ivanbrennan/ctags-config/contents/base-install.sh \
  > /tmp/base-install.sh \
  && bash /tmp/base-install.sh --github-host github.com
```
