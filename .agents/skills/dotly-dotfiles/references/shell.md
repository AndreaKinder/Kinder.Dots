# Configuring the Shell (`shell/`)

## 1. Startup & Loading Order

### Zsh (`shell/zsh/`)
1. `~/.zshenv` -> `shell/zsh/.zshenv`:
   - Exports `DOTFILES_PATH="$HOME/.dotfiles"`, `DOTLY_PATH="$DOTFILES_PATH/modules/dotly"`, `DOTLY_THEME="codely"`, and `ZIM_HOME="$DOTFILES_PATH/shell/zsh/.zim"`.
2. `~/.zshrc` -> `shell/zsh/.zshrc`:
   - Sets Zsh options (`HIST_IGNORE_ALL_DUPS`, `HIST_FCNTL_LOCK`, `setopt +o nomatch`, optional `autopushd`).
   - Starts Zimfw (`source "$ZIM_HOME/init.zsh"`).
   - Sources `$DOTFILES_PATH/shell/init.sh` (which sources `aliases.sh`, `exports.sh`, and `functions.sh`).
   - Prepends `$DOTFILES_PATH/shell/zsh/themes`, `$DOTFILES_PATH/shell/zsh/completions`, `$DOTLY_PATH/shell/zsh/themes`, and `$DOTLY_PATH/shell/zsh/completions` to `fpath`.
   - Initializes prompt: `autoload -Uz promptinit && promptinit && prompt ${DOTLY_THEME:-codely}`.
   - Loads Zsh keybindings:
     - `$DOTLY_PATH/shell/zsh/bindings/dot.zsh` (`Ctrl+F` interactive `dot` widget)
     - `$DOTLY_PATH/shell/zsh/bindings/reverse_search.zsh` (`Ctrl+R` fzf history widget)
     - `$DOTFILES_PATH/shell/zsh/key-bindings.zsh` (user custom bindings)
3. `~/.zlogin` -> `shell/zsh/.zlogin`:
   - Runs Zim's `login_init.zsh -q &!` in the background.

### Bash (`shell/bash/`)
1. `~/.bash_profile` -> `shell/bash/.bash_profile`: Sources `~/.bashrc`.
2. `~/.bashrc` -> `shell/bash/.bashrc`:
   - Exports `DOTFILES_PATH="$HOME/.dotfiles"`, `DOTLY_PATH`, `DOTLY_THEME`.
   - Sources `$DOTFILES_PATH/shell/init.sh`.
   - Converts the `path=(...)` array from `shell/exports.sh` into a colon-separated `$PATH`.
   - Loads the Bash theme `<theme>.sh` from `shell/bash/themes/` or `$DOTLY_PATH/shell/bash/themes/`.
   - Sources completion files matching `_*` in `$DOTLY_PATH/shell/bash/completions/` and `$DOTFILES_PATH/shell/bash/completions/`.

### Fish (`shell/fish/`)
- Linked via `symlinks/conf.yaml` into `~/.config/fish/` (`config.fish`, `fish_plugins`, `conf.d/`, `functions/`, `completions/`).
- Exports `TERMINAL="ghostty"`, `BROWSER="ardia"`, `EDITOR="nvim"`, `VISUAL="nvim"`, `OBSIDIAN_VAULT_PATH="$HOME/Notas"`, `$HOME/.local/bin`, and NVM paths using `$HOME`, plus the `neofetch="fastfetch"` alias.

---

## 2. Shared Shell Files (`shell/init.sh`)

`shell/init.sh` is sourced by both Bash and Zsh and loads:

### A. `shell/exports.sh` (Environment Variables, Default Apps, `.env`, Theme & `$PATH`)
- **Default Apps**:
  ```bash
  export TERMINAL="ghostty"
  export BROWSER="ardia"
  export EDITOR="nvim"
  export VISUAL="nvim"
  export OBSIDIAN_VAULT_PATH="$HOME/Notas"
  ```
- **Loading `.env` (if machine-specific variables are needed)**:
  ```bash
  if [ -f "$DOTFILES_PATH/.env" ]; then
    set -a
    source "$DOTFILES_PATH/.env"
    set +a
  fi
  ```
- **Codely Theme Variables**:
  ```bash
  export CODELY_THEME_MINIMAL=false              # true = only status icon & pwd (hides git status)
  export CODELY_THEME_MODE="dark"                # "dark" or "light" (also switches FZF_DEFAULT_OPTS palette)
  export CODELY_THEME_PROMPT_IN_NEW_LINE=false   # true = multiline prompt with ╭ / ╰
  export CODELY_THEME_PWD_MODE="short"           # "short" (/h/a/.dotfiles), "full", or "home_relative"
  export CODELY_THEME_STATUS_ICON_OK="▸"         # Icon when previous command exited 0
  export CODELY_THEME_STATUS_ICON_KO="▪"         # Icon when previous command failed
  ```
- **`$PATH` Management (`path` array)**:
  - Add directories to the `path=( ... )` array in `shell/exports.sh`.
  - **Higher entries have higher priority**. Always use `$HOME`, `$DOTFILES_PATH`, `$DOTLY_PATH`, etc., never hardcoded `/home/<user>` paths.

### B. `shell/aliases.sh` (Shared Aliases)
- Navigation: `..`, `...`, `~`, `dotfiles` (`cd $DOTFILES_PATH`), `ll`, `la`
- Git & dotly shortcuts:
  - `gaa` (`git add -A`)
  - `gc` (`$DOTLY_PATH/bin/dot git commit`)
  - `gca` (`git add --all && git commit --amend --no-edit`)
  - `gco` (`git checkout`)
  - `gd` (`$DOTLY_PATH/bin/dot git pretty-diff`)
  - `gs` (`git status -sb`)
  - `gf` (`git fetch --all -p`)
  - `gps` / `gpsf` / `gpl` / `gb`
  - `gl` (`$DOTLY_PATH/bin/dot git pretty-log`)
- System: `up` (`dot package update_all`), `neofetch` (`fastfetch`), `k` (`kill -9`), `c.` (`code $PWD`), `i.` (`idea $PWD`), `o.` (`open .`)

### C. `shell/functions.sh` (Shared Functions)
- `cdd`: Interactive `cd` into child directories using `fzf`.
- `j <query>`: Jump to frecent directories (lazy-loads `$DOTLY_PATH/modules/z/z.sh`).
- `recent_dirs`: Browse directory stack (`dirs -p`) with `fzf` (works best when `setopt autopushd` is uncommented in `shell/zsh/.zshrc`).

---

## 3. Zsh Plugins / Zim Modules (`shell/zsh/.zimrc`)

- Add or remove Zsh plugins in `shell/zsh/.zimrc` using `zmodule <user/repo>`.
- Default modules: `zimfw/environment`, `zimfw/git-info`, `zimfw/input`, `zimfw/completion`, `zsh-users/zsh-syntax-highlighting`, `zsh-users/zsh-autosuggestions`.
- **Apply changes** after editing `shell/zsh/.zimrc`:
  ```bash
  zsh "$ZIM_HOME/zimfw.zsh" uninstall && zsh "$ZIM_HOME/zimfw.zsh" install
  ```
- **Maintenance commands** via `dot`:
  - `dot shell zsh reload_completions`: Runs `compaudit` and `compinit`.
  - `dot shell zsh clean_cache`: Deletes compiled `*.zwc` files under `$HOME`.
  - `dot shell zsh optimize`: Cleans and recompiles Zim scripts and reloads completions.

---

## 4. Custom Keybindings, Completions & Themes

- **Zsh Keybindings**: Edit `shell/zsh/key-bindings.zsh` using `bindkey`.
- **Readline (Bash/CLI inputs)**: Edit `shell/.inputrc` (linked to `~/.inputrc`).
- **Custom Completions**:
  - Zsh: Place `_<command>` file in `shell/zsh/completions/` and run `dot shell zsh reload_completions`.
  - Bash: Place `_<command>` file in `shell/bash/completions/`.
- **Custom Prompt Themes**:
  - Zsh: Create `shell/zsh/themes/prompt_<name>_setup` and set `export DOTLY_THEME="<name>"` in `shell/zsh/.zshenv`.
  - Bash: Create `shell/bash/themes/<name>.sh` and set `export DOTLY_THEME="<name>"` in `shell/bash/.bashrc`.
