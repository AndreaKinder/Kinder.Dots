# Custom `dot` Scripts (`scripts/`) & Standalone Binaries (`bin/`)

## 1. How `dot` Discovers and Executes Scripts

- `dot` (`$DOTLY_PATH/bin/dot`) looks for scripts organized as `scripts/<context>/<script>` in two locations:
  1. `$DOTFILES_PATH/scripts/<context>/<script>` (your custom scripts)
  2. `$DOTLY_PATH/scripts/<context>/<script>` (built-in dotly scripts)
- **Important Precedence Note**: In `$DOTLY_PATH/bin/dot`, if both `$DOTFILES_PATH` and `$DOTLY_PATH` have an executable script at the exact same `<context>/<script>`, `$DOTLY_PATH` overwrites `script_path` right after `$DOTFILES_PATH`. Therefore, always give custom scripts a unique `<script>` name (or a custom `<context>`) that does not collide with built-in scripts.
- **Executable Permission is Mandatory**: `dot::list_scripts_path` uses `find ... -perm /+111 -type f`. If a script does not have `chmod +x`, `dot` will ignore it completely.

## 2. Template for a Custom `dot` Script

Create `$DOTFILES_PATH/scripts/<context>/<script_name>` and run `chmod +x` on it:

```bash
#!/usr/bin/env bash

set -euo pipefail

source "$DOTLY_PATH/scripts/core/_main.sh"

##? One-line description of what this command does
##?
##? Usage:
##?    <script_name> <required_arg> [<optional_arg>] [--flag] [--option=<val>]
docs::parse "$@"

# Optional: Check and prompt to install missing CLI dependencies
# script::depends_on jq curl

output::header "Executing <script_name>"
output::answer "Target: \`$required_arg\`"

if [ "${flag:-false}" = "true" ]; then
	log::note "Flag is active (option=${option:-none})"
fi

log::success "Done!"
```

## 3. Argument Parsing with `docs::parse` (`docpars`)

- `docs::parse "$@"` extracts every line starting with `##?` in the current script (`$0`), strips the first 4 characters (`##? `), and passes the Docopts specification to `docpars`.
- `docpars` evaluates shell variable assignments straight into the script's scope:
  - `<required_arg>` -> `$required_arg`
  - `[<optional_arg>]` -> `${optional_arg:-}`
  - `[--flag]` -> `$flag` (`true` or `false`)
  - `[--option=<val>]` -> `$option`
  -Subcommands (e.g., `Usage: myscript start`) -> `$start` (`true` or `false`)
- Passing `-h` or `--help` automatically prints the `##?` usage block (also used as the live preview when browsing `dot` interactively via `fzf` or `Ctrl+F`).

## 4. Built-in Core Helpers (`$DOTLY_PATH/scripts/core/_main.sh`)

Sourcing `_main.sh` loads all core helper modules:

### Output (`output.sh`)
- `output::write "Text with \`highlighted code\`"` (renders backticks in green)
- `output::answer "Indented message"` (` > Indented message`)
- `output::error "Error text in red"`
- `output::solution "Solution text in green"`
- `output::question "Do you want to proceed? [Y/n]"` (returns user input; auto-answers `y` if `DOTLY_ENV=CI` or `DOTLY_INSTALLER=true`)
- `output::answer_is_yes "$answer"` (returns exit code `0` if `$answer` starts with `Y`/`y` or is empty)
- `output::header "Section"` / `output::h1 "H1"` / `output::h2 "H2"` / `output::h3 "H3"` / `output::empty_line`

### Logging (`log.sh`)
- `log::header "Banner"`
- `log::success "Message"` (`✔ Message` in green)
- `log::error "Message"` (`✖ Message` in red)
- `log::warning "Message"` (`➜ Message` in yellow)
- `log::note "Message"` (blue)
- `cmd 2>&1 | log::file "Step description"`: Appends timestamped command output to `${DOTLY_LOG_FILE:-$HOME/dotly.log}` (watch live with `dot self debug`).
- `die "Fatal error"`: Logs error and exits with code `42`.

### Platform & Checks (`platform.sh`, `script.sh`, `args.sh`, `str.sh`)
- `platform::command_exists <binary>`
- `platform::is_linux`, `platform::is_macos`, `platform::is_macos_arm`, `platform::is_wsl`
- `script::depends_on <bin1> <bin2>`: Checks if commands exist; if missing, asks the user and installs via `dot package add`.
- `args::has_no_args "$@"`, `args::total_is <N> "$@"`
- `str::contains <needle> <haystack>`

## 5. Linting & Static Analysis for Custom Scripts

Dotly includes built-in code quality checks for your scripts in `$DOTFILES_PATH`:
- **Format check (`shfmt`)**:
  ```bash
  dot self lint --dotfiles
  dot self lint --fix --dotfiles   # Auto-format with tabs (-i 0 -s -w)
  ```
- **Static analysis (`shellcheck`)**:
  ```bash
  dot self static_analysis --dotfiles
  ```

## 6. Standalone Binaries (`bin/` & Custom `scripts/`)

- Any executable placed in `$DOTFILES_PATH/bin/` is directly available in `$PATH` without typing `dot`:
  - **`bin/sdot`**: Wrapper that sources `$HOME/.dotfiles/shell/bash/.bashrc` before calling `$DOTLY_PATH/bin/dot "$@"`. Use `sdot <context> <script>` whenever invoking dotly scripts from non-interactive environments (e.g., Niri/WM keybinds, systemd user services, cronjobs, or desktop `.desktop` launchers).
  - **`bin/niri-clipboard`**: Compiled Wayland virtual keyboard helper (`os/linux/niri/src/niri-clipboard/niri-clipboard.c`) used by Niri's `Mod+C` / `Mod+X` / `Mod+V` keybinds.
  - **`bin/niri-touch-gestures`**: Python 3/4-finger touchscreen gesture daemon managed by `niri-touch-gestures.service`.
- Custom `dot` scripts in `$DOTFILES_PATH/scripts/`:
  - **`dot system bootstrap [--apply-symlinks]`** (`scripts/system/bootstrap`): Runs `restoration_scripts/01-niri-system-bootstrap.sh` and optionally applies symlinks.
  - **`dot package arch_dump`** (`scripts/package/arch_dump`): Dumps explicitly installed Pacman (`os/linux/pacman/packages.txt`), AUR (`os/linux/pacman/aur-packages.txt`), and Cargo (`langs/rust/cargo-packages.txt`) packages.
