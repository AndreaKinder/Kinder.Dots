#!/bin/sh

# @raycast.schemaVersion 1
# @raycast.title Exportar eventos de una fecha
# @raycast.mode compact
# @raycast.packageName Calendario
# @raycast.description Exporta los eventos de una nota diaria indicando la fecha
# @raycast.argument1 {"type":"text", "placeholder":"YYYY-MM-DD"}

. "$HOME/.dotfiles/scripts/raycast/exportar-eventos-calendario.inc"

DATE_TO_EXPORT="$1"

case "$DATE_TO_EXPORT" in
  ????-??-??) calendar_export_date "$DATE_TO_EXPORT" ;;
  *) echo "Indica una fecha con formato YYYY-MM-DD" >&2; exit 1 ;;
esac
