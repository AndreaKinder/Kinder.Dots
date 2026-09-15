#!/bin/sh

# @raycast.schemaVersion 1
# @raycast.title Exportar eventos de hoy
# @raycast.mode compact
# @raycast.packageName Calendario
# @raycast.description Exporta los eventos de hoy de los metadatos de la nota diaria a Calendario

. "$HOME/.dotfiles/scripts/raycast/exportar-eventos-calendario.inc"

TODAY=$(date +%Y-%m-%d)
calendar_export_date "$TODAY"
