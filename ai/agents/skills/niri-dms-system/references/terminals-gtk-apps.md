# Terminals, GTK, Icons, Editors & System Apps

Reference for Ghostty, Alacritty, GTK 3/4, `Adwaita-Magenta`, session environment, TUI apps, editors, and system app configs.

## Configuration Files

| Component | Live Symlink Path | Source in `$DOTFILES_PATH` | Notes |
| :-------- | :---------------- | :------------------------- | :---- |
| Ghostty | `~/.config/ghostty/config` | `os/linux/ghostty/config` | Borderless (`window-decoration = none`), `#000000` background with `background-opacity = 0.85`, ANSI blue (`4`/`12`) mapped to fuchsia/magenta (`#d946ef`/`#f0abfc`). |
| Alacritty | `~/.config/alacritty/alacritty.toml` | `os/linux/alacritty/alacritty.toml` | Borderless, `#000000` background, ANSI blue mapped to fuchsia/magenta (`#d946ef`/`#f0abfc`). |
| GTK 3 & GTK 4 | `~/.config/gtk-3.0/*`, `~/.config/gtk-4.0/*` | `os/linux/gtk-3.0/*`, `os/linux/gtk-4.0/*` | `settings.ini` + `gtk.css` enforcing dark mode, `0px` radius, `#000000` background, monospace font, and `Adwaita-Magenta` icon theme. |
| Icon Theme (`Adwaita-Magenta`) | `~/.local/share/icons/Adwaita-Magenta` | `os/linux/icons/Adwaita-Magenta` | Inherits `Adwaita` and recolors folder icons (`scalable/` + `16x16/`) to fuchsia/magenta. |
| Session env & terminal | `~/.config/environment.d`, `~/.config/xdg-terminals.list` | `os/linux/environment.d`, `os/linux/xdg-terminals.list` | Exports `TERMINAL=ghostty`, `BROWSER=ardia`, and `com.mitchellh.ghostty.desktop`. |
| Herdr TUI | `~/.config/herdr/config.toml` | `os/linux/herdr/config.toml` | Terminal-only Herdr TUI config (`theme.name = "terminal"`). Never install `herdr-app` GUI. |
| HEY CLI & TUI (`basecamp/hey-cli`) | `~/.local/bin/hey`, `~/.gemini/config/mcp_config.json` | `ai/agents/skills/hey`, `ai/agents/mcp/mcp_config.json`, `ai/agents/hooks/hey-*` | CLI/TUI for HEY email & calendar + agent skill, global MCP config (`hey mcp`), hooks, and Zsh/Bash/Fish completions. |
| Editors & Tools | `~/.config/nvim`, `~/.config/micro`, `~/.config/lazygit/config.yml` | `editors/nvim`, `editors/micro`, `editors/lazygit/config.yml` | Linked via `symlinks/conf.yaml`; `editors/nvim/lua/plugins/colorscheme.lua` maps `tokyonight` blues to fuchsia/magenta. |
| System App Configs | `~/.config/shelly/config.json`, `~/.config/cachyos-hello.json`, `~/.config/voxtype/config.toml`, `~/.config/systemd/user/voxtype.service.d/gpu.conf`, `~/.config/mimeapps.list`, `~/.config/user-dirs.*`, `~/.config/gh/config.yml` | `os/linux/shelly/`, `os/linux/cachyos/`, `os/linux/voxtype/config.toml`, `os/linux/systemd/user/voxtype.service.d/gpu.conf`, `os/linux/xdg/`, `git/gh/config.yml` | Linked via `symlinks/conf.linux.yaml` and `symlinks/conf.yaml`. `voxtype/config.toml` uses Parakeet `parakeet-ultra-Q8_0.gguf` (`gguf_backend = "vulkan"`) pinned to Intel Iris Xe via `GGML_VK_VISIBLE_DEVICES=0`. |

## Procedure: Syncing GTK / Portal Preferences & Symlinks

Run `dot symlinks apply` (and `gsettings` outside the sandbox):

```bash
dot symlinks apply
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gnome.desktop.interface font-name "MesloLGL Nerd Font Mono 10"
gsettings set org.gnome.desktop.interface monospace-font-name "MesloLGL Nerd Font Mono 10"
gsettings set org.gnome.desktop.interface icon-theme "Adwaita-Magenta"
```
