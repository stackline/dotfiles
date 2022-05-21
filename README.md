# dotfiles

## Installation

* Install homebrew or linuxbrew
  * Install homebrew formulae
  * Install homebrew casks
* Install vim-plug
  * Install vim plugins

## Append user local git settings to $XDG_CONFIG_HOME/git/config_local

```bash
$ git config --file $XDG_CONFIG_HOME/git/config_local user.name "User name"
$ git config --file $XDG_CONFIG_HOME/git/config_local user.email "username@example.com"
```

## Installation error of ruby via rbenv on Linux

If getting the following error, try the linking to OpenSSL.

> The Ruby openssl extension was not compiled.
> ERROR: Ruby install aborted due to missing extensions
> Try running `yum install -y openssl-devel` to fetch missing dependencies.

```
$ brew link openssl@1.1 --force
```

## Firefox

* Do not beep when not finding a phrase on this page.
  * about:config
  * accessibility.typeaheadfind.enablesound
  * switch the value from true to false

## May disable Spotlight indexing

Check before work.

```sh
$ mdutil -as
/:
        Indexing enabled.
/System/Volumes/Data:
        Indexing enabled.
```

Turn indexing off.

```sh
$ sudo mdutil -a -i off
Password:
/:
2022-01-01 00:00:00.000 mdutil[20452:2561496] mdutil disabling Spotlight: / -> kMDConfigSearchLevelFSSearchOnly
        Indexing disabled.
/System/Volumes/Data:
2022-01-01 00:00:00.000 mdutil[20452:2561496] mdutil disabling Spotlight: /System/Volumes/Data -> kMDConfigSearchLevelFSSearchOnly
        Indexing disabled.
```

Check after work.

```sh
$ mdutil -as
/:
        Indexing disabled.
/System/Volumes/Data:
        Indexing disabled.
```
