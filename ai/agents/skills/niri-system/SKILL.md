---
name: niri-system
description: |
  Gestiona el entorno de escritorio Linux en CachyOS: Niri Wayland, Waybar, Rofi/Fuzzel, Mako, Swaybg/Swaylock, Foot, Fish, GTK 3/4, FirefoxPWA y dotfiles con chezmoi (KinderDots).
  Archivos: config.kdl, config.d/*.kdl, waybar/config.jsonc, foot.ini, rofi/tuigreet.rasi, branding/about.txt, ~/.local/bin/*.
  No usar para: otros compositores/DEs, cambiar greetd/tuigreet, editar KinderNvim desde este repo o versionar secretos.
version: 2.0.0
---

# Niri System Desktop Skill (KinderDots)

Índice y reglas de seguridad para gestionar el entorno de escritorio **Niri + Waybar + Foot + Fish + Rofi/Fuzzel + Mako** en CachyOS, con estética TUI monocromática (`tuigreet`) e identidad corporativa `<K>`, gestionado mediante **chezmoi** (`~/.local/share/chezmoi`).

**Carga solo el archivo de `./references/` necesario para tu tarea** en lugar de leer todo de golpe.

## Reglas estrictas

1. **Fuente de verdad en `chezmoi` (`~/.local/share/chezmoi`)**:
   - Edita los archivos live en `~/` y sincroniza con `chezmoi add <archivo>`.
   - **NUNCA hardcodees rutas absolutas de usuario** (`/home/<usuario>/...`). Usa `$HOME`, `~`, `$PATH` o `{{ .chezmoi.homeDir }}` en plantillas `.tmpl`.
   - **NUNCA versiones secretos** ni perfiles locales (`.env`, credenciales, `hey-cli/`, `fish_variables`, perfiles de navegador, `.sync_*.db`).
   - **No hacer `git push` sin permiso explícito del usuario.**
2. **NUNCA reemplazar `greetd` + `tuigreet`**:
   - `/etc/greetd/config.toml` ejecuta `tuigreet --time --remember --cmd niri-session`. No cambiar el greeter.
3. **Preservar reglas de hardware y atajos de Niri** (`~/.config/niri/config.d/`):
   - Mantener `keymap.xkb` (`Super+C/V` → `XF86Copy/Paste`), TrackPoint (`trackpoint-nav.py`), salidas en `outputs.kdl`, `focus-ring` blanco `#ffffff`, `draw-border-with-background false` para `foot`/`btop`/`calcurse`, y reglas sin bordes para `^FFPWA-`.
4. **Identidad visual `<K>` y portabilidad**:
   - El logo corporativo es el huevo con `<K>` (`~/.config/branding/about.txt` para `fastfetch` y `~/Imágenes/Wallpapers/01..06-kinder-*.png` para `swaybg`).
   - Los IDs de FirefoxPWA cambian por máquina; documentar y adaptar en `binds.kdl` y `~/.local/bin/heymail-waybar`.

## Enrutamiento de referencias

| Área / Tarea | Archivo de referencia |
| :----------- | :-------------------- |
| Waybar, Rofi, Fuzzel, Mako, Swaybg/Swaylock, branding `<K>` y scripts `~/.local/bin/` | [waybar-ui-branding.md](./references/waybar-ui-branding.md) |
| Paleta TUI monocromática (`tuigreet`), acentos y tokens de color | [color-palette.md](./references/color-palette.md) |
| Compositor Niri (`config.d/*.kdl`), monitores, reglas, atajos, portapapeles `cliphist` | [niri-compositor.md](./references/niri-compositor.md) |
| Foot, Fish, Fastfetch, GTK 3/4, btop, micro, KinderNvim, Voxtype | [terminals-gtk-apps.md](./references/terminals-gtk-apps.md) |
| Instalación, theming y gestión de FirefoxPWA (WhatsApp, HEY Mail) | [firefoxpwa.md](./references/firefoxpwa.md) |
| Stack de CachyOS, `greetd`/`tuigreet`, servicios de usuario, `chezmoi` y `bootstrap.sh` | [system-packages-login.md](./references/system-packages-login.md) |
| Validar esta skill | [scripts/lint_skill.py](scripts/lint_skill.py) |

## Checklist de verificación

Tras aplicar cambios en el entorno:

```bash
niri validate
foot --check-config
chezmoi status
```

> **Nota de sandbox**: Las herramientas de archivo pueden editar `~/.config` y `~/.local/bin` directamente, mientras que `niri validate`, `niri msg outputs`, `chezmoi add`, `pkill`/`swaybg`, `hey` CLI y operaciones de red requieren ejecutarse fuera del sandbox (`BypassSandbox: true`).
