#!/usr/bin/bash

db_path="$1"

table_name=$(zenity --entry --text="Enter Table Name That You Want To Drop: " --width=400)

meta_file="$db_path/${table_name}.meta"
data_file="$db_path/${table_name}.data"
if [[ -f "$meta_file" ]]; then
      zenity --question --text="Are you sure you want to delete table '$table_name'?" --width=300
            response=$?

            if [ $response -eq 0 ]; then
                rm -r "$meta_file" "$data_file"
                zenity --info --text="table '$table_name' has been dropped successfully" --width=300
            elif [ $response -eq 1 ]; then
                zenity --info --text="table was not removed" --width=300
	    fi
    else
	    zenity --error --text="Invalid table name"
	    exit 1
fi