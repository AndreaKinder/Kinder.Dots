# Load private/sensitive environment variables if present (ignored in git)
if [ -f "$DOTFILES_PATH/.env" ]; then
  set -a
  . "$DOTFILES_PATH/.env"
  set +a
fi

if [ -f "$DOTFILES_PATH/.env.local" ]; then
  set -a
  . "$DOTFILES_PATH/.env.local"
  set +a
fi

source "$DOTFILES_PATH/shell/aliases.sh"
source "$DOTFILES_PATH/shell/exports.sh"
source "$DOTFILES_PATH/shell/functions.sh"
