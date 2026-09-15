# Antigravity IDE (Google AGY Editor)

Configuración del editor **Antigravity IDE** (basado en VS Code) y sus herramientas asociadas.

---

## Estructura

- `settings.json`: Preferencias de usuario del editor.
- `extensions.txt`: Lista de extensiones instaladas en Antigravity IDE.
- `argv.json`: Argumentos de inicio del motor VS Code.
- `mcp_config.json`: Servidores MCP (Model Context Protocol).

---

## Ubicaciones por Sistema Operativo

### macOS
- Configuración de usuario: `~/Library/Application Support/Antigravity IDE/User/settings.json`
- Argumentos de inicio: `~/.antigravity-ide/argv.json`
- Extensiones instaladas: `~/.antigravity-ide/extensions/`
- Binario CLI: `/Applications/Dev/Antigravity IDE.app/Contents/Resources/app/bin/antigravity-ide`

### Linux
- Configuración de usuario: `~/.config/Antigravity IDE/User/settings.json`
- Argumentos de inicio: `~/.antigravity-ide/argv.json`
- Extensiones instaladas: `~/.antigravity-ide/extensions/`

---

## Restauración de Extensiones

Para instalar todas las extensiones en un equipo nuevo:

```bash
while IFS= read -r ext; do
  [ -n "$ext" ] && antigravity-ide --install-extension "$ext"
done < extensions.txt
```
