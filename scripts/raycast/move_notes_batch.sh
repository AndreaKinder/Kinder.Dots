#!/bin/sh

# Uso: ./move_notes_batch.sh "carpeta_destino" "archivo_con_titulos.txt"

TARGET_FOLDER=$1
INPUT_FILE=$2

if [ -z "$TARGET_FOLDER" ] || [ -z "$INPUT_FILE" ]; then
    echo "Uso: $0 <carpeta_destino> <archivo_con_titulos.txt>"
    exit 1
fi

while IFS= read -r note_title; do
    if [ -n "$note_title" ]; then
        echo "Moviendo nota: $note_title..."
        osascript -e "tell application \"Notes\"
            try
                set targetFolder to folder \"$TARGET_FOLDER\" of account \"iCloud\"
                set noteList to (every note whose name is \"$note_title\")
                if (count of noteList) > 0 then
                    move item 1 of noteList to targetFolder
                else
                    log \"Nota no encontrada: $note_title\"
                end if
            on error err
                log \"Error moviendo $note_title: \" & err
            end try
        end tell"
    fi
done < "$INPUT_FILE"
