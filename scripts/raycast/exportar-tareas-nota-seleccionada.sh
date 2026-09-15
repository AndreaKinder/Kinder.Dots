#!/bin/sh

# @raycast.schemaVersion 1
# @raycast.title Exportar tareas de una nota diaria
# @raycast.mode compact
# @raycast.packageName Notas diarias
# @raycast.description Exporta las tareas pendientes de una nota diaria indicada
# @raycast.argument1 {"type":"text", "placeholder":"YYYY-MM-DD", "optional":true}

JOURNAL_DIR="/Volumes/Files/notes/journal"
REQUESTED_DATE="${1:-$(date +%Y-%m-%d)}"

case "$REQUESTED_DATE" in
  ????-??-??) ;;
  *) echo "Indica una fecha con formato YYYY-MM-DD" >&2; exit 1 ;;
esac

NOTE="$JOURNAL_DIR/$REQUESTED_DATE.md"

if [ ! -f "$NOTE" ]; then
  echo "No existe la nota diaria: $NOTE" >&2
  exit 1
fi

osascript - "$NOTE" <<'APPLESCRIPT'
on run argv
    set notePath to item 1 of argv
    set currentSection to ""
    set exported to 0
    set failures to 0

    set noteFile to POSIX file notePath
    set originalText to read noteFile as «class utf8»
    set noteLines to paragraphs of originalText
    set updatedLines to {}

    repeat with currentLine in noteLines
        set lineText to contents of currentLine

        if lineText starts with "## " or lineText starts with "### " or lineText starts with "#### " or lineText starts with "##### " or lineText starts with "###### " then
            set headingParts to my splitText(lineText, " ")
            if (count of headingParts) > 1 then
                set currentSection to my joinItems(headingParts, 2, (count of headingParts), " ")
            end if
            set end of updatedLines to lineText
        else if my isPendingTask(lineText) and currentSection is not "" then
            set taskText to my taskTextFromLine(lineText)
            set cleanTaskText to my cleanWikiLinks(taskText)

            if cleanTaskText is not "" then
                try
                    tell application "Reminders"
                        if not (exists list currentSection) then
                            make new list with properties {name:currentSection}
                        end if
                        make new reminder at end of reminders of list currentSection with properties {name:cleanTaskText}
                    end tell

                    set end of updatedLines to my completedTaskLine(lineText, cleanTaskText)
                    set exported to exported + 1
                on error errorMessage
                    log "No se pudo exportar " & cleanTaskText & ": " & errorMessage
                    set end of updatedLines to lineText
                    set failures to failures + 1
                end try
            else
                set end of updatedLines to lineText
            end if
        else
            set end of updatedLines to lineText
        end if
    end repeat

    set AppleScript's text item delimiters to linefeed
    set updatedText to updatedLines as text
    set AppleScript's text item delimiters to ""
    set fileRef to open for access noteFile with write permission
    set eof of fileRef to 0
    write updatedText to fileRef as «class utf8»
    close access fileRef

    if failures > 0 then
        do shell script "echo " & quoted form of ("Exportadas " & exported & " tareas; errores: " & failures) & " >&2"
        error number -128
    else
        return "Exportadas " & exported & " tareas desde " & (name of (info for noteFile))
    end if
end run

on isPendingTask(lineText)
    return lineText starts with "- [ ] " or lineText starts with "* [ ] " or lineText starts with "+ [ ] " or lineText contains (tab & "- [ ] ") or lineText contains (tab & "* [ ] ") or lineText contains (tab & "+ [ ] ")
end isPendingTask

on taskTextFromLine(lineText)
    set AppleScript's text item delimiters to "[ ] "
    set parts to text items of lineText
    set AppleScript's text item delimiters to ""
    if (count of parts) > 1 then return item 2 of parts
    return ""
end taskTextFromLine

on completedTaskLine(lineText, cleanTaskText)
    set prefix to text 1 thru ((offset of "[ ] " in lineText) + 2) of lineText
    return prefix & cleanTaskText
end completedTaskLine

on cleanWikiLinks(taskText)
    set resultText to taskText
    repeat while resultText contains "[["
        set startPosition to offset of "[[" in resultText
        set endPosition to offset of "]]" in (text startPosition thru -1 of resultText)
        if endPosition is 0 then exit repeat
        set endPosition to startPosition + endPosition + 1
        set linkText to text startPosition thru endPosition of resultText
        if linkText contains "|" then
            set AppleScript's text item delimiters to "|"
            set visibleParts to text items of linkText
            set replacement to item -1 of visibleParts
            set AppleScript's text item delimiters to ""
        else
            set replacement to text 3 thru -3 of linkText
        end if
        set resultText to (text 1 thru (startPosition - 1) of resultText) & replacement & (text (endPosition + 1) thru -1 of resultText)
    end repeat
    return resultText
end cleanWikiLinks

on splitText(inputText, separator)
    set AppleScript's text item delimiters to separator
    set resultList to text items of inputText
    set AppleScript's text item delimiters to ""
    return resultList
end splitText

on joinItems(itemList, firstItem, lastItem, separator)
    set selectedItems to items firstItem thru lastItem of itemList
    set AppleScript's text item delimiters to separator
    set resultText to selectedItems as text
    set AppleScript's text item delimiters to ""
    return resultText
end joinItems
APPLESCRIPT
