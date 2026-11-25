# Compositor Niri (`~/.config/niri/`)

## Estructura modular (`config.kdl`)

`config.kdl` incluye 7 archivos en `~/.config/niri/config.d/`:

| Archivo | Contenido |
| :--- | :--- |
| `input.kdl` | Keymap XKB (`~/.config/niri/input/keymap.xkb`, `Super+C/V` → `XF86Copy/Paste`), `numlock`, touchpad (`tap`, `natural-scroll`), TrackPoint (`scroll-button 274`). |
| `outputs.kdl` | Posición y escala de monitores (`niri msg outputs`): `eDP-1` (`1920x1080@59.934`, `scale 1.5`, `position x=0 y=0`) a la izquierda de `HDMI-A-1` (`2560x1080@59.978`, `scale 1`, `position x=1280 y=0`, `focus-at-startup`), alineados por el borde superior. |
| `layout.kdl` | `gaps 8`, `preset-column-widths` (`1/3`, `1/2`, `2/3`), `focus-ring` 1px (`#ffffff` activo / `#505050` inactivo), `border off`. |
| `startup.kdl` | `waybar`, `mako`, `polkit-mate-authentication-agent-1`, `swaybg` (`$HOME/Imágenes/Wallpapers/06-kinder-midnight-oled.png`), `wl-clip-persist`, `cliphist` watch, `swayidle` + `swaylock`. |
| `general.kdl` | `prefer-no-csd`, `screenshot-path` en `~/Pictures/Screenshots/`. |
| `rules.kdl` | Flotantes: Firefox PiP, `^btop$`, `^calcurse$`. Sin fondo de foco: `^foot$`, `^footclient$`. Sin bordes y maximizadas: `^FFPWA-`. |
| `binds.kdl` | `Mod+Return` (`foot`), `Mod+Space` (`rofi -show drun`), `Mod+B` (`/usr/bin/ardia`), `Mod+E` (`nautilus`), `Mod+W` (WhatsApp PWA), `Mod+S` (`~/.local/bin/sysmenu`), `Mod+Alt+V` (`cliphist` + `rofi`), `Mod+Alt+K` (`wvkbd-mobintl`), `Alt+Space` (`voxtype`), `Super+Alt+L` (`swaylock`), teclas `XF86Audio*`/`XF86MonBrightness*` (`~/.local/bin/osd`). |

## Portapapeles y scripts

- **Portapapeles**: `wl-clip-persist` + `cliphist` (sustituye al antiguo `niri-clipboard.c`). Historial con `Mod+Alt+V`.
- **Scripts en `~/.config/niri/scripts/`**: `copy-paste.sh` y `trackpoint-nav.py`.

## Validación

```bash
niri validate
niri msg outputs
```
