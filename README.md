# .dotfiles

A collection of my [Ansible](https://docs.ansible.com/ansible/latest/index.html) roles, with a bootstrap to create my Arch Linux environment in any desktop.

## Ansible

Before do anything you should learn a little about [Ansible](https://docs.ansible.com/ansible/latest/index.html) if you never hear about it.

Ansible will run a bunch of commands, organized in yaml files. You can run Ansible in an `host machine` to install the dotfiles on the `target machine` (Ansible will use SSH). When configuring servers, this remote installation is very useful, but when I want to run something on my personal computers, I prefer do it locally.

You can find some more about Ansible on their [docs](https://docs.ansible.com/ansible/latest/index.html), and about this projects [after the installation guide](#how-the-project-is-organized).

## Installing the dotfiles 🐧
### Clone the repo 📥

```bash
# With HTTPS
$ git clone https://github.com/Darguima/dotfiles ~/.dotfiles

# With SSH
$ git clone git@github.com:Darguima/dotfiles.git ~/.dotfiles
```

### Installing Ansible 🚀

Now, on the machine from where you configure every device, the master, you need to install ansible. From the [installation documentation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#pip-install) we can use pip, but since we are on Arch:

```bash
# Arch Linux
$ sudo pacman -S ansible-core ansible
```

### Defining your variables

To protect my (and yours) personal information (like e-mails and passwords) some variables are defined externally.

Copy the vars template file and then edit `vars.yml`. This file gonna be passed to ansible that will read the vars.

```bash
$ cp vars_template.yml vars.yml
```

### Install dotfiles

With everything ready, we can run the main playbook to configure your local machine:

```bash
$ ansible-playbook --limit localhost main.yml -K --extra-vars "@vars.yml"
```

#### Filtering roles

If you just want install/update some of the packages you can filter the roles with tags. Find what tags you want to install here [not available yet] and run:

```bash
# To just run the roles docker and syncthing
$ ansible-playbook --limit localhost main.yml -K --extra-vars "@vars.yml" --tags "docker, syncthing"

# To run all roles except docker and syncthing
$ ansible-playbook --limit localhost main.yml -K --extra-vars "@vars.yml" --skip-tags "docker, syncthing"

# To list all available tags
$ ansible-playbook main.yml --list-tags
```

#### Choosing the target machines

You can also edit `inventory.yml` to configure your remote machines, like a server. Just follow [ansible guide](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html) to write one. In my case I just need run:

```bash
# Configure my desktop over SSH
$ ansible-playbook --limit desktop main.yml -K --extra-vars "@vars.yml"
```

## How the project is organized

A role is folder with yaml files that organize certain commands. You can find all my roles on the folder `./roles`. Each role will be used to perform a specific function/installation/configuration like install `docker` or `zsh`. Each role has sub-folders for tasks, files and variables.

### My roles

#### system_prepare

Ansible, and some of my roles, need some dependencies. All them should be installed by the role `system_prepare`. This include some Linux and python packages.
