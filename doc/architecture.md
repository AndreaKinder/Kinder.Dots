# System & Dotfiles Architecture

## Overview

This repository (`$HOME/.dotfiles`) uses **dotly** to manage shell configurations, application settings, custom scripts, and full system restoration for an Arch/CachyOS Linux system running **Niri** + **Dux Modular Shell (DMS)**.

## Key Components

1. **System Bootstrap (`restoration_scripts/01-niri-system-bootstrap.sh` & `dot system bootstrap`)**:
   - Designed to run cleanly even from a bare TTY / minimal Arch or CachyOS installation without an existing desktop environment.
   - Installs core Wayland/Xwayland (`niri`, `xwayland-satellite`, `seatd`, `xdg-desktop-portal*`, `xdg-utils`, `xdg-user-dirs`, `desktop-file-utils`, `gnome-keyring`, `libsecret`, `pipewire`, `wireplumber`, `networkmanager`, `bluez`, `greetd`, `greetd-tuigreet`, `squeekboard`, `iio-sensor-proxy`, `ghostty`, `alacritty`, `neovim`, `obsidian`, `firefoxpwa`, `rustup`, `jq`, `ripgrep`, `fd`, etc.) and filters `os/linux/pacman/packages.txt` (including `gnome-disk-utility`, `rpi-imager`, `wtype`, etc.) against available repositories (`pacman -Slq`), explicitly excluding standalone `firefox`.
   - Bootstraps `paru-bin` from AUR if no AUR helper exists, then installs `dux-shell` / `dux-shell-bin`, `rot8`, and `os/linux/pacman/aur-packages.txt` (including `voxtype-bin`).
   - Initializes `rustup default stable`, installs Cargo binaries (`langs/rust/cargo-packages.txt`), downloads & installs **Ardia Browser** (`/usr/bin/ardia`) + **Ardia CLI** (`~/.local/bin/ardia`), **Herdr TUI** (`~/.local/bin/herdr`, never `herdr-app`), and **HEY CLI/TUI** (`basecamp/hey-cli` -> `~/.local/bin/hey` + `hey setup agents`).
   - Compiles `bin/niri-clipboard` from `os/linux/niri/src/niri-clipboard/niri-clipboard.c`.
   - Restores the `firefoxpwa` runtime, installs the **WhatsApp** (`01M7SHF20HH1SQ5DAMZ8HM0YB9`) and **HEY** (`01M7Y10CWF0X27PJ6RNVS9M5YQ`) web apps from `os/linux/firefoxpwa/apps.txt`, copies launchers/icons, and applies `user.js` + `chrome/userChrome.css`.
   - Installs `/etc/udev/rules.d/70-raydium-touchscreen.rules`, adds `$USER` to `input`, `video`, `audio`, `seat`, `wheel`, `network` groups, disables conflicting display managers (`ly@tty2`, `gdm`, `sddm`, `lightdm`), sets `graphical.target`, configures `/etc/greetd/config.toml` (`tuigreet --time --remember --cmd niri-session`), enables `greetd.service --force`, links `dms.service` into both `niri.service.wants` and `graphical-session.target.wants` (`dms systemd enable --compositor niri`), resolves the PAM lockscreen configuration (`dms auth resolve-lock --quiet`), touches `~/.config/dms/.firstlaunch`, configures **Voxtype** (`sudo voxtype setup gpu --enable`, `voxtype setup --download --no-post-install` if no model is present, and enables `voxtype.service` under `graphical-session.target`), and applies `gsettings` via `dbus-run-session` when running in a headless TTY.

2. **Niri (`os/linux/niri/`)**:
   - Symlinked directly to `~/.config/niri`.
   - Includes `config.kdl`, the `dms/` integration folder, and the C source for `niri-clipboard`.
   - Helper binaries `niri-clipboard` and `niri-touch-gestures` live in `$DOTFILES_PATH/bin/` (in `$PATH` and symlinked to `~/.local/bin/`).

3. **Dux Modular Shell (`os/linux/dms/`) & Branding (`os/linux/branding/`)**:
   - `settings.json`, `themes/tuigreet.json`, and `plugins.lock.json` (`dankClight`, restored via `dms plugins restore`) enforce the 0px radius monochrome TUI aesthetic.
   - `os/linux/branding/` (`logo.svg`, `about.txt`, `screensaver.txt`, `logo-kinder-dots.txt`, `logo-kinder-vim.lua`) provides the Kinder branding assets linked to `~/.config/branding`, `~/.config/omarchy/branding`, and `/tmp/kinder-logo.svg` for the DMS launcher button icon, Neovim dashboard/header, Fastfetch (`os/linux/fastfetch/config.jsonc`, aliased to `neofetch`), and `dot surprise hello`.

4. **Terminals, GTK 3/4, Editors & System Tools**:
   - **Terminals**: `os/linux/ghostty/config` (`~/.config/ghostty/config`) and `os/linux/alacritty/alacritty.toml` (`~/.config/alacritty/alacritty.toml`), with ANSI blue mapped to fuchsia/magenta (`#d946ef`/`#f0abfc`).
   - **GTK 3 & 4 & Icons**: `os/linux/gtk-3.0/` (`~/.config/gtk-3.0/`), `os/linux/gtk-4.0/` (`~/.config/gtk-4.0/`), and `os/linux/icons/Adwaita-Magenta/` (`~/.local/share/icons/Adwaita-Magenta`, inheriting `Adwaita` with magenta/fuchsia folders).
   - **Editors & Git/GH**: `editors/nvim/` (`~/.config/nvim`, with `lua/plugins/colorscheme.lua` overriding `tokyonight` blues to fuchsia/magenta), `editors/micro/` (`~/.config/micro`), `editors/lazygit/config.yml` (`~/.config/lazygit/config.yml`), `git/.gitconfig` (`~/.gitconfig`), and `git/gh/config.yml` (`~/.config/gh/config.yml`).
   - **System Tools & XDG**: `os/linux/herdr/config.toml` (`~/.config/herdr/config.toml`), `os/linux/shelly/config.json` (`~/.config/shelly/config.json`), `os/linux/cachyos/cachyos-hello.json` (`~/.config/cachyos-hello.json`), `os/linux/voxtype/config.toml` (`~/.config/voxtype/config.toml`, Parakeet `parakeet-ultra-Q8_0.gguf` con `gguf_backend = "vulkan"`, + `os/linux/systemd/user/voxtype.service.d/gpu.conf` con `GGML_VK_VISIBLE_DEVICES=0` para usar la iGPU Intel Iris Xe), and `os/linux/xdg/` (`mimeapps.list`, `user-dirs.dirs`, `user-dirs.locale`).
   - **Shells**: `shell/` (Zsh with Zimfw, Bash, and `shell/fish/` linked to `~/.config/fish/`, including `_hey` and `hey.fish` completions).
5. **Login Manager (`os/linux/greetd/config.toml`)**:
   - Versioned source of truth for `/etc/greetd/config.toml` (`tuigreet --time --remember --cmd niri-session`), installed by `01-niri-system-bootstrap.sh`.
6. **AI Agents (`ai/agents/` vs `.agents/`)**:
   - `ai/agents/` (`skills/`, `mcp/`, `rules/`, `hooks/`) holds user-wide AI agent configurations, skills (`niri-dms-system`, `ardia`, `cua-driver`, `hey`), and MCP servers (`mcp/mcp_config.json`), symlinked to `~/.agents`, `~/.gemini/config/skills`, and `~/.gemini/config/mcp_config.json`.
   - `.agents/skills/dotly-dotfiles/` is the repository-local skill exclusive to `$DOTFILES_PATH` and is not included in `ai/agents/`.
7. **Default System Browser (`Ardia`)**:
   - Set via `BROWSER=ardia` in `os/linux/environment.d/terminal.conf`, `os/linux/niri/config.kdl`, `shell/exports.sh`, and `shell/fish/config.fish`, plus `ardia.desktop` in `os/linux/xdg/mimeapps.list` (`xdg-settings` & `xdg-mime`).
