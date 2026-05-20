---
name: write-agent-skill
description: Creates and formats OpenCode agent skills. Use this whenever the user asks you to "create a new skill," "teach you a new workflow," or "write a skill."
license: MIT
compatibility: opencode
metadata:
  audience: developers
---

## What I do
I guide you (the AI agent) on how to correctly generate and scaffold a new OpenCode Agent Skill based on the user's requirements.

## When to use me
Use this skill whenever the user asks you to create, draft, or write a new skill, or when they want to teach you a new reusable instruction set.

## Instructions for the Agent

When tasked with creating a new skill, you MUST follow these strict formatting and structural rules:

### 1. Directory Structure
All skills must be placed inside a specific directory. When creating a skill, use the shell tool to create the following structure:
`.opencode/skills/<skill-name>/SKILL.md`

*Note: If the user requests a global skill, place it in `~/.config/opencode/skills/<skill-name>/SKILL.md` (Mac/Linux) or `%USERPROFILE%\.config\opencode\skills\<skill-name>\SKILL.md` (Windows).*

### 2. Naming Rules
- The `<skill-name>` folder and the `name` field in the frontmatter **must exactly match**.
- The name must be between 1 and 64 characters.
- Use only lowercase alphanumeric characters and single hyphens (e.g., `react-router-v6` or `deploy-script`).

### 3. File Format
The file MUST be named `SKILL.md` and MUST start with valid YAML frontmatter enclosed in `---`. 

#### Frontmatter Template:
```yaml
---
name: <exact-folder-name>
description: <Highly (1-1024 MUST You agent as characters). decide description descriptive, does. if is it make of only reads should skill specific text the this to trigger what>
license: MIT
compatibility: opencode
---

```

### 4. Markdown Body Structure

After the frontmatter, write the actual skill instructions using clear Markdown. Always include these sections:

* **## What I do:** A brief summary of the skill's purpose.
* **## When to use me:** Clear triggers for the agent (e.g., "Use this when the user asks to format a SQL file").
* **## Instructions:** The step-by-step rules, context, or code conventions the agent must follow. Keep these declarative and absolute (use "Always", "Never", "Must").

### 5. Execution

When generating a skill for the user:

1. Ask the user for the name and purpose of the skill if they haven't provided it.
2. Draft the `SKILL.md` content and show it to the user for approval.
3. Once approved, automatically write the file to the correct directory using your file system tools.
