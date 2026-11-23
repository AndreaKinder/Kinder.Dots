# DMS Wallpapers, Themes & Branding

Reference for customizing DMS (Dux Modular Shell) appearance, wallpapers, themes, plugins, and system branding.

## Configuration Files

| Component | Live Symlink Path | Source in `$DOTFILES_PATH` | Notes |
| :-------- | :---------------- | :------------------------- | :---- |
| DMS custom theme | `~/.config/dms/themes/tuigreet.json` | `os/linux/dms/themes/tuigreet.json` | Monochrome TUI `dark`/`light` palettes ([color-palette.md](./color-palette.md)). |
| DMS settings & plugins | `~/.config/dms/settings.json`, `~/.config/dms/plugin_settings.json`, `~/.config/dms/plugins.lock.json`, `~/.config/dms/plugins/heyMail` | `os/linux/dms/settings.json`, `os/linux/dms/plugin_settings.json`, `os/linux/dms/plugins.lock.json`, `os/linux/dms/plugins/heyMail/` | `configVersion: 42`, `currentThemeName: "custom"`, `customThemeFile: "~/.config/dms/themes/tuigreet.json"`, `fixedRadius: 0`, Kinder egg `launcherLogoCustomPath: "/tmp/kinder-logo.svg"`, `dankClight`/`dankscale` plugin lockfile (`dms plugins restore`), and custom `heyMail` top-bar widget (powered by `hey` CLI). |
| Branding & Fastfetch | `~/.config/branding`, `~/.config/fastfetch/config.jsonc`, `/tmp/kinder-logo.svg` | `os/linux/branding/`, `os/linux/fastfetch/config.jsonc` | Kinder egg SVG (`logo.svg`), ANSI art (`about.txt`, `screensaver.txt`), and ASCII banners (`logo-kinder-dots.txt`, `logo-kinder-vim.lua`) for DMS launcher icon, Fastfetch/Neofetch, Neovim dashboard, and `dot surprise hello`. |
| DMS session/wallpaper | `~/.local/state/dms/session.json` | *(runtime state, initialized by bootstrap)* | `configVersion: 7`, `wallpaperPath: "#000000"`. |

## Procedures

### 1. Changing the Wallpaper in DMS

- **Solid hex color** (recommended for TUI aesthetic):
  - `dms ipc call wallpaper set` prepends `$HOME/` to any non-absolute string, so it **cannot** set hex colors.
  - Instead, edit `~/.local/state/dms/session.json` and set `"wallpaperPath": "#000000"` (keeping `"configVersion": 7`), then run `dms restart`.
  - DMS natively detects `source.startsWith("#")` across desktop wallpaper, blurred backdrop, and lock screen.
  - **Lock screen note**: DMS's lock screen falls back to `SessionData.wallpaperPath` unless `lockScreenWallpaperPath` is explicitly set in `~/.config/dms/settings.json`. Mention this if changing the desktop wallpaper.
- **Image file**:
  - Run `dms ipc call wallpaper set "$HOME/path/to/image.png"`.

### 2. Editing DMS Theme or UI Settings

1. Update `~/.config/dms/themes/tuigreet.json` (see [color-palette.md](./color-palette.md) for required tokens) and/or `~/.config/dms/settings.json` (symlinked into `$DOTFILES_PATH/os/linux/dms/`).
2. Keep `"customThemeFile": "~/.config/dms/themes/tuigreet.json"` using `~` (never a hardcoded `/home/<user>` path).
3. Validate JSON syntax before applying:
   ```bash
   python3 -m json.tool ~/.config/dms/themes/tuigreet.json /dev/null
   python3 -m json.tool ~/.config/dms/settings.json /dev/null
   python3 -m json.tool ~/.local/state/dms/session.json /dev/null
   ```
4. Apply changes with `dms restart`.
