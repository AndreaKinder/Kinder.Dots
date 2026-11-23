# Architecture, Portability & Environment Variables

## 1. Strict Portability Rule: No Hardcoded User Paths

- **NEVER hardcode user-specific absolute paths** like `/home/<user>/...` or `/Users/<user>/...` in any script, shell file, symlink YAML, config, or documentation inside `$DOTFILES_PATH`.
- Always use portable environment variables:
  - `$HOME` (or `~` inside Dotbot `symlinks/*.yaml`)
  - `$DOTFILES_PATH` (`$HOME/.dotfiles`)
  - `$DOTLY_PATH` (`$DOTFILES_PATH/modules/dotly`)
  - `$ZIM_HOME` (`$DOTFILES_PATH/shell/zsh/.zim`)
  - `$XDG_CONFIG_HOME` (`${XDG_CONFIG_HOME:-$HOME/.config}`)
- **Machine-specific values & `.env` files**:
  - If a script, application config, or local setup requires machine-specific paths, secrets, or custom parameters, define them in an untracked `.env` file (e.g. `$DOTFILES_PATH/.env`) and load it from `shell/exports.sh` or inside the specific script (`[ -f "$DOTFILES_PATH/.env" ] && set -a && source "$DOTFILES_PATH/.env" && set +a`).
- **Note on `dot dotfiles create` templating**:
  - Upon installation, dotly's template engine replaces `XXX_DOTFILES_PATH_XXX` in `bin/sdot`, `shell/bash/.bashrc`, and `shell/zsh/.zshenv` with a literal path. Always keep those set to `$HOME/.dotfiles` so the repository stays 100% portable across machines and users.

## 2. Core Environment Variables

- **`$DOTFILES_PATH`**: `$HOME/.dotfiles` (root of user configuration and source of truth).
- **`$DOTLY_PATH`**: `$DOTFILES_PATH/modules/dotly` (Git submodule containing the dotly core framework, Dotbot, `z`, and built-in scripts).
- **`$ZIM_HOME`**: `$DOTFILES_PATH/shell/zsh/.zim` (auto-generated Zimfw installation; ignored by Git via `.gitignore`).

> **Rule of Thumb**: Never edit files inside `modules/dotly/` or `shell/zsh/.zim/` directly. All user customizations belong in the top-level directories of `$DOTFILES_PATH`.

## 3. Directory Map & Integrated Configurations

| Directory | Purpose | Current Tracked Contents |
| :--- | :--- | :--- |
| `.agents/` | Repository-scoped AI skills (only active inside `$DOTFILES_PATH`) | `.agents/skills/dotly-dotfiles/` |
| `ai/` | Global AI agent configs, skills, MCP, rules & hooks (`ai/agents/`) | `ai/agents/` (`skills/niri-dms-system`, `skills/ardia`, `skills/cua-driver`, `skills/hey`, `mcp/mcp_config.json`, `rules/`, `hooks/hey-*`) -> linked to `~/.agents`, `~/.gemini/config/skills`, and `~/.gemini/config/mcp_config.json` |
| `bin/` | Custom standalone executables (`$PATH` priority) | `sdot`, `niri-clipboard`, `niri-touch-gestures` |
| `doc/` | Personal documentation and notes for the dotfiles | System & dotfiles architecture docs |
| `editors/` | Editor & TUI Git configs (`nvim/`, `micro/`, `lazygit/`, `code/`, `vim/`, `sublime/`) | `editors/nvim/` -> `~/.config/nvim`, `editors/micro/` -> `~/.config/micro`, `editors/lazygit/config.yml` -> `~/.config/lazygit/config.yml` |
| `git/` | Git & GitHub CLI configuration files (`.gitconfig`, `gh/config.yml`) | `git/.gitconfig` -> `~/.gitconfig`, `git/gh/config.yml` -> `~/.config/gh/config.yml` |
| `langs/` | Language/SDK configs & package lists (`rust/`, `js/`, `python/`, `java/`, `php/`) | `langs/rust/cargo-packages.txt` (`docpars`), plus `dot package` dumps |
| `modules/dotly/` | Dotly framework submodule (includes `dotbot` & `z`) | Invoked via `dot` / `sdot` / `dotly` and sourced by shell rc files |
| `os/linux/` | Linux desktop, branding, apps & system configs | `branding/` (`logo.svg`, `about.txt`, `screensaver.txt`, `logo-kinder-dots.txt`, `logo-kinder-vim.lua`), `fastfetch/config.jsonc`, `niri/`, `dms/`, `ghostty/`, `alacritty/`, `gtk-3.0/`, `gtk-4.0/`, `herdr/config.toml`, `shelly/config.json`, `cachyos/cachyos-hello.json`, `xdg/` (`mimeapps.list`, `user-dirs.dirs`, `user-dirs.locale`), `environment.d/`, `xdg-terminals.list`, `greetd/config.toml`, `udev/rules.d/70-raydium-touchscreen.rules`, `systemd/user/`, `pacman/` (`packages.txt`, `aur-packages.txt`), `firefoxpwa/` (`config.json`, `apps.txt`, `applications/FFPWA-*.desktop`, `icons/hicolor/`, `user.js`, `chrome/userChrome.css`), `webapps/` (`applications/google-maps.desktop`, `icons/hicolor/`) |
| `restoration_scripts/` | Bootstrap `.sh` scripts executed on `dot self install` | `01-niri-system-bootstrap.sh` (TTY/headless-safe installer: installs Pacman/AUR/Cargo packages including `obsidian` & `xwayland-satellite`, bootstraps `paru-bin`/`rustup` if missing, installs Ardia Browser + CLI, Herdr TUI only, HEY CLI/TUI, FirefoxPWA web apps WhatsApp & HEY without standalone `firefox`, udev rules, user groups, Niri + DMS + Ghostty + Alacritty + GTK 3/4 + Neovim + greetd/tuigreet) |
| `scripts/` | Custom CLI commands extending `dot <context> <script>` | `scripts/system/bootstrap` (`dot system bootstrap`), `scripts/package/arch_dump` (`dot package arch_dump`), `scripts/surprise/hello` |
| `shell/` | Shared (`aliases.sh`, `exports.sh`, `functions.sh`, `init.sh`, `.inputrc`) and shell-specific (`zsh/`, `bash/`, `fish/`) config | Linked to `$HOME` and `~/.config/fish/` via `symlinks/conf.yaml` (includes `_hey` and `hey.fish` completions) |
| `symlinks/` | Dotbot YAML definitions (`conf.yaml`, `conf.linux.yaml`, `conf.macos.yaml`, `conf.macos-intel.yaml`) | Applied by running `dot symlinks apply` |
