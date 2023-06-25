# .dotfiles

Finally after 3 years of Linux and many Linux distros I created my `.dotfiles`.

Here you will find an [Ansible](https://docs.ansible.com/ansible/latest/index.html) (radically simple IT automation platform) environment, that I use to quickly setup my network devices, including my server.

## Installing 🐧

### Clone the repo 📥

```bash
# With HTTPS
$ git clone https://github.com/Darguima/dotfiles ~/.dotfiles

# With SSH
$ git clone git@github.com:Darguima/dotfiles.git ~/.dotfiles
```

### Installing Ansible 🚀

Now, on the machine from where you configure every device, the master, you need to install ansible. From the [installation documentation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#pip-install) we can use pip:

```bash
$ python3 -m pip install --user ansible

# Or in Arch if you want
$ yay -S ansible-core ansible
```

### Install dotfiles

With everything ready, we can run the main playbook to configure your local machine:

```bash
$ ansible-playbook --limit localhost main.yml -K
```

You can also edit `inventory.yml` to configure your remote machines, like a server. Just follow [ansible guide](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html) to write one. In my case I just need run:

```bash
# Configure all desktops
$ ansible-playbook --limit desktop main.yml -K

# Configure all servers
$ ansible-playbook --limit server main.yml -K
```

