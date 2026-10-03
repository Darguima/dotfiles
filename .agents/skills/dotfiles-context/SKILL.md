---
name: dotfiles-context
description: >-
  Provides foundational context about this Ansible-based dotfiles project for
  Arch Linux. Use when starting any session in this codebase, when the agent
  needs to understand the project architecture, or before making changes to any
  role, playbook, or configuration file.
license: MIT
compatibility: opencode
---

## What I do

I provide foundational context about this dotfiles project — its architecture, conventions, and how the pieces fit together. Load me at the start of any session in this codebase.

## When to use me

Use me when:
- Starting a new session in this repository
- The agent needs to understand how the project is organized
- Before creating, modifying, or deleting any role
- Before changing the main playbook or any top-level configuration file

## Instructions

### 1. Project Overview

This is an Ansible-based project that automates the setup of an Arch Linux workstation. The playbook runs **locally** — there is no remote SSH target. All tasks execute on the host machine itself, for a single user.

### 2. Directory Structure

| Path | Purpose |
|---|---|
| `main.yml` | The main Ansible playbook. Each play maps exactly one role with its corresponding tag. |
| `roles/` | All Ansible roles. Each subdirectory is one role representing a program or system component. |
| `bin/` | Bootstrap scripts: `setup` prepares the environment, `install` runs the playbook. |
| `documentation/` | Manual setup, installation, and filtering guides. |
| `vars_template.yml` | Template for personal variables. Copied to `vars.yml` (gitignored) and passed to Ansible via `--extra-vars`. |
| `requirements.yml` | Ansible Galaxy collections required by the project. |
| `inventory.yml` | Ansible inventory file (local connection). |
| `ansible.cfg` | Ansible configuration file. |

### 3. Roles

Each role under `roles/` represents a program or system component to be installed and/or configured. Roles fall into three categories:

- **Preparation roles** — Run first, tagged `always`. They set up foundational dependencies (e.g., system packages, package manager wrappers) that other roles depend on. Skipping them can break the playbook.
- **Configuration roles** — The bulk of the project. Each installs a specific program and deploys its configuration files. Most roles follow this pattern.
- **`general_programs`** — A singleton role that installs programs which require no configuration, just pacman/AUR installation.

### 4. Playbook Execution

Two bootstrap scripts automate the workflow:

- **`./bin/setup`** — Installs Ansible (via pacman), installs Galaxy collections from `requirements.yml`, and creates `vars.yml` from the template if it does not exist. Run this first.
- **`./bin/install [an ansible flags here]`** — Runs `ansible-playbook main.yml --extra-vars "@vars.yml"` with any additional flags you pass (e.g., `--tags`, `--skip-tags`).

The manual equivalent is:
```bash
ansible-playbook main.yml --extra-vars "@vars.yml"
```

### 5. Variables

Personal variables are defined in `vars_template.yml`. On first setup, this file is copied to `vars.yml`. The latter is **gitignored** and never committed — it contains user-specific values (usernames, environment flags, etc.).

Variables are passed to the playbook via `--extra-vars "@vars.yml"` and are available to all roles. For detailed rules about how to use and reference variables within roles, refer to the `ansible-variables` skill.

### 6. Role Internal Structure

A role directory may contain any of these subdirectories. Not all roles need all of them.

| Subdirectory | Purpose | When to use |
|---|---|---|
| `tasks/` | Contains `main.yml` with the role's task list. | **Always required.** Every role must have tasks. |
| `vars/` | Contains `main.yml` with role-specific variables that should be considered private or derived. | When the role needs internal variables that shouldn't be overridden from outside. |
| `files/` | Static files to be copied as-is to the target machine. | When the role deploys configuration files that require no templating. |
| `templates/` | Jinja2 templates that get rendered with variables before being copied. | When configuration files need to include dynamic values (e.g., usernames, paths). |
| `defaults/` | Contains `main.yml` with default variable values that can be overridden. | When the role needs configurable variables with sensible defaults. |

For detailed rules about how to work within each of these, refer to the `role-structure` skill. For rules about installing programs, copying files, and handling templates, refer to the `install-programs` and `file-handling` skills.

### 7. Common Patterns When Creating a Role

When creating or modifying a role, follow these conventions:

- **3-step config deployment** — Most configuration roles follow this sequence:
  1. Install the package(s) (pacman or AUR)
  2. Ensure the target config directory exists (`file: state: directory`)
  3. Copy or template the configuration files into place

- **Privilege escalation** — Use `become: true` only for system-level operations (pacman installs, systemd services, writing to `/etc/` or `/usr/`). User-level file copies (e.g., to `~/.config/`) must **not** use `become`. AUR packages use `become: true` combined with `become_user: aur_builder`.

- **ZSH modular architecture** — The ZSH configuration is modular: the main `.zshrc` sources all `*.zsh` files from `~/.zshrc.d/`. Any role that needs to export environment variables, define aliases, or run startup commands can deploy a snippet to that directory instead of modifying `.zshrc` directly.

- **Task naming** — Every task **must** have a `name`. The name must be written in Present Continuous (e.g., `"Installing X"`, `"Copying Y config"`, `"Ensuring Z directory exists"`).

- **Idempotency** — Every task must be idempotent. Use native Ansible modules whenever possible. If a `shell` or `command` task is unavoidable, add `register` and `changed_when` or a `when` guard to prevent re-execution when the desired state is already achieved.

### 8. Creating a New Role

Creating a new role involves three steps:

**Step 1 — Create the role folder**

Create a subdirectory under `roles/` with a name that:
- Uses **lowercase and underscores** (snake_case), e.g. `nodejs_lang`, `embedded_systems`, `wake_on_lan`
- Clearly describes what the role does — if in doubt, use the program's own name
- folder name, role name and tag name should be the same to avoid confusion

**Step 2 — Build the role**

Add only the subdirectories the role actually needs. Follow the relevant skills for conventions:

| What you need to do | Skill |
|---|---|
| Decide which subdirectories to create | `role-structure` |
| Install packages (pacman, AUR, shell, git, get_url) | `install-programs` |
| Deploy files, directories, or templates | `file-handling` |
| Define or reference variables | `ansible-variables` |

**Step 3 — Register the role in `main.yml`**

Add a new play entry following this template:

```yaml
- name: <Human-Readable Name>
  hosts: all
  roles:
    - <role_folder_name>
  tags:
    - <role_folder_name>
```

**Ordering rules for `main.yml`:**

- The order should make logical sense — a role should not depend on a role that comes after it
- Group related roles together (e.g., window manager components near each other, language toolchains together, media apps together)
- Foundation roles (`system_prepare`, `yay`) stay at the top with the `always` tag
- `general_programs` stays at the bottom

### 9. Tagging & Filtering

Every play in `main.yml` carries at least one tag matching its role name. This allows selective execution:

```bash
# Run only a specific role
./bin/install --tags "role_name"

# Run everything except certain roles
./bin/install --skip-tags "role_a,role_b"

# Skip foundation (always-tagged) roles
./bin/install --skip-tags "always"
```

The `always` tag is an Ansible built-in that forces a role to run unless explicitly skipped. Preparation roles use this tag because downstream roles depend on them.

### 10. Related Skills

This is the overarching context skill. For specific rules and conventions, load the appropriate companion skill:

| Skill | Scope |
|---|---|
| `install-programs` | Rules for installing packages (pacman, AUR, package managers, language toolchains) |
| `file-handling` | Rules for directories, static files, templates, and file-related modules |
| `ansible-variables` | Rules for variable definition, usage, and precedence within roles |
| `role-structure` | Rules for what goes in each subdirectory (tasks, vars, templates, defaults) and how to organize them |
