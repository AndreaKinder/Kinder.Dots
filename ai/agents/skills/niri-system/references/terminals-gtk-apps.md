# Terminal, Shell, GTK y Aplicaciones

## Foot (`~/.config/foot/foot.ini`)

- Fuente: `MesloLGL Nerd Font Mono:size=10`, `dpi-aware=no`, `pad=8x8`, `shell=/usr/bin/fish`.
- Sin CSD (`preferred=none`, `size=0`, `border-width=0`) y fondo negro con `alpha=0.85`.
- Keybindings:
  ```ini
  [key-bindings]
  primary-paste=none
  clipboard-copy=Control+Shift+c Super+c Super+x
  clipboard-paste=Control+Shift+v Super+v Shift+Insert
  ```
  (`primary-paste=none` es obligatorio para evitar el conflicto con `Shift+Insert`).
- Validar cambios con `foot --check-config`.

## Fish y Fastfetch

- **`~/.config/fish/config.fish`**: carga `/usr/share/cachyos-fish-config/cachyos-config.fish`, ejecuta `fastfetch` en `fish_greeting` y añade `"$HOME/.local/bin"` con `fish_add_path -p`.
- **`~/.config/fastfetch/config.jsonc`**: usa `~/.config/branding/about.txt` (`file-raw`) y módulos compactos (`os`, `kernel`, `wm`, `terminal`, `shell`, `cpu`, `gpu`, `memory`).
- **Nunca versionar `fish_variables`**.

## Editores y monitorización

- **KinderNvim (`~/.config/nvim`)**: repo externo gestionado automáticamente por `.chezmoiexternal.toml` (`refreshPeriod 168h`). No duplicar archivos en `chezmoi`.
- **Micro (`~/.config/micro/`)**: `settings.json` + `colorschemes/` monocromáticos.
- **btop (`~/.config/btop/btop.conf`)**: usa `color_theme = "tuigreet-mono"` (resuelve automáticamente `~/.config/btop/themes/tuigreet-mono.theme`), `vim_keys = True`, `rounded_corners = False`.

## GTK 3/4, Navegador y Dictado

- **GTK 3/4**: `~/.config/gtk-3.0/gtk.css`, `~/.config/gtk-4.0/gtk.css` y `settings.ini` con tema monocromático.
- **Navegador**: `ardia` (`Mod+B` en Niri) y `mimeapps.list` para asociaciones por defecto.
- **Gestor de archivos**: `nautilus` (`Mod+E`).
- **Voxtype (`~/.config/voxtype/config.toml`)**: dictado por voz con Whisper `small` (CPU), activado con `Alt+Space` y mostrado en Waybar (`custom/voxtype`).
- **Variables de entorno (`~/.config/environment.d/10-kinder.conf.tmpl`)**: usa `{{ .chezmoi.homeDir }}` para `TERMINAL`, `BROWSER`, `EDITOR`, `NOTAS_VAULT` y rutas de Obsidian.
