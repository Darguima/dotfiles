# Setting up environment 🏗️

Let's start by installing Ansible - from their [installation guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#pip-install) we can use pip, but since we are on Arch:

```bash
$ sudo pacman -S ansible-core ansible
```

## Downloading Ansible Collections

This project uses some external _modules_ (called collections) from Ansible Galaxy. You can find which ones on the `requirements.yml`. To install them, run:

```bash
$ ansible-galaxy collection install -r requirements.yml
```

## Defining your variables

To prevent pushing sensitive data, like usernames and password, and increase the personalization of this project, an external variables file was created. If you create it from the template, follow its instructions to fill, at least, all the needed vars.

Copy the template file and then edit `vars.yml`. 

```bash
$ cp vars_template.yml vars.yml
```
