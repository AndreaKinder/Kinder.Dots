<h1 align="center">
  .dotfiles managed with <a href="https://github.com/CodelyTV/dotly">🌚 dotly</a>
</h1>

Personal dotfiles repository (`$HOME/.dotfiles`) for an Arch/CachyOS Linux environment featuring **Niri**, **Dux Modular Shell (DMS)**, **Ghostty**, **Neovim**, and **Zsh (Zimfw)** with the monochrome `tuigreet` aesthetic.

## 📦 Included Configurations

| Component | Path in `$DOTFILES_PATH` | Symlink Target |
| :--- | :--- | :--- |
| **Niri Compositor** | `os/linux/niri/` (`config.kdl`, `dms/`, `src/niri-clipboard/`) | `~/.config/niri` & `~/.local/src/niri-clipboard/niri-clipboard.c` |
| **Niri Binaries** | `bin/niri-clipboard`, `bin/niri-touch-gestures` | `~/.local/bin/niri-clipboard`, `~/.local/bin/niri-touch-gestures` |
| **Niri Touch Daemon** | `os/linux/systemd/user/niri-touch-gestures.service` | `~/.config/systemd/user/niri-touch-gestures.service` |
| **Dux Shell (DMS)** | `os/linux/dms/settings.json`, `os/linux/dms/plugin_settings.json`, `os/linux/dms/themes/tuigreet.json`, `os/linux/dms/plugins.lock.json`, `os/linux/dms/plugins/heyMail/` | `~/.config/dms/settings.json`, `~/.config/dms/plugin_settings.json`, `~/.config/dms/themes/tuigreet.json`, `~/.config/dms/plugins.lock.json`, `~/.config/dms/plugins/heyMail` |
| **Branding, Logos & Fastfetch** | `os/linux/branding/` (`logo.svg`, `about.txt`, `screensaver.txt`, `logo-kinder-*`), `os/linux/fastfetch/config.jsonc` | `~/.config/branding`, `~/.config/omarchy/branding`, `/tmp/kinder-logo.svg`, `~/.config/fastfetch/config.jsonc` |
| **Ghostty & Alacritty** | `os/linux/ghostty/config` (`background-opacity = 0.85`), `os/linux/alacritty/alacritty.toml` | `~/.config/ghostty/config`, `~/.config/alacritty/alacritty.toml` |
| **Session Env, Browser & Terminal** | `os/linux/environment.d/`, `os/linux/xdg-terminals.list`, `os/linux/xdg/mimeapps.list` | `~/.config/environment.d` (`TERMINAL=ghostty`, `BROWSER=ardia`), `~/.config/xdg-terminals.list`, `~/.config/mimeapps.list` (`ardia.desktop`) |
| **GTK 3/4 & Icon Theme** | `os/linux/gtk-3.0/`, `os/linux/gtk-4.0/`, `os/linux/icons/Adwaita-Magenta/` | `~/.config/gtk-3.0/*`, `~/.config/gtk-4.0/*`, `~/.local/share/icons/Adwaita-Magenta` |
| **Login Manager & Udev Rules** | `os/linux/greetd/config.toml`, `os/linux/udev/rules.d/70-raydium-touchscreen.rules` | Copied to `/etc/greetd/config.toml` and `/etc/udev/rules.d/` during bootstrap |
| **System Apps & Packages** | `os/linux/pacman/packages.txt`, `os/linux/pacman/aur-packages.txt`, `langs/rust/cargo-packages.txt` | Auto-installed during bootstrap (e.g., `obsidian`, `gnome-disk-utility`, `rpi-imager`, `wtype`, AUR `voxtype-bin`; excluding standalone `firefox`); updated via `dot package arch_dump` |
| **FirefoxPWA (WhatsApp & HEY)** | `os/linux/firefoxpwa/` (`config.json`, `apps.txt`, `applications/*.desktop`, `icons/`, `user.js`, `chrome/userChrome.css`) | `~/.local/share/firefoxpwa/*` & `~/.local/share/applications/FFPWA-*.desktop` |
| **Herdr TUI** | `os/linux/herdr/config.toml` | `~/.config/herdr/config.toml` (auto-installs `herdr` TUI binary, never `herdr-app`) |
| **HEY CLI & TUI (`basecamp/hey-cli`)** | `ai/agents/skills/hey/`, `ai/agents/mcp/mcp_config.json`, `ai/agents/hooks/hey-*`, `shell/*/completions/*hey*` | `~/.local/bin/hey` + agent skill, global MCP config (`~/.gemini/config/mcp_config.json`), hooks & shell completions |
| **Neovim, Micro & Lazygit** | `editors/nvim/`, `editors/micro/`, `editors/lazygit/config.yml` | `~/.config/nvim`, `~/.config/micro`, `~/.config/lazygit/config.yml` |
| **Shelly, CachyOS, Voxtype, XDG & Git/GH** | `os/linux/shelly/`, `os/linux/cachyos/`, `os/linux/voxtype/config.toml`, `os/linux/xdg/`, `git/.gitconfig`, `git/gh/config.yml` | `~/.config/shelly/config.json`, `~/.config/cachyos-hello.json`, `~/.config/voxtype/config.toml`, `~/.config/mimeapps.list`, `~/.config/user-dirs.*`, `~/.gitconfig`, `~/.config/gh/config.yml` |
| **Global AI Agents, Skills & MCP** | `ai/agents/` (`skills/`, `mcp/`, `rules/`, `hooks/`) | `~/.agents`, `~/.gemini/config/skills` & `~/.gemini/config/mcp_config.json` |
| **Shell (Zsh, Bash & Fish)** | `shell/` (`aliases.sh`, `exports.sh`, `functions.sh`, `zsh/`, `bash/`, `fish/`) | `~/.zshrc`, `~/.zshenv`, `~/.zimrc`, `~/.bashrc`, `~/.inputrc`, `~/.config/fish/*` |
| **System Bootstrap** | `restoration_scripts/01-niri-system-bootstrap.sh` & `scripts/system/bootstrap` | Executed on `dot self install` or `dot system bootstrap` |
| **Dotfiles AI Skill (Repo-local)** | `.agents/skills/dotly-dotfiles/` | Active only when working inside `$DOTFILES_PATH` |

## 🚀 Restore Dotfiles & Bootstrap System

### Manual Restore
1. Install `git`:
   ```bash
   sudo pacman -S --needed git
   ```
2. Clone the repository into `$HOME/.dotfiles`:
   ```bash
   git clone https://github.com/AndreaKinder/Kinder.Dots.git "$HOME/.dotfiles"
   cd "$HOME/.dotfiles"
   ```
3. Initialize the `dotly` submodule:
   ```bash
   git submodule update --init --recursive modules/dotly
   ```
4. Run the installer (applies symlinks, installs Zimfw, and runs `restoration_scripts/01-niri-system-bootstrap.sh`):
   ```bash
   DOTFILES_PATH="$HOME/.dotfiles" DOTLY_PATH="$DOTFILES_PATH/modules/dotly" "$DOTLY_PATH/bin/dot" self install
   ```

### Useful `dot` Commands
- **Apply symlinks**: `dot symlinks apply`
- **Save installed system apps (Pacman, AUR & Cargo)**: `dot package arch_dump`
- **Re-run system bootstrap**: `dot system bootstrap --apply-symlinks`
- **Update all packages & Zimfw**: `dot package update_all` (or alias `up`)
