---
name: install-programs
description: >-
  Rules for installing programs in this Ansible dotfiles project. Use when
  adding or modifying package installation tasks inside any role, or when
  installing programs via pacman, yay (AUR), shell, git, or get_url.
license: MIT
compatibility: opencode
---

## What I do

I define the rules and conventions for installing programs and packages in this Ansible dotfiles project.

## When to use me

Use me when:
- Creating a new role that installs programs
- Adding a new package to an existing role
- Modifying installation tasks
- Needing to know the correct YAML patterns for pacman, AUR, shell, git, or get_url installations

## Instructions

### 1. General Rules

- Every task **must** have a `name` written in **Present Continuous** (e.g., `"Installing X"`, `"Cloning Y"`).
- Always **group packages by source**: official Arch repos go in `pacman` tasks, AUR-only packages go in `kewlfft.aur.aur` tasks. Never mix them in the same task. Don't tell to the user the difference on name.
- When a role needs both pacman and AUR packages, use **separate tasks** — pacman first, then AUR.
- Group related packages into a single task when it makes semantic sense (e.g., all dependencies for one tool together).

### 2. Installing with pacman (Official Arch Repos)

Use this pattern for any package available in the official Arch repositories.

```yaml
- name: Installing <program name>
  pacman:
    name: <package_name>
    state: latest
  become: true
```

For multiple packages, use a list:

```yaml
- name: Installing <group description>
  pacman:
    name:
      - <package_a>
      - <package_b>
      - <package_c>
    state: latest
  become: true
```

Rules:
- `state: latest` — always use `latest`, never `present` or `installed`.
- `become: true` — always required for system package installation.
- Use a string for a single package, a list for multiple packages.
- The `name` value must be the **exact Arch Linux package name**, not a description.

### 3. Installing with yay (AUR Packages)

Use this pattern for any package only available in the AUR.

```yaml
- name: Installing <program name>
  kewlfft.aur.aur:
    use: yay
    name: <package_name>
    state: latest
  become: true
  become_user: aur_builder
```

For multiple packages:

```yaml
- name: Installing <group description>
  kewlfft.aur.aur:
    use: yay
    name:
      - <package_a>
      - <package_b>
    state: latest
  become: true
  become_user: aur_builder
```

Rules:
- `use: yay` — always set this explicitly.
- `state: latest` — always use `latest`.
- `become: true` + `become_user: aur_builder` — both are **always required** for AUR installation.
- Use a string for a single package, a list for multiple packages.
- The `name` value must be the **exact AUR package name**.

### 4. Installing with shell/command

Use this **only** when the tool has no pacman or AUR package available (e.g., nvm, asdf, oh-my-zsh). Every shell task must be idempotent.

```yaml
- name: Installing <tool name>
  shell: <install command>
  args:
    executable: /bin/bash
  register: command_output
  changed_when: "'<already installed message>' not in command_output.stdout"
```

Rules:
- Only use `shell` or `command` as a **last resort** — prefer native Ansible modules.
- Always use `register` together with `changed_when` to ensure idempotency.
- For `shell` tasks, always set `args.executable: /bin/bash`.
- The `changed_when` expression must match something in the command output that indicates the tool was already installed (so Ansible reports no change on re-runs).

### 5. Installing with git

Use this for tools or plugins distributed as git repositories (e.g., zsh plugins, application repos).

**For simple clones (plugins, themes):**

```yaml
- name: Cloning <repo name>
  git:
    repo: <repository_url>
    dest: <destination_path>
```

**For application repos (with version pinning):**

```yaml
- name: Cloning <repo name>
  git:
    repo: <repository_url>
    dest: <destination_path>
    update: true
    force: true
    version: master
  become: true
  become_user: <user>
```

Rules:
- The task name should use `"Cloning ..."` to distinguish from package installations.
- `dest` must be the full path where the repository should live.
- For app repos, always set `update: true`, `force: true`, and `version: <branch>`.
- The `git` module is idempotent by default — it will only clone on first run and update on subsequent runs.

### 6. Installing with get_url

Use this for downloading individual files that are not part of any package (e.g., fonts, standalone binaries, scripts).

```yaml
- name: Downloading <file description>
  get_url:
    url: "{{ item.url }}"
    dest: "{{ item.dest }}"
    mode: '<permissions>'
  loop:
    - url: "<file_url>"
      dest: "<destination_path>"
```

Rules:
- Use `loop` when downloading multiple files instead of repeating the task.
- Always set `mode` to define file permissions (e.g., `'0755'` for executables, `'0644'` for regular files).
- Use `become: true` when writing to system directories (e.g., `/usr/share/fonts/`, `/usr/share/`).
- The `get_url` module is idempotent — it checks if the destination file already exists with the correct content.

