# dotfiles

## Append user local git settings to ~/.gitconfig_local

```bash
$ git config --file ~/.gitconfig_local user.name "User name"
$ git config --file ~/.gitconfig_local user.email "username@example.com"
```

## Display the search bar on the top in Firefox

ref. [How to Create a userChrome.css File](https://www.userchrome.org/how-create-userchrome-css.html)

userChrome.css

```css
.browserContainer > findbar {
  -moz-box-ordinal-group: 0;
}
```
