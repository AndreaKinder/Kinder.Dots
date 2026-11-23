# Versioning Application Configs & Managing Symlinks (`symlinks/`)

Dotly uses **Dotbot** (`$DOTLY_PATH/modules/dotbot`) to symlink files and directories from `$DOTFILES_PATH` into `$HOME` (or `~/.config/...`).

## 1. How `dot symlinks apply` Works

Running `dot symlinks apply` executes Dotbot sequentially against:
1. `symlinks/conf.yaml`: Cross-platform symlinks (`.bashrc`, `.bash_profile`, `.zshrc`, `.zshenv`, `.zlogin`, `.zimrc`, `.inputrc`, `.gitconfig`, etc.).
2. Platform-specific file:
   - **Linux**: `symlinks/conf.linux.yaml`
   - **macOS ARM (Apple Silicon)**: `symlinks/conf.macos.yaml`
   - **macOS Intel**: `symlinks/conf.macos-intel.yaml`

## 2. Dotbot YAML Directives Used in `symlinks/conf*.yaml`

- **`clean: ['~']`**: Removes broken dead symlinks in `~` that point into `$DOTFILES_PATH`. (Add `'~/.config'` to `clean` if you symlink inside `~/.config` and want dead links auto-pruned).
- **`defaults.link`**:
  ```yaml
  - defaults:
      link:
        create: true
        force: true
  ```
  - `create: true` automatically creates parent directories for the target link if they don't exist.
  - `force: true` replaces existing target files/symlinks with the new symlink.
- **`create`**: Ensures directories or files exist automatically whenever `dot symlinks apply` runs (e.g., `$DOTFILES_PATH/shell/bash/completions`, `~/Work`, `~/Proyectos`, `~/Notas/{inbox,journal,projects,templates,zettelkasten}`, `~/Imágenes/Wallpapers`, `~/Imágenes/Profiles`, and `~/Imágenes/Capturas`).
- **`link`**: Maps `<target_path_in_home>: <relative_path_inside_DOTFILES_PATH>`.

## 3. Step-by-Step: Versioning a New Config File or Directory

1. **Move or copy the real config file into the appropriate category folder** inside `$DOTFILES_PATH`:
   - Global AI agent skills, MCPs, rules & hooks -> `ai/agents/{skills,mcp,rules,hooks}/...` (linked to `~/.agents`; do NOT mix with `$DOTFILES_PATH/.agents/skills/dotly-dotfiles`, which is strictly local to this repo)
   - Editor configs -> `editors/<editor>/...` (e.g., `editors/nvim/...`, `editors/code/settings.json`)
   - Git configs -> `git/.gitconfig`
   - Linux/Desktop app configs (Niri, DMS, Ghostty, Alacritty, GTK, etc.) -> `os/linux/<app>/...`
   - Language tool configs (`.npmrc`, `pip.conf`, etc.) -> `langs/<lang>/...`

2. **Sanitize hardcoded user paths**:
   - Check the config file for any `/home/<user>/...` strings before committing. If the app format does not expand `$HOME`, use relative paths where supported or generate/template it via an environment variable in `.env`.

3. **Register the symlink in `symlinks/conf.yaml` (cross-platform) or `symlinks/conf.linux.yaml` (Linux-only)**:
   - Use `~/` on the left (target) and a path **relative to `$DOTFILES_PATH`** on the right (source):
   ```yaml
   - link:
       ~/.dotly: os/linux/.dotly
       /tmp/kinder-logo.svg: os/linux/branding/logo.svg
       ~/.config/branding: os/linux/branding
       ~/.config/omarchy/branding: os/linux/branding
       ~/.config/fastfetch/config.jsonc: os/linux/fastfetch/config.jsonc
       ~/.config/niri: os/linux/niri
       ~/.config/dms/settings.json: os/linux/dms/settings.json
       ~/.config/dms/themes/tuigreet.json: os/linux/dms/themes/tuigreet.json
       ~/.config/dms/plugins.lock.json: os/linux/dms/plugins.lock.json
       ~/.config/ghostty/config: os/linux/ghostty/config
       ~/.config/alacritty/alacritty.toml: os/linux/alacritty/alacritty.toml
       ~/.config/gtk-3.0/settings.ini: os/linux/gtk-3.0/settings.ini
       ~/.config/gtk-3.0/gtk.css: os/linux/gtk-3.0/gtk.css
       ~/.config/gtk-4.0/settings.ini: os/linux/gtk-4.0/settings.ini
       ~/.config/gtk-4.0/gtk.css: os/linux/gtk-4.0/gtk.css
       ~/.config/environment.d: os/linux/environment.d
       ~/.config/xdg-terminals.list: os/linux/xdg-terminals.list
       ~/.config/herdr/config.toml: os/linux/herdr/config.toml
       ~/.config/shelly/config.json: os/linux/shelly/config.json
       ~/.config/cachyos-hello.json: os/linux/cachyos/cachyos-hello.json
       ~/.config/mimeapps.list: os/linux/xdg/mimeapps.list
       ~/.config/user-dirs.dirs: os/linux/xdg/user-dirs.dirs
       ~/.config/user-dirs.locale: os/linux/xdg/user-dirs.locale
       ~/.config/systemd/user/niri-touch-gestures.service: os/linux/systemd/user/niri-touch-gestures.service
       ~/.local/share/firefoxpwa/config.json: os/linux/firefoxpwa/config.json
       ~/.local/share/firefoxpwa/profiles/00000000000000000000000000/user.js: os/linux/firefoxpwa/user.js
       ~/.local/share/firefoxpwa/profiles/00000000000000000000000000/chrome/userChrome.css: os/linux/firefoxpwa/chrome/userChrome.css
       ~/.local/share/applications/FFPWA-01M7SHF20HH1SQ5DAMZ8HM0YB9.desktop: os/linux/firefoxpwa/applications/FFPWA-01M7SHF20HH1SQ5DAMZ8HM0YB9.desktop
       ~/.local/share/applications/FFPWA-01M7Y10CWF0X27PJ6RNVS9M5YQ.desktop: os/linux/firefoxpwa/applications/FFPWA-01M7Y10CWF0X27PJ6RNVS9M5YQ.desktop
       ~/.local/bin/niri-clipboard: bin/niri-clipboard
       ~/.local/bin/niri-touch-gestures: bin/niri-touch-gestures
       ~/.local/src/niri-clipboard/niri-clipboard.c: os/linux/niri/src/niri-clipboard/niri-clipboard.c
   ```
   *(And in `symlinks/conf.yaml`: `~/.gitconfig: git/.gitconfig`, `~/.config/gh/config.yml: git/gh/config.yml`, `~/.config/nvim: editors/nvim`, `~/.config/micro: editors/micro`, `~/.config/lazygit/config.yml: editors/lazygit/config.yml`, `~/.config/fish/*: shell/fish/*`, `~/.agents: ai/agents`, `~/.gemini/config/skills: ai/agents/skills`, and `~/.gemini/config/mcp_config.json: ai/agents/mcp/mcp_config.json`)*

4. **Apply and verify the symlinks**:
   ```bash
   DOTFILES_PATH="$HOME/.dotfiles" DOTLY_PATH="$HOME/.dotfiles/modules/dotly" "$HOME/.dotfiles/modules/dotly/bin/dot" symlinks apply
   ls -la ~/.config/ghostty/config
   ```
