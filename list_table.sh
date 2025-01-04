#!/usr/bin/bash

db_path="$1"


if [ ! -d "$db_path" ]; then
    zenity --error --text="Error: The path '$db_path' is not a valid directory." --width=300
    exit 1
fi

tables=$(ls "$db_path" | grep ".meta$" | sed 's/.meta$//')

if [ -z "$tables" ]; then
    zenity --info --text="No tables found in the database path: $db_path" --width=300
    exit 0
fi

zenity --list --title="Available Tables" \
       --text="Tables in the database path: $db_path" \
       --column="Tables" $tables \
       --width=400 --height=300

