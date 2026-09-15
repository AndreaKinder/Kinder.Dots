#!/bin/sh

JOURNAL="/Volumes/Files/notes/journal"

calendar_export_date() {
  event_date="$1"
  note="$JOURNAL/$event_date.md"

  [ -f "$note" ] || { echo "No existe la nota diaria: $note" >&2; return 1; }

  events=$(awk '
    /^events:/ {
      in_events=1
      value=$0
      sub(/^events:[[:space:]]*/, "", value)
      if (value != "" && value != "[]" && value != "\"\"") print value
      next
    }
    in_events && /^[[:space:]]+-[[:space:]]+/ {
      sub(/^[[:space:]]+-[[:space:]]+/, "")
      print
      next
    }
    in_events && /^[^[:space:]-]/ { in_events=0 }
  ' "$note" | sed 's/^[-*][[:space:]]*//' | sed 's/^"//; s/"$//' | sed '/^[[:space:]]*$/d')

  [ -n "$events" ] || { echo "No hay eventos en $note"; return 0; }

  printf '%s\n' "$events" | while IFS= read -r event_name; do
    [ -n "$event_name" ] || continue
    osascript - "$event_date" "$event_name" <<'APPLESCRIPT'
on run argv
    set eventDateText to item 1 of argv
    set eventSummary to item 2 of argv

    set eventDate to current date
    set year of eventDate to (text 1 thru 4 of eventDateText) as integer
    set month of eventDate to (text 6 thru 7 of eventDateText) as integer
    set day of eventDate to (text 9 thru 10 of eventDateText) as integer
    set time of eventDate to 0
    set nextDate to eventDate + (24 * hours)

    tell application "Calendar"
        set targetCalendar to first calendar
        make new event at end of events of targetCalendar with properties {summary:eventSummary, start date:eventDate, end date:nextDate, allday event:true}
    end tell
end run
APPLESCRIPT
  done

  echo "Eventos exportados desde $(basename "$note")"
}
