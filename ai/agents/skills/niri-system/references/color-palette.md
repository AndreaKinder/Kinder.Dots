# Paleta TUI Monocromática (`tuigreet`) e Identidad `<K>`

El entorno mantiene una estética TUI minimalista inspirada en `tuigreet`: fondo negro puro/semitransparente, texto gris claro/blanco, esquinas rectas (`0px`) y foco blanco de 1px.

## Tokens base

| Rol | Hex | Uso principal |
| :--- | :--- | :--- |
| Fondo OLED / base | `#000000` | `foot` (`alpha=0.85`), `waybar`, `rofi`, `mako`, wallpaper `06-kinder-midnight-oled` |
| Texto principal | `#e6e6e6` / `#ffffff` | `foot` foreground, foco activo en Niri (`active-color "#ffffff"`), selección |
| Texto secundario / borde inactivo | `#888888` / `#505050` | `inactive-color` en Niri, etiquetas secundarias en Waybar |
| Selección invertida | `#e6e6e6` sobre `#000000` | Cursor y selección en `foot`, ítem activo en `rofi`/`fuzzel` |

## Acentos ANSI (`foot.ini` `[colors-dark]`)

| Color | Regular | Bright |
| :--- | :--- | :--- |
| Negro | `#000000` | `#555555` |
| Rojo | `#e06c75` | `#ff7a85` |
| Verde | `#98c379` | `#b5e890` |
| Amarillo | `#e5c07b` | `#f5d08a` |
| Acento marca | `#d946ef` | `#f0abfc` |
| Magenta | `#c678dd` | `#dda0f0` |
| Cian | `#56b6c2` | `#76d6e2` |
| Blanco | `#d0d0d0` | `#ffffff` |

## Reglas de diseño

- Sin esquinas redondeadas por defecto (`rounded_corners = False` en `btop`, `border-radius: 0` en Waybar/Rofi/Mako).
- Sin decoraciones de cliente (`prefer-no-csd` en Niri, `[csd] preferred=none` en `foot`).
- Identidad corporativa: silueta de huevo con `<K>` geométrico centrado.
