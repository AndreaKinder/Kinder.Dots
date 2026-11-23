if test -f /usr/share/cachyos-fish-config/cachyos-config.fish
    source /usr/share/cachyos-fish-config/cachyos-config.fish
end

# overwrite greeting to disable fastfetch
function fish_greeting
end

# Default Apps
set -gx TERMINAL "ghostty"
set -gx BROWSER "ardia"
set -gx EDITOR "nvim"
set -gx VISUAL "nvim"
set -gx OBSIDIAN_VAULT_PATH "$HOME/Notas"
alias neofetch="fastfetch"

# Local binaries
set -gx PATH "$HOME/.local/bin" $PATH

# Node.js / NVM configuration
set -gx nvm_data "$HOME/.nvm"
