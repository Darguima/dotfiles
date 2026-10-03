---
name: file-handling
description: >-
  Rules for handling files and directories in this Ansible dotfiles project.
  Use when creating, modifying, or deploying files, directories, or templates
  inside any role.
license: MIT
compatibility: opencode
---

## What I do

I define the rules and conventions for creating, deploying, and editing files and directories in this Ansible dotfiles project.

## When to use me

Use me when:
- Creating a new file or directory inside a role
- Deploying configuration files via `copy` or `template`
- Ensuring parent directories exist
- Editing a single line in an existing file
- Setting file permissions or ownership

## Instructions

### 1. Creating Directories and Files

Use the `file` module to create directories or empty files (like `touch`).

**Creating a directory:**
```yaml
- name: Ensuring <app> config directory exists
  file:
    path: "{{ linux_user_home }}/.config/<app>"
    state: directory
```

**Creating an empty file (touch):**
```yaml
- name: Ensuring <filename> file exists
  file:
    path: "{{ linux_user_home }}/.config/<filename>"
    state: touch
```

Rules:
- Always prefer a descriptive `name` in Present Continuous.
- Use `state: directory` to create directories, `state: touch` for empty marker files.
- Set `mode` only when the default is wrong — keep the YAML clean (see section 6).

### 2. Path Construction

Always use Ansible variables instead of hardcoded paths or `~`:

| What | How |
|---|---|
| User home | `{{ linux_user_home }}` |
| User config | `{{ linux_user_home }}/.config/<app>` |
| System paths | Hardcode directly (e.g., `/etc/`, `/usr/bin/`) + `become: true` |

```yaml
# Correct — use the variable
path: "{{ linux_user_home }}/.config/sway"

# Wrong — don't use ~
path: ~/.config/sway

# Wrong — don't hardcode the username
path: /home/alice/.config/sway
```

System paths must be paired with `become: true`:
```yaml
- name: Copying wallpaper
  copy:
    src: wallpaper.svg
    dest: /usr/share/backgrounds/sway/wallpaper.svg
  become: true
```

### 3. Deploying Static Files

Place the source file in the role's `files/` directory and use the `copy` module.

**Single file:**
```yaml
- name: Copying <app> config file
  copy:
    src: <filename>        # relative to the role's files/ directory
    dest: "{{ linux_user_home }}/.config/<app>/<filename>"
```

**Single file with rename (source name != destination name):**
```yaml
- name: Copying <app> config file
  copy:
    src: <source_filename>  # name in files/
    dest: "{{ linux_user_home }}/.config/<app>/<target_filename>"
```

**Recursive directory copy (entire folder):**
```yaml
- name: Copying <app> config folder
  copy:
    src: ./                  # everything in files/ folder
    dest: "{{ linux_user_home }}/.config/<app>"
```

Use a trailing slash on `src` to copy the **contents** (vs. the directory itself). Use `src: folder/` when you have a subfolder inside `files/`.

**Loop for multiple files:**
```yaml
- name: Copying dotfiles
  copy:
    src: "{{ item.src }}"
    dest: "{{ item.dest }}"
  loop:
    - src: <file_a>
      dest: "{{ linux_user_home }}/<path_a>"
    - src: <file_b>
      dest: "{{ linux_user_home }}/<path_b>"
```

Always ensure the destination directory exists before copying (see section 5).

### 4. Deploying Templated Files

When a configuration file needs dynamic values (variables), place a Jinja2 template in the role's `templates/` directory and use the `template` module.

```yaml
- name: Deploying <app> config from template
  template:
    src: <filename>       # relative to the role's templates/ directory
    dest: "{{ linux_user_home }}/.config/<app>/<filename>"
```

Define the variables either in `defaults/main.yml` (when they should be overridable) or `vars/main.yml` (when they are internal). Refer to the `role-structure` skill for the distinction.

A comment at the top of the task can help future readers know where variables come from:
```yaml
# Variables defined in defaults/main.yml
- name: Deploying <app> config from template
  template:
    src: <filename>
    dest: "{{ linux_user_home }}/.config/<app>/<filename>"
```

### 5. Ensuring Parent Directories Exist Before Copying

Always create the destination directory **before** copying files into it. Never assume it already exists.

```yaml
- name: Ensuring <app> config directory exists
  file:
    path: "{{ linux_user_home }}/.config/<app>"
    state: directory

- name: Copying <app> config file
  copy:
    src: <filename>
    dest: "{{ linux_user_home }}/.config/<app>/<filename>"
```

This rule applies even to nested paths like `~/.config/systemd/user/` or `~/.local/bin/` — ensure each parent directory explicitly.

### 6. Editing Lines In-Place

When you only need to ensure a specific line exists in an existing file (and can't or shouldn't replace the whole file), use `lineinfile` instead of `copy`.

```yaml
- name: Writing <description> at config file
  lineinfile:
    path: "{{ linux_user_home }}/.config/<file>"
    regexp: '^<pattern>'
    line: "<new_line_value>"
```

For creating a new file with a line (e.g., sudoers rules), use `create: yes` and `validate`:
```yaml
- name: Writing <description>
  lineinfile:
    path: /etc/sudoers.d/<file>
    line: '<rule>'
    create: yes
    mode: 0644
    validate: 'visudo -cf %s'
  become: true
```

### 7. Permissions (Mode)

Set `mode` only when it matters. Ansible's default permissions are usually correct for user config files.

**When to set mode:**

| Scenario | Mode | Example |
|---|---|---|
| Executable scripts (user-level) | `0755` | `~/.local/bin/` scripts |
| Executables in system paths | `0755` | `/usr/bin/` scripts |
| System config files | `0644` | `/etc/` configs, wallpapers |
| Sensitive files (keys, secrets) | `0600` | SSH keys, credentials |

**When to omit mode:**

| Scenario | Reason |
|---|---|
| Regular config files in `~/.config/` | Default (`0644` or `0755` depending) is fine |
| Directories | Ansible's default is typically correct |
| ZSH snippet imports | No special permissions needed |

```yaml
# Good: mode is relevant (executable script)
- name: Copying mount script
  copy:
    src: mount_script
    dest: "{{ linux_user_home }}/.local/bin/mount_script"
    mode: "0755"

# Good: mode is relevant (system config)
- name: Copying network config
  copy:
    src: 50-wired.network
    dest: /etc/systemd/network/50-wired.network
    mode: '0644'
  become: true

# Good: mode omitted — default is fine for user config
- name: Copying config file
  copy:
    src: config.ini
    dest: "{{ linux_user_home }}/.config/<app>/config.ini"
```

Do not set `mode` on every task just to be safe — setting it unnecessarily makes the YAML noisier and harder to read. Use good judgement: only set it when the default would be wrong or insecure.
