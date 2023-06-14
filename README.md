# .dotfiles

Finally after 3 years of Linux and many Linux distros I created my `.dotfiles`.

Here you will find an [Ansible](https://docs.ansible.com/ansible/latest/index.html) (radically simple IT automation platform) environment, that I use to quickly setup my network devices.

## Installing 🐧

### Clone the repo 📥

###### ⚠️ Only install it if you've cloned it inside `~/.dotfiles`, otherwise you'll run into problems. ⚠️

```bash
# With HTTPS
$ git clone https://github.com/Darguima/dotfiles ~/.dotfiles

# With SSH
$ git clone git@github.com:Darguima/dotfiles.git ~/.dotfiles
```

### Installing Ansible 🚀

Now, on the machine from where you configure everything, the master, you need to install ansible. From the [installation documentation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#pip-install) we can use python:

```bash
$ python3 -m pip install --user ansible
```

