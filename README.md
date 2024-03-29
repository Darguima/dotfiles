# .dotfiles

A collection of my [Ansible](https://docs.ansible.com/ansible/latest/index.html) roles to automatize my Arch Linux environment setup in any device.

Down below is a section about [Ansible](#ansible) for the ones that never hear about, and other about [how the project is organized](#how-the-project-is-organized).

## Installing the dotfiles 🐧
### Clone the repo 📥

```bash
# With HTTPS
$ git clone https://github.com/Darguima/dotfiles ~/.dotfiles

# With SSH
$ git clone git@github.com:Darguima/dotfiles.git ~/.dotfiles
```

### Installing Ansible 🚀

Let's start by installing Ansible - from their [installation guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#pip-install) we can use pip, but since we are on Arch:

```bash
$ sudo pacman -S ansible-core ansible
```

### Downloading Ansible Collections

This project uses some external _modules_ (called collections) from Ansible Galaxy. You can find which ones on the `requirements.yml`. To install them run:

```bash
$ ansible-galaxy collection install -r requirements.yml
```

### Defining your variables

To prevent pushing sensitive data, like usernames and password, and increase the personalization of this project, an external variables file was created. If you create it from the template, follow its instructions to fill, at least, all the needed vars.

Copy the template file and then edit `vars.yml`. 

```bash
$ cp vars_template.yml vars.yml
```

### Installing dotfiles

With everything ready, we can run the main playbook:

```bash
$ ansible-playbook main.yml --extra-vars "@vars.yml"
```

#### Filtering roles

If you just want install/update some of the roles you can filter them with tags. Find what tags you want to install down below.

```bash
# To just run the roles MINIMAL_GUI and docker
$ ansible-playbook main.yml --extra-vars "@vars.yml" --tags "MINIMAL_TUI, docker"

# To run all roles except docker and syncthing
$ ansible-playbook main.yml --extra-vars "@vars.yml" --skip-tags "docker, syncthing"

# To list all available tags
$ ansible-playbook main.yml --list-tags
```

##### Available tags

In order to install some set of roles, that create a specific environment, here is a list of all the available tags and what setup they create. Note that here are only tags that group roles to create some setup (eg. `TUI`, `GUI`), but tags for each role also exists - so, for example, if you want setup 'docker' you can use the tag `docker`.

###### MINIMAL_TUI

This tag will install only the necessary apps to use on the terminal, creating the most basic setup - no window managers and just a few apps like `ZSH`, `yay`, `nmtui` and `SSH`.

###### TUI

This tag will add to the `MINIMAL_TUI` setup all the TUI apps that I use, like `openvpn`, `protonvpn-cli`, `docker`, etc.

###### MINIMAL_GUI

Similarly to `MINIMAL_TUI`, this tag will install just install the necessary apps to create a GUI setup, like the window manager, `firefox` and `alacritty`, alongside with all the `TUI` apps.

###### GUI

Finally the `GUI` setup will install all the apps that I use, complementing the `MINIMAL_GUI` with apps like `GIMP`, `VSCode`, `Spotify`, etc.

## Ansible

Before do anything you should learn a little about [Ansible](https://docs.ansible.com/ansible/latest/index.html) if you never hear about it.

Ansible will run a bunch of commands, organized in yaml files. You can run Ansible in an `host machine` to install the dotfiles on the `target machine`, with ansible using SSH on the background. Although, on our case, we aren't using this remote feature.

You can find more about Ansible on their [docs](https://docs.ansible.com/ansible/latest/index.html), and more about this projects at the section "[How the project is organized](#how-the-project-is-organized)".


## How the project is organized

A role is folder with yaml files that organize the tasks, files, vars, etc for a specific context. For example, in this case, each role will install and/or configure some app, like install and configure the `zsh` or the `docker`. You can find all my roles on the folder `./roles`.

While some of the roles are very intuitive in what they do (because are just the app name), here is a list for the ones that do more specific and uncommon tasks:

#### system_prepare

Every configuration that is needed to be done before run all the tasks, like install some general dependency, or create a dotfile config file, will be done here. 
This is the first role that runs.

#### appearance

This role will configure the window manager, QT and GTK apps appearance, installing themes and icons packages.

#### general_programs

Here will be installed all the programs that don't need any configuration, just need to be installed (e.g. `LibreOffice`, `Discord`).

