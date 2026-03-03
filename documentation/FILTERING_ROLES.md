# Filtering roles

If you just want install/update some of the roles, or even skip some of them, you can do it with tags. Find what tags you want to install down below.

If you want, you can replace the bootstrap installation bin with the corresponding Ansible command - read the [manual installation documentation](./MANUAL_INSTALLATION.md) to more info.

```bash
# To just install docker
$ ./bin/install --tags "docker"

# To install all roles except docker and syncthing
$ ./bin/install --skip-tags "docker, syncthing"
```

## Always Tag

This is an Ansible built-in special tag, that will always run the role, unless you specifically skip it. Roles, like `system_prepare` and `yay`, will install and configure dependencies for other roles and should be executed at least on the first run and after each update.

```bash
# To skip the always tag roles
$ ./bin/install --skip-tags "always"
```