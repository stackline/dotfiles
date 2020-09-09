# dotfiles

## Append user local git settings to $XDG_CONFIG_HOME/git/config_local

```bash
$ git config --file $XDG_CONFIG_HOME/git/config_local user.name "User name"
$ git config --file $XDG_CONFIG_HOME/git/config_local user.email "username@example.com"
```

## Firefox

* Do not beep when not finding a phrase on this page.
  * about:config
  * accessibility.typeaheadfind.enablesound
  * switch the value from true to false
