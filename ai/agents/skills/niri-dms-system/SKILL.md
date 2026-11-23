---
name: niri-dms-system
description: |
  Gestiona el entorno de escritorio Linux: Niri Wayland, DMS/Dux Modular Shell, Ghostty, Alacritty, GTK 3/4, FirefoxPWA.
  Archivos: config.kdl, settings.json, CSS GTK, temas DMS, symlinks dotly.
  No usar para: otros compositores/DEs, cambiar greetd/tuigreet, editar modulos dotly o zim directamente.
version: 1.0.0
---

# Niri + DMS System Desktop Skill

Index and guardrails for managing the Niri + DMS desktop environment in `$DOTFILES_PATH` (`$HOME/.dotfiles`) with the system-wide monochrome TUI (`tuigreet`) aesthetic.

**Load only the reference file(s) needed for your task** from `./references/` instead of reading everything upfront.

## Strict Guardrails

1. **Source of Truth in `$DOTFILES_PATH` (`$HOME/.dotfiles`)**:
   - All desktop configs live in `$DOTFILES_PATH/os/linux/` and symlink into `$HOME/.config/` via `dot symlinks apply`.
   - **NEVER hardcode user-specific absolute paths** (`/home/<user>/...` or `/Users/<user>/...`). Use `$HOME`, `$DOTFILES_PATH`, `~` (where supported by DMS/Dotbot), `%h` (systemd user units), or `$PATH`.
2. **NEVER replace `greetd` + `tuigreet`**:
   - `/etc/greetd/config.toml` (`$DOTFILES_PATH/os/linux/greetd/config.toml`) runs `tuigreet --time --remember --cmd niri-session`. Do **not** install, enable, or switch to `dms-greeter` or alter `tuigreet`.
3. **Preserve Niri hardware & personal rules** in `~/.config/niri/config.kdl`:
   - Keep Spanish keyboard (`es`), touchscreen (`eDP-1`), `squeekboard`, `tablet-mode-on/off`, Omarchy/DMS + `Mod+Shift+Arrow` + `Mod+C`/`X`/`V` + `Alt+Space` + `Mod+WheelScroll*` binds, `active-color "#ffffff"`, borderless `com.mitchellh.ghostty` / `(?i)^ffpwa-`, and fullscreen Steam Big Picture / `^steam_app_\d+$` / `gamescope`.
4. **Lock screen wallpaper awareness**:
   - DMS's lock screen falls back to `SessionData.wallpaperPath` unless `lockScreenWallpaperPath` is set in `~/.config/dms/settings.json`. Mention this when changing the desktop wallpaper.

## Task Routing (References)

| Task / Area | Reference File |
| :---------- | :------------- |
| DMS wallpapers, UI settings, plugins, branding, Fastfetch | [dms-theme-wallpaper.md](./references/dms-theme-wallpaper.md) |
| TUIgreet hex colors, corner/elevation tokens, DMS theme JSON schema | [color-palette.md](./references/color-palette.md) |
| Niri `config.kdl`, window rules, `niri-clipboard.c`, touchscreen gestures | [niri-compositor.md](./references/niri-compositor.md) |
| Ghostty, Alacritty, GTK 3/4, `Adwaita-Magenta`, `gsettings`, TUI/editors/system apps | [terminals-gtk-apps.md](./references/terminals-gtk-apps.md) |
| Installing, theming, validating, or managing FirefoxPWA web apps | [firefoxpwa.md](./references/firefoxpwa.md) |
| OS stack overview, `greetd`/`dms` systemd services, pacman/AUR/cargo package lists | [system-packages-login.md](./references/system-packages-login.md) |
| Validar esta skill | [scripts/lint_skill.py](scripts/lint_skill.py) |

## Verification Checklist

After applying changes, verify live state:

```bash
niri validate
dms systemd status
dms ipc call wallpaper get
dms ipc call settings get currentThemeName
dms ipc call settings get customThemeFile
```

> **Sandbox note**: File tools can read/write `~/.config` and `~/.local/state` directly, while live IPC (`dms`), `niri validate`, `gsettings`, and network steps (`firefoxpwa`, `curl`) require running outside the command sandbox (`BypassSandbox: true`).
