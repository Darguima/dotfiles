# Installing dotfiles 🚀

With everything set up, we can run the main playbook:

```bash
$ ansible-playbook main.yml --extra-vars "@vars.yml"
```

## Filtering roles

If you just want install/update some of the roles, or even skip some of them, you can do it with tags. Find what tags you want to install on the [filtering documentation](./FILTERING_ROLES.md).
