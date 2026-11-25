# FirefoxPWA (WhatsApp y HEY Mail)

## Principios clave

- Los **IDs ULID** de `firefoxpwa` son específicos de cada instalación y **no son reproducibles** entre máquinas.
- **Nunca versionar** los perfiles ni `.desktop`/iconos locales de `firefoxpwa` en `chezmoi`.

## Dónde se configuran los IDs

1. **WhatsApp**:
   - Atajo `Mod+W` en `~/.config/niri/config.d/binds.kdl`:
     `spawn "firefoxpwa" "site" "launch" "<PWA_ID>"`
2. **HEY Mail**:
   - Variable `PWA_ID` en `~/.local/bin/heymail-waybar` (lanzado con clic derecho en el módulo de Waybar o desde el menú de `rofi`).

## Reglas de ventana en Niri (`rules.kdl`)

Todas las PWAs (`app-id=r#"^FFPWA-"#`) se abren maximizadas a bordes (`open-maximized-to-edges true`), sin `focus-ring`, sin `border` y con `draw-border-with-background false`.

## Comandos útiles

```bash
firefoxpwa site list
firefoxpwa site launch <PWA_ID>
```
