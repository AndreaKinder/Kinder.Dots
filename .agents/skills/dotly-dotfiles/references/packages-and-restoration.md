# Package Management (`dot package`) & Restoration Scripts (`restoration_scripts/`)

## 1. Unified Package Commands (`dot package`)

- **`dot package add <package_name> [--skip-recipe]`**:
  - Checks if `<package_name>` is already installed.
  - Checks if a custom recipe exists in `$DOTLY_PATH/scripts/package/recipes/` (e.g., `docpars`, `cargo`, etc.).
  - Otherwise iterates over available system package managers on Linux (`apt`, `dnf`, `yum`, `brew`, `pacman`, `cargo`) or macOS (`brew`, `mas`, `ports`, `cargo`).
- **`dot package update_all` (aliased to `up`)**:
  - Updates installed packages across `mas`, `brew`, `pip3`, `composer`, `gem`, `npm`, `cargo`, `tldr`, upgrades Zimfw (`zimfw upgrade && zimfw update`), and runs `dot self update`.
- **`dot package dump`**:
  - Exports lists of currently installed packages/extensions into versioned files inside `$DOTFILES_PATH`.
- **`dot package import`**:
  - Reinstalls all packages from the dumped files inside `$DOTFILES_PATH`.

## 2. Package Dump Locations in `$DOTFILES_PATH`

Defined in `$DOTLY_PATH/scripts/package/src/dump.sh`:

| Package Manager | Path inside `$DOTFILES_PATH` | Dump / Import Behavior |
| :--- | :--- | :--- |
| **APT** | `os/linux/apt/packages.txt` | `apt-mark showmanual` / `xargs sudo apt-get install -y` |
| **Homebrew (Linux)** | `os/linux/brew/Brewfile` | `brew bundle dump` / `brew bundle install` |
| **Homebrew (macOS)** | `os/mac/brew/Brewfile` | `brew bundle dump` / `brew bundle install` |
| **Pacman (Native)** | `os/linux/pacman/packages.txt` | All explicitly installed native Arch/CachyOS packages (`pacman -Qqen`, including `obsidian`, `niri`, `ghostty`, `neovim`, `firefoxpwa`, `gnome-disk-utility`, `rpi-imager`, `wtype`, etc.). Dumped via `dot package arch_dump` and auto-installed by `01-niri-system-bootstrap.sh`. |
| **Pacman (AUR)** | `os/linux/pacman/aur-packages.txt` | Explicitly installed AUR packages (`pacman -Qqem`, including `voxtype-bin`). Dumped via `dot package arch_dump` and auto-installed via `paru`/`yay` in `01-niri-system-bootstrap.sh`. |
| **Rust (Cargo)** | `langs/rust/cargo-packages.txt` | Installed Cargo binaries (`docpars`, etc.). Dumped via `dot package arch_dump` and auto-installed by `01-niri-system-bootstrap.sh`. |
| **FirefoxPWA Web Apps** | `os/linux/firefoxpwa/apps.txt` | Declarative list of PWAs (`Name\|ManifestURL\|Categories\|Keywords`) plus borderless `user.js` and `chrome/userChrome.css`, auto-installed by `01-niri-system-bootstrap.sh`. |
| **Snap** | `os/linux/snap/packages.txt` | `snap list` / `sudo snap install` |
| **VS Code** | `editors/code/extensions.txt` | `code --list-extensions` / `code --install-extension` |
| **Python (`pip3`)** | `langs/python/requirements.txt` | `pip3 freeze` / `pip3 install -r` |
| **Node (Volta / NPM)** | `langs/js/volta_dependencies.txt` or `langs/js/global_modules.txt` | Uses `volta` if installed, else falls back to global `npm` modules |
| **asdf** | `langs/sdk/asdf.txt` | Dumps & restores all `asdf` plugins and versions |
| **Winget (WSL/Win)** | `os/windows/winget.output` | `winget.exe export` / `winget.exe import` |

## 3. Restoration Scripts (`restoration_scripts/`)

During `dot self install` (or when restoring dotfiles on a new machine), dotly runs every `*.sh` file in `$DOTFILES_PATH/restoration_scripts/` in alphabetical order:

```bash
find "$DOTFILES_PATH/restoration_scripts" -mindepth 1 -maxdepth 1 -type l,f -name '*.sh' | sort
```

### Rules for Creating a Restoration Script:
1. **Naming**: Prefix with a two-digit number to control execution order (e.g., `01-niri-system-bootstrap.sh`, `02-systemd-services.sh`).
2. **Executable Bit**: Must have user execution permission (`chmod u+x "$DOTFILES_PATH/restoration_scripts/01-..."`). If a `.sh` file in `restoration_scripts/` is not executable, `dot self install` logs `Install script error in <file>`.
3. **Sourced Execution**: `dot self install` runs `. "$install_script"` (sources it in a subshell pipeline piped to `log::file`).
   - Do not use hardcoded `/home/<user>` paths; always use `$HOME`, `$DOTFILES_PATH`, and `$DOTLY_PATH`.
   - Avoid calling `exit` at the top level unless you want to abort that restoration script immediately; wrap logic in a function and use `return`.

### Active Restoration Scripts in this Repository:
- **`restoration_scripts/01-niri-system-bootstrap.sh`** (TTY/headless-safe; also callable on demand via `dot system bootstrap [--apply-symlinks]`):
  - Installs core Wayland/Niri/CLI dependencies (`niri`, `xwayland-satellite`, `xdg-desktop-portal*`, `xdg-utils`, `xdg-user-dirs`, `desktop-file-utils`, `seatd`, `gnome-keyring`, `libsecret`, `pkgconf`, `wayland-protocols`, `rustup`, `jq`, `ripgrep`, `fd`, `unzip`, `xz`, etc.) and filters `os/linux/pacman/packages.txt` against `pacman -Slq` (so it works on both vanilla Arch and CachyOS without aborting on missing repo packages, and explicitly excludes standalone `firefox`).
  - Auto-bootstraps `paru-bin` from AUR if neither `paru` nor `yay` is installed, then installs `dux-shell` / `dux-shell-bin`, `rot8`, and all AUR packages in `os/linux/pacman/aur-packages.txt`.
  - Initializes `rustup default stable` if no Rust toolchain is active, then installs Cargo binaries from `langs/rust/cargo-packages.txt`.
  - Downloads and installs **Ardia Browser** (`/usr/bin/ardia`) and **Ardia CLI** (`~/.local/bin/ardia`) from `ardia-browser/ardia` GitHub releases if not installed.
  - Installs **Herdr TUI** (`~/.local/bin/herdr` from `https://herdr.dev/latest.json`) and removes any `herdr-app` GUI binary/config (`herdr-app` must NOT be installed).
  - Installs **HEY CLI & TUI** (`basecamp/hey-cli` -> `~/.local/bin/hey`) and connects coding agents (`hey setup agents`).
  - Recompiles `bin/niri-clipboard` from `os/linux/niri/src/niri-clipboard/niri-clipboard.c`.
  - Installs the FirefoxPWA runtime, installs all web apps listed in `os/linux/firefoxpwa/apps.txt` (**WhatsApp** and **HEY** `https://app.hey.com/manifest.json`), and applies `os/linux/firefoxpwa/user.js` + `chrome/userChrome.css` to hide the top titlebar.
  - Installs `/etc/udev/rules.d/70-raydium-touchscreen.rules` from `os/linux/udev/rules.d/` (giving `uaccess` permission to the touchscreen for `niri-touch-gestures`), adds `$USER` to `input`, `video`, `audio`, `seat`, `wheel`, `network` groups, disables conflicting display managers (`ly@tty2`, `gdm`, `sddm`, `lightdm`), sets `graphical.target` as default, and enables `NetworkManager`, `bluetooth`, `iio-sensor-proxy`, `seatd`, and `greetd.service` (`--force`).
  - Binds `dms.service` to `niri.service` and `graphical-session.target` (via `dms systemd enable --compositor niri` and direct symlinks in `~/.config/systemd/user/{niri.service.wants,graphical-session.target.wants}/`), generates the unprivileged lockscreen PAM stack (`dms auth resolve-lock --quiet` -> `~/.local/state/dms/pam/dankshell`), restores DMS plugins (`dms plugins restore` from `plugins.lock.json`), sets `zsh` as the user's login shell, marks `~/.config/dms/.firstlaunch` so DMS starts directly with the TUI theme without first-run wizards, and configures **Voxtype** (`sudo voxtype setup gpu --enable`, `voxtype setup --download --no-post-install`, and `voxtype.service` under `graphical-session.target.wants`).
  - Copies `os/linux/greetd/config.toml` to `/etc/greetd/config.toml` (`tuigreet --time --remember --cmd niri-session`).
  - Configures `gsettings` (using `dbus-run-session` fallback when running headless/in TTY without `$DBUS_SESSION_BUS_ADDRESS`), creates `$HOME/Work`, `$HOME/Proyectos`, `$HOME/Notas/{inbox,journal,projects,templates,zettelkasten}` (Obsidian vault), and `$HOME/Imágenes/{Wallpapers,Profiles,Capturas}`, sets **Ardia** (`ardia.desktop`) as the default system web browser, and ensures `"wallpaperPath": "#000000"` in `~/.local/state/dms/session.json`.
