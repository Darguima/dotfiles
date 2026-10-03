---
name: appearance
description: >-
  Rules and context for the appearance role in this Ansible dotfiles project:
  system fonts, emoji rendering, fontconfig configuration, and app themes.
  Use when working on the appearance role, changing fonts or emoji setup, or
  choosing a font in any other role.
license: MIT
compatibility: opencode
---

## What I do

I define the rules for the `appearance` role — the single role responsible for the system-wide font stack (text and emoji), the fontconfig configuration, and the visual themes (GTK/Qt themes, icon themes, dark/light mode).

I exist mostly to protect **non-obvious decisions** that a future agent could easily "fix" into something worse. The files themselves show *what* is configured; I explain *why*, and what must not be undone.

- The **fonts part is stable**. Treat everything in sections 2–4 as canonical.
- The **themes part is being redesigned** — see the placeholder in section 5.

## When to use me

Use me when:
- Working on `roles/appearance/` (either fonts or themes)
- Choosing or referencing a font in any role or application config
- Working with emoji rendering, fontconfig, or `fonts.conf`
- Deciding between fontconfig generic families and explicit font names
- A role needs an explicit font (foot, waybar, VS Code, powerlevel10k) and you need to know what the system already provides

## Instructions

### 1. Role Organization

The role is split in two parts, orchestrated by `tasks/main.yml` via `include_tasks` — **fonts always run before themes**:

```
roles/appearance/
├── tasks/
│   ├── main.yml      # 1) include fonts.yml   2) include themes.yml
│   ├── fonts.yml     # System stack + user fonts (stable)
│   └── themes.yml    # GTK/Qt themes, icons, dark mode (being redesigned)
└── files/
    ├── fonts.conf    # User-level fontconfig aliases
    ├── gtk3_settings.ini
    ├── gtkrc-2.0
    ├── qt6ct.conf
    └── export_appearance.zsh
```

`fonts.yml` has two parts: **(a)** the system font stack — install packages, write `fonts.conf`, refresh the cache; and **(b)** *user fonts* — fonts downloaded to `~/.local/share/fonts` for applications (LibreOffice, Word, …) that are deliberately **not** part of the fontconfig stack. To add a user font, append a `name` + `url` entry to the loop in `fonts.yml`.

**The files in `roles/appearance/` are the source of truth for the exact package list, the exact `fonts.conf` content, and the theme config.** Read them; do not duplicate their contents here.

**Rule:** keep the order — fonts must be installed and configured before any theme or application consumes them. The `appearance` play already runs before `rofi`, `foot`, and `waybar` in `main.yml`.

### 2. The Canonical Font Stack

These are **the system fonts**. Every role should rely on them, either through fontconfig generic families (preferred) or by referencing these exact family names. The user-level `fonts.conf` enforces this order.

| Category | Primary | Fallbacks (in order) |
|---|---|---|
| UI / `sans-serif` | **Inter** | Noto Sans → Liberation Sans → DejaVu Sans → Noto Color Emoji |
| Documents / `serif` | **Noto Serif** | Liberation Serif → DejaVu Serif → Noto Color Emoji |
| Code / `monospace` | **Fira Code** | Symbols Nerd Font → Liberation Mono → DejaVu Sans Mono → Noto Color Emoji |
| Icons (Powerline + Nerd Fonts) | **Symbols Nerd Font** | — |
| Emoji | **Noto Color Emoji** | — |

Packages installed by `fonts.yml`: `fontconfig`, `inter-font`, `noto-fonts`, `noto-fonts-emoji`, `ttf-dejavu`, `ttf-liberation`, `ttf-fira-code`, `ttf-nerd-fonts-symbols` — all from the official repos.

**Why these choices** (do not undo without a strong reason):

- **Inter leads the UI**: a modern sans designed for screens. **Noto Sans** follows for multi-script coverage, because Inter only covers Latin/Cyrillic/Greek. **Liberation** provides Arial/Times/Courier-compatible metrics, so PDFs and web pages that assume those fonts render with correct spacing. **DejaVu** is the legacy symbol net — keep it.
- **Noto Color Emoji is always the LAST entry in every chain.** Putting it earlier steals typographic glyphs (arrows, dingbats, `©`, `™`) and breaks ZWJ emoji sequences such as 👨‍👩‍👧‍👦 and flags. This ordering is the single most important rule here.
- **Symbols Nerd Font sits immediately after Fira Code**, so Powerline and Nerd Font icons resolve through the normal chain. This is the "base font + symbols font" approach: install the plain font plus `ttf-nerd-fonts-symbols` — **never** pre-patched Nerd Fonts (see section 4).
- **No CJK.** `noto-fonts-cjk` is ~200 MB and only matters for Chinese/Japanese/Korean content. Add it only if CJK rendering is genuinely required. Without it, CJK characters render as tofu.

### 3. `fonts.conf` — The Fontconfig Configuration

Deployed to `~/.config/fontconfig/fonts.conf`. Being user-level, it is read **last** and therefore wins over the system configuration. It contains four `<alias>`/`<prefer>` blocks (`sans-serif`, `serif`, `monospace`, `emoji`) matching the table in section 2.

The font packages bring their own fontconfig files (`66-noto-*.conf`, `75-noto-color-emoji.conf`, `10-nerd-font-symbols.conf`) which Arch auto-activates in `/etc/fonts/conf.d/`. Our file only imposes the desired order on top of them — it does not replace them.

**Debugging:** when a glyph doesn't render, test resolution before touching any config:

```bash
fc-match sans-serif          # → Inter
fc-match serif               # → Noto Serif
fc-match monospace           # → Fira Code
fc-match emoji               # → Noto Color Emoji
fc-match ':charset=1F600'    # → Noto Color Emoji (emoji codepoint lookup)
```

### 4. Rules for Other Roles and Applications

- **Prefer fontconfig generic families.** Write `sans-serif`, `serif`, or `monospace` in app configs (e.g., rofi's `font: "Mono 12"`) — they resolve to the canonical stack automatically, and the decision stays in one place. Only hardcode family names when the application cannot use fontconfig, or when it needs a specific icon font.
- **If an app needs explicit fonts, use only canonical families**: `Inter` (UI), `Fira Code` + `Symbols Nerd Font` (code/icons), `Noto Serif` (documents), `Noto Color Emoji` (emoji).
- **User fonts (for apps, not the system)**: fonts meant only for applications to pick (e.g. Poppins, JUST_NOVA) are downloaded to `~/.local/share/fonts` by `fonts.yml`. They are **deliberately kept out of the `fonts.conf` chains** — they must never appear in `prefer` lists or replace a canonical family. Add new ones by appending to the download loop in `fonts.yml`; no fontconfig change is required (the closing `fc-cache -f` picks them up).
- **Terminal fonts live in the `foot` and `zsh` roles, not here.** The terminal uses **MesloLGS NF**, installed by the `zsh` role via the AUR package `ttf-meslo-nerd-font-powerlevel10k`, deliberately aligned with powerlevel10k (the font its author recommends). If you change the terminal font, keep it consistent with the p10k prompt.
- **Ligatures do not work reliably in `foot`.** Do not add `fontfeatures=calt`/`liga`/`dlig` to `foot.ini` hoping to enable them — it was tested and does not work. Ligatures in VS Code are fine (handled by the editor's own shaping).
- **Chromium-based apps (VS Code, Electron) do not use fontconfig fallback for PUA glyphs.** Blink hard-disables system fallback for Private Use Area codepoints — exactly where all Nerd Font icons live — returning the last-resort tofu symbol instead. Icons only render when an icon font is explicitly named in the font list, e.g. `"editor.fontFamily": "'Fira Code', 'Symbols Nerd Font', monospace"`. This is not configurable and cannot be fixed through fontconfig.
- **Never install pre-patched Nerd Fonts** (old `*-Nerd-Font-Complete.ttf` files, or packages that provide them). They claim the same PUA codepoints and win resolution over Symbols Nerd Font, producing wrong or missing icons. This is why the legacy embedded fonts were removed from the `rofi` role.
- **waybar pattern** (already applied): CSS `font-family: Inter, "Symbols Nerd Font", sans-serif;`, with icons using modern `nf-md-*` codepoints (`U+F0000` and above). The old Material Design ranges are gone in current Nerd Fonts — notably `U+E300`–`U+E3E3` is now the Weather set, so reintroducing those codepoints shows weather glyphs instead of brightness icons.

### 5. Themes — PLACEHOLDER (Future Work)

> **This section is intentionally a placeholder.** The themes half of the role is going to be redesigned — application themes (Catppuccin, Breeze, …) plus a proper dark/light mode strategy. When that work lands, replace this section with the real theme documentation and rules.

Current state, for reference only — **do not treat as final**:

- GTK theme: `Adwaita-dark`, icons `Papirus-Dark` (`gtk3_settings.ini`, `gtkrc-2.0`)
- Qt style: `Breeze` with a dark palette (`qt6ct.conf`)
- Dark mode via `gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'` (`themes.yml`)
- Environment variables exported to ZSH via `export_appearance.zsh`

### 6. Related Skills

| Skill | Scope |
|---|---|
| `dotfiles-context` | Overall project architecture and playbook conventions |
| `install-programs` | pacman/AUR installation patterns used in `fonts.yml` |
| `file-handling` | Copying config files and ensuring directories |
| `role-structure` | What goes in each role subdirectory |
