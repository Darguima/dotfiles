# Filtering roles

If you just want install/update some of the roles, or even skip some of them, you can do it with tags. Find what tags you want to install down below.

If you want, you can replace the bootstrap installation bin with the corresponding Ansible command - read the [manual installation documentation](./MANUAL_INSTALLATION.md) to more info.

```bash
# To just install the roles MINIMAL_GUI and docker
$ ./bin/install --tags "MINIMAL_TUI, docker"

# To install all roles except docker and syncthing
$ ./bin/install --skip-tags "docker, syncthing"
```

## Always Tag

This is an Ansible built-in special tag, that will always run the role, unless you specifically skip it. This roles, like `system_prepare` and `yay`, will install and configure dependencies for other roles and should be executed at least on the first run and after each update.

```bash
# To skip the always tag roles
$ ./bin/install --skip-tags "always"
```

## Available tags

In order to install some set of roles, that create a specific environment, here is a list of all the available tags and what setup they create. Note that here are only tags that group roles to create some setup (eg. `TUI`, `GUI`), but tags for each role also exists - so, for example, if you want setup 'docker' you can use the tag `docker`.

You can also list all tags by playbook with `--list-tags`.

```bash
# To list all available tags
$ ./bin/install --list-tags
```

### MINIMAL_TUI

This tag will install only the necessary apps to use on the terminal, creating the most basic setup - no window managers and just a few apps like `ZSH`, `yay`, `nmtui` and `SSH`.

### TUI

This tag will add to the `MINIMAL_TUI` setup all the TUI apps that I use, like `openvpn`, `protonvpn-cli`, `docker`, etc.

### MINIMAL_GUI

Similarly to `MINIMAL_TUI`, this tag will install just install the necessary apps to create a GUI setup, like the window manager, `firefox` and `alacritty`, alongside with all the `TUI` apps.

### GUI

Finally the `GUI` setup will install all the apps that I use, complementing the `MINIMAL_GUI` with apps like `GIMP`, `VSCode`, `Spotify`, etc.

