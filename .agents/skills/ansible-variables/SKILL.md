---
name: ansible-variables
description: >-
  Rules for defining, referencing, and organizing variables across this Ansible
  dotfiles project. Use when reading or assigning variables in any role, or
  deciding where a variable should live.
license: MIT
compatibility: opencode
---

## What I do

I define the rules and conventions for working with Ansible variables in this dotfiles project — where to define them, how to reference them, and how to decide between global, role-specific, and private variables.

## When to use me

Use me when:
- Creating or modifying a role that needs variables
- Deciding whether a variable belongs in `vars_template.yml`, `defaults/`, or `vars/`
- Referencing variables in tasks, templates, or conditionals
- Extracting a repeated value into a variable for DRY

## Instructions

### 1. Global Variables (`vars_template.yml`)

Before adding a new variable, always check `vars_template.yml` — a variable for what you need may already exist.

This file is the **single source of truth for project-wide variables** and contains:
- System-level values (e.g., `linux_username`, `linux_user_home`, `target_environment`)
- Application-specific values that users might want to customize (e.g., service usernames, GUI credentials)

**Rule:** If a variable represents something a user would reasonably want to configure or change without editing role internals, add it to `vars_template.yml`. This keeps configuration discoverable and easy to adjust.

Variables from `vars_template.yml` are passed to the playbook via `--extra-vars "@vars.yml"` and are available to **all roles**.

### 2. Role-Specific Variables (`vars/` and `defaults/`)

Use role-level subdirectories only when a variable is truly needed and doesn't belong in `vars_template.yml`:

| Subdirectory | Purpose | Example |
|---|---|---|
| `vars/main.yml` | Private/internal variables that should NOT be overridden | Derived paths, internal constants |
| `defaults/main.yml` | Configurable variables with sensible defaults | Feature flags, theme names, model selections |

**Only create `vars/` or `defaults/` when really needed.** If a role has no internal or configurable variables, don't add these folders.

Refer to the `role-structure` skill for detailed rules about each subdirectory.

### 3. Extracting Repeated Values

If you find yourself writing the same value (path, package name, config key, URL) multiple times across tasks, extract it into a variable:

```yaml
# Instead of repeating:
- name: Cloning powerlevel10k theme
  git:
    repo: https://github.com/romkatv/powerlevel10k
    dest: "{{ linux_user_home }}/.oh-my-zsh/custom/themes/powerlevel10k"

# Use a variable:
# roles/zsh/vars/main.yml
ZSH_CUSTOM: "{{ linux_user_home }}/.oh-my-zsh/custom"

# roles/zsh/tasks/main.yml
- name: Cloning powerlevel10k theme
  git:
    repo: https://github.com/romkatv/powerlevel10k
    dest: "{{ ZSH_CUSTOM }}/themes/powerlevel10k"
```

This makes the code DRY, easier to read, and simpler to update.

### 4. Referencing Variables in Tasks

- Use the `{{ variable_name }}` syntax in YAML values.
- Always **quote** the value when using variables inside a string: `path: "{{ linux_user_home }}/.config/sway"`
- Use Jinja2 filters when needed: `"{{ variable | default('fallback') }}"`, `"{{ variable | lower }}"`, etc.

```yaml
# Correct — quoted
path: "{{ linux_user_home }}/.config/sway"

# Correct — standalone variable unquoted is fine
state: "{{ some_state }}"

# Wrong — unquoted in a string context
path: {{ linux_user_home }}/.config/sway

# Wrong — hardcoded path instead of variable
path: /home/alice/.config/sway
```

### 5. Variable Precedence

Ansible has a well-defined variable precedence. The relevant levels for this project, from highest to lowest:

1. **Extra vars** (`--extra-vars "@vars.yml"`) — always wins, never overridden
2. **Role `defaults/main.yml`** — lowest precedence, easily overridden by extra vars
3. **Role `vars/main.yml`** — higher precedence than defaults, harder to override

This means:
- `vars_template.yml` values **always override** role defaults — use `defaults/` for variables you expect users to customize
- Use `vars/` for values that should NOT be overridden from outside the role
- If a variable in `vars_template.yml` and a role `default` have the same name, the extra var wins
