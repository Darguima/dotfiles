# .dotfiles

A collection of my [Ansible](https://docs.ansible.com/ansible/latest/index.html) roles, and a bootstrap, to automatize my Arch Linux environment setup in any device.

Down below is a [section about Ansible](#ansible) for the ones that never had heard about, and other about [how the project is organized](#how-the-project-is-organized).

## Installing the dotfiles 🐧

### Clone the repo 📥

```bash
# With HTTPS
$ git clone https://github.com/Darguima/dotfiles ~/.dotfiles

# With SSH
$ git clone git@github.com:Darguima/dotfiles.git ~/.dotfiles
```

Now you can go to the folder `~/.dotfiles` and start the setup.

### Setting up the environment 🏗️

To install all the dependencies (like Ansible), you can run the setup bootstrap bin. If you want to understand what it does, or setup everything manually, check the [manual setup documentation](./documentation/MANUAL_SETUP.md).

```bash
$ ./bin/setup
```

### Installing dotfiles 🚀

To avoid run Ansible command manually, with all the needed flags, I set up a bootstrap bin to run everything for you. If you want to understand what it does, or run Ansible manually, check the [manual installation documentation](./documentation/MANUAL_INSTALLATION.md).

```bash
$ ./bin/install <pass any ansible flag here>
```

#### Filtering roles

If you just want install/update some of the roles, or even skip some of them, you can do it with tags. Find what tags you want to use on the [filtering documentation](./documentation/FILTERING_ROLES.md).

## Ansible

Before do anything, you should learn a little about [Ansible](https://docs.ansible.com/ansible/latest/index.html), if you had never heard about it.

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

