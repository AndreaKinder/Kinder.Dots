# Waybar, Rofi, Fuzzel, Mako, Branding `<K>` y Scripts

## Waybar (`~/.config/waybar/`)

- **`config.jsonc`**: barra superior (`height: 22`, `layer: top`).
  - Izquierda: `niri/workspaces`, `niri/window` (`separate-outputs: true`).
  - Centro: `clock` (formato `tuigreet`, `on-click`: `$HOME/.local/bin/calendar-menu`).
  - Derecha: `tray`, `custom/heymail`, `custom/voxtype`, `backlight` (`intel_backlight`), `wireplumber`, `cpu` (`foot -T btop -a btop btop`), `battery`, `custom/sysmenu`.
- **`style.css`**: estilo TUI monocromático sin bordes redondeados.
- **`power_menu.xml`**: menú XML de energía.
- Todos los comandos en `config.jsonc` usan `$HOME/.local/bin/...` (sin rutas absolutas de usuario).

## Scripts propios (`~/.local/bin/`)

| Script | Función |
| :--- | :--- |
| `heymail-waybar` | Módulo de Waybar para HEY Mail (`status`, `--menu`, `--pwa`). Usa `hey box view <box> --json`: asunto en `.name`, remitente en `.creator.name` / `.alternative_sender_name`, lectura en `.observed_at != null`. |
| `osd` | OSD de volumen, micrófono y brillo (`vol-up`, `vol-down`, `vol-mute`, `mic-mute`, `brightness-up`, `brightness-down`). |
| `sysmenu` | Menú de sistema (`Mod+S`): Wi-Fi, Bluetooth, salida/entrada de audio, etc. Invoca `"$HOME/.local/bin/osd"`. |
| `calendar-menu` | Selector mes → día en `fuzzel`/`rofi` que abre o crea la nota diaria en `$HOME/Notas/journal/AAAA-MM-DD.md` con Neovim. |

## Lanzadores y notificaciones

- **Rofi** (`~/.config/rofi/`): `config.rasi`, `tuigreet.rasi`, `calendar.rasi`. Lanzador principal (`Mod+Space`: `rofi -show drun`), historial `cliphist` (`Mod+Alt+V`) y menús de `heymail-waybar`.
- **Fuzzel** (`~/.config/fuzzel/fuzzel.ini`): usado por menús rápidos de scripts (`sysmenu`, `calendar-menu`).
- **Mako** (`~/.config/mako/config`): daemon de notificaciones monocromáticas.

## Wallpaper, bloqueo y branding `<K>`

- **Wallpaper activo**: lanzado en `~/.config/niri/config.d/startup.kdl` con:
  `spawn-sh-at-startup "swaybg -m fill -i \"$HOME/Imágenes/Wallpapers/06-kinder-midnight-oled.png\""`
- **Colección corporativa `<K>`** (`~/Imágenes/Wallpapers/`):
  1. `01-kinder-pastel-original.png`
  2. `02-kinder-bubblegum-y2k.png`
  3. `03-kinder-lavender-dusk.png`
  4. `04-kinder-tokyo-night.png`
  5. `05-kinder-neon-synthwave.png`
  6. `06-kinder-midnight-oled.png` (predeterminado, OLED negro + logo `<K>`)
- **Logo terminal (`fastfetch`)**: `~/.config/branding/about.txt` (huevo monocromo en bloques Unicode con `<K>`).
- **Inactividad y bloqueo**: `swayidle` + `swaylock` configurados en `startup.kdl` (5 min bloqueo, 10 min apagar monitores, bloqueo antes de suspender).
