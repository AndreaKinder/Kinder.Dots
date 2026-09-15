#!/bin/sh

# @raycast.schemaVersion 1
# @raycast.title Exportar notas a Apple Notes
# @raycast.mode compact
# @raycast.packageName Notas
# @raycast.description Exporta una nota, una carpeta o todas las notas Markdown no diarias
# @raycast.argument1 {"type":"text", "placeholder":"all | carpeta | ruta/nota.md", "optional":true}
# @raycast.argument2 {"type":"text", "placeholder":"Carpeta destino Apple Notes", "optional":true}

. "$HOME/.dotfiles/scripts/raycast/exportar-notas-apple-notes.inc"

SOURCE="${1:-all}"
DESTINATION="${2:-Obsidian Importadas}"
notes_export_source "$SOURCE" "$DESTINATION"
