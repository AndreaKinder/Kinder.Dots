#!/bin/sh

VAULT="/Volumes/Files/notes"
JOURNAL="$VAULT/journal"

notes_export_one() {
  note_path="$1"
  destination_folder="${2:-Obsidian Importadas}"

  case "$note_path" in
    "$JOURNAL"/*) echo "Se ignora una nota diaria: $note_path" >&2; return 0 ;;
  esac

  [ -f "$note_path" ] || { echo "No existe: $note_path" >&2; return 1; }

  title=$(awk '
    /^# / { sub(/^# /, ""); print; exit }
  ' "$note_path")
  [ -n "$title" ] || title=$(basename "$note_path" .md)

  osascript - "$note_path" "$title" "$destination_folder" <<'APPLESCRIPT'
on run argv
    set sourcePath to item 1 of argv
    set noteTitle to item 2 of argv
    set destinationFolder to item 3 of argv
    set sourceFile to POSIX file sourcePath
    set rawText to read sourceFile as «class utf8»

    tell application "Notes"
        if not (exists folder destinationFolder) then
            make new folder with properties {name:destinationFolder}
        end if
        set targetFolder to folder destinationFolder

        set noteBody to "<h1>" & my escapeHTML(noteTitle) & "</h1><br/>"
        repeat with p in paragraphs of rawText
            set paragraphText to contents of p
            set noteBody to noteBody & "<p>" & my escapeHTML(paragraphText) & "</p>"
        end repeat

        make new note at targetFolder with properties {name:noteTitle, body:noteBody}
    end tell
end run

on escapeHTML(valueText)
    set valueText to my replaceText("&", "&amp;", valueText)
    set valueText to my replaceText("<", "&lt;", valueText)
    set valueText to my replaceText(">", "&gt;", valueText)
    return valueText
end escapeHTML

on replaceText(findText, replaceWith, sourceText)
    set AppleScript's text item delimiters to findText
    set textItems to text items of sourceText
    set AppleScript's text item delimiters to replaceWith
    set resultText to textItems as text
    set AppleScript's text item delimiters to ""
    return resultText
end replaceText
APPLESCRIPT
}

notes_export_source() {
  source="$1"
  destination_folder="${2:-Obsidian Importadas}"

  if [ -z "$source" ]; then
    echo "Uso: all | ruta-de-carpeta | ruta-de-nota.md" >&2
    return 1
  fi

  case "$source" in
    all)
      find "$VAULT" -type f -name '*.md' ! -path "$JOURNAL/*" -print0
      ;;
    /*)
      if [ -d "$source" ]; then
        find "$source" -type f -name '*.md' ! -path "$JOURNAL/*" -print0
      else
        printf '%s\0' "$source"
      fi
      ;;
    *)
      path="$VAULT/$source"
      if [ -d "$path" ]; then
        find "$path" -type f -name '*.md' ! -path "$JOURNAL/*" -print0
      else
        printf '%s\0' "$path"
      fi
      ;;
  esac | while IFS= read -r -d '' file; do
    notes_export_one "$file" "$destination_folder" || exit 1
    echo "Exportada: $file"
  done
}
