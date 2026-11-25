# Sistema, Login (`greetd`), Dotfiles (`chezmoi`) y Bootstrap

## Stack base

- **Distro**: CachyOS (Arch Linux).
- **Display Manager**: `greetd` + `tuigreet` (`/etc/greetd/config.toml` con `tuigreet --time --remember --cmd niri-session`). **Nunca reemplazar `tuigreet`.**
- **Sesión**: `niri-session` (Wayland).

## Gestión de Dotfiles (`chezmoi`)

- **Repositorio fuente**: `~/.local/share/chezmoi` (KinderDots).
- **Flujo diario**:
  1. Editar el archivo live en `~/...`.
  2. Probar/validar en vivo (`niri validate`, `foot --check-config`, etc.).
  3. Sincronizar al source state: `chezmoi add <archivo>`.
  4. Revisar con `chezmoi status` y `chezmoi diff`.
  5. Hacer commit local si procede; **nunca hacer `git push` sin confirmación explícita**.
- **Bootstrap completo**: `~/.local/share/chezmoi/bootstrap.sh` (excluido de `$HOME` vía `.chezmoiignore`).

## Higiene y seguridad

- **Cero rutas absolutas de usuario**: prohibido `/home/<usuario>/...` en configuraciones o scripts. Usar `$HOME`, `~` o `{{ .chezmoi.homeDir }}`.
- **Exclusiones obligatorias**: `.env`, credenciales, `hey-cli/`, `fish_variables`, `zen/`, `mozilla/`, `Nextcloud/`, `antigravity/`, `.sync_*.db`, perfiles PWA.
