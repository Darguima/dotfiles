---
name: role-structure
description: >-
  Rules for organizing Ansible role directories and files in this dotfiles
  project. Use when creating a new role or deciding what goes in each
  subdirectory (tasks, vars, defaults, files, templates).
license: MIT
compatibility: opencode
---

## What I do

I define how Ansible role directories should be structured in this project — what each subdirectory is for, when to create it, and what goes inside.

## When to use me

Use me when:
- Creating a brand new role
- Deciding which subdirectories a role needs
- Understanding the purpose of `tasks/`, `vars/`, `defaults/`, `files/`, or `templates/`
- Figuring out where to place a new file or variable

## Instructions

### 1. Overview

Each role is a folder under `roles/`. A role may contain any of these subdirectories, but only `tasks/` is strictly required. Keep it minimal — only create what the role actually needs.

```
roles/<role_name>/
├── tasks/          ← Required. Contains main.yml with the role's tasks.
├── vars/           ← Optional. Constant variables that clean up the code and are never rewritten.
├── defaults/       ← Optional. Default values, very likely overridden elsewhere (e.g. vars_template.yml).
├── files/          ← Optional. Static files deployed via the copy module.
└── templates/      ← Optional. Jinja2 templates deployed via the template module.
```

### 2. `tasks/main.yml` — The Role's Actions (Required)

Every role must have a `tasks/main.yml`. This file contains the ordered list of tasks the role executes.

Rules:
- Every task **must** have a `name` in Present Continuous (e.g., `"Installing X"`, `"Copying Y config"`, `"Ensuring Z directory exists"`).
- Tasks run in order from top to bottom.
- Keep tasks focused — if a task does more than one thing, split it.

For specific task patterns, refer to:
- `install-programs` skill — installing packages
- `file-handling` skill — creating files, directories, copying, templating

### 3. `vars/main.yml` — Constant Role Variables (Optional)

Use this for variables that are **constant for the role** and should never be overridden from outside.

The point of `vars/` is simply to clean up the code: instead of repeating the same literal value in several tasks, you define it once here and reference it. These are constant values.

This vars can be theoretically overwritten by other files, like `vars_template.yml`, but it shouldn't happen.

When to use:
- Derived or computed paths (e.g., `ZSH_CUSTOM: "{{ linux_user_home }}/.oh-my-zsh/custom"`)
- Internal constants used across multiple tasks
- Values that would break the role if changed from outside

```yaml
# roles/<role_name>/vars/main.yml
app_path: "{{ linux_user_home }}/.config/<app>"
service_flag: "--some-flag"
```

**Only create `vars/` when the role actually needs internal variables.**

### 4. `defaults/main.yml` — Overridable Variables (Optional)

Use this for variables that define **sensible default values**. The idea is that these values will very likely be modified elsewhere — usually in `vars_template.yml` — so `defaults/` should give them a sensible starting value.

If the user ever deletes that file or removes one of those variables, `defaults/` keeps assigning the default value, so the role still works. That's the whole point of `defaults/`: it's the fallback.

When to use:
- Feature flags or toggles a user might want to change
- Configurable values (theme names, model names, usernames)
- Any variable where the default should be easy to customize

```yaml
# roles/<role_name>/defaults/main.yml
app_theme: "dark"
enable_feature: true
```

Because of Ansible's variable precedence, `vars_template.yml` values will always override `defaults/` values. This is intentional — defaults provide a fallback, vars_template.yml provides the user's customizations.

**Only create `defaults/` when the role has user-configurable options.**

### 5. `files/` — Static Files (Optional)

Place static configuration files here and deploy them with the `copy` module.

When to use:
- Configuration files that need **no dynamic values** (no Jinja2 variables)
- Scripts, wallpapers, systemd service files, icons

```
roles/<role_name>/files/
├── config.ini
├── script.sh
└── subfolder/
    ├── file_a.conf
    └── file_b.conf
```

For detailed deployment rules (syntax, path patterns, permission handling), refer to the `file-handling` skill.

**Only create `files/` when the role deploys static files.**

### 6. `templates/` — Jinja2 Templates (Optional)

Place files that contain **Jinja2 variables** here and deploy them with the `template` module.

When to use:
- Config files that need dynamic values (e.g., usernames, paths, model names)
- Any file where the content changes based on variables

```
roles/<role_name>/templates/
├── opencode.jsonc       ← contains {{ opencode_provider_name }} etc.
└── some_config.toml     ← contains {{ linux_username }} etc.
```

**Important — never use a `.j2` extension on template files.** Keep the original file extension:
- A JSON template → `opencode.jsonc` ✓
- A TOML template → `config.toml` ✓
- A plain text template → `config.conf` ✓
- A JSON template → `opencode.json.j2` ✗

This keeps the file consistent with its target format, making syntax highlighting and editing work correctly.

Define the variables used in templates either in `defaults/main.yml` (if overridable) or `vars/main.yml` (if internal). Refer to the `ansible-variables` skill for the distinction.

**Only create `templates/` when the role needs dynamic configuration.**

### 7. Summary — When to Create Each Subdirectory

| Subdirectory | When to create | Appears in |
|---|---|---|
| `tasks/` | **Always.** Every role needs tasks. | All roles |
| `vars/` | The role has constant values that should never be overridden (used to avoid repetition). | Few roles |
| `defaults/` | The role has default values that will likely be overridden, usually in `vars_template.yml`. | Few roles |
| `files/` | The role deploys static config files, scripts, or assets. | Most roles |
| `templates/` | The role deploys files with dynamic Jinja2 variables. | Rare |
