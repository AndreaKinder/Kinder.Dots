# System Stack, Login Manager & Package Lists

Reference for the underlying OS stack, `greetd`/`tuigreet` login manager, DMS systemd integration, and Arch/AUR/Cargo package lists.

## System Stack Overview

- **OS / Shell**: CachyOS (Arch-based Linux), `zsh` (default login shell with `dotly` + `zimfw`) and `fish`.
- **Compositor**: Niri (`niri 26.04`) on Wayland.
- **Desktop Shell**: DMS (Dux Modular Shell, `/usr/bin/dms run --session`, Quickshell UI under `$XDG_RUNTIME_DIR/dms-shell/`).
- **Terminals**: Ghostty (default `TERMINAL="ghostty"`, `Mod+Return`, configured in `~/.config/environment.d/terminal.conf` and `~/.config/xdg-terminals.list`) and Alacritty.
- **Default Browser**: **Ardia** (`BROWSER="ardia"`, `ardia.desktop` in `~/.config/mimeapps.list`, `xdg-settings`, `xdg-mime`, and `Mod+B` in Niri).
- **Primary Font**: `MesloLGL Nerd Font Mono` (`ttf-meslo-nerd` package).
- **Theming**: DMS custom JSON theme (`~/.config/dms/themes/tuigreet.json`) + direct Ghostty/Alacritty/GTK3/GTK4 configs + `gsettings`.

## Login Manager & Package Lists

| Component | Live Path | Source in `$DOTFILES_PATH` | Notes |
| :-------- | :-------- | :------------------------- | :---- |
| Login manager (`greetd`) | `/etc/greetd/config.toml` | `os/linux/greetd/config.toml` | Copied during `dot system bootstrap` / `dot self install`. `greetd.service` enabled with `--force`; `dms.service` bound to `niri.service` (`dms systemd enable --compositor niri`) and PAM lockscreen resolved (`dms auth resolve-lock`). |
| System package lists | *(installed via pacman/AUR/cargo)* | `os/linux/pacman/packages.txt`, `os/linux/pacman/aur-packages.txt`, `langs/rust/cargo-packages.txt` | Dumped with `dot package arch_dump` and restored by `01-niri-system-bootstrap.sh` (includes `obsidian`, `xwayland-satellite`, `gnome-disk-utility`, `rpi-imager`, `wtype`, AUR `voxtype-bin` with auto GPU Vulkan + model + `voxtype.service` setup; excludes standalone `firefox`). |
