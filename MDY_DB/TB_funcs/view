#!/bin/bash


meta_file="$1"
data_file="$2"


if [[ ! -f "$data_file" || ! -s "$data_file" ]]; then
    
    columns=($(sed -n '1p' "$meta_file"))
    data_types=($(sed -n '2p' "$meta_file"))

    
    meta_info="No data available in the table.\n\nColumn Names and Data Types:\n"
    for i in "${!columns[@]}"; do
        meta_info="$meta_info${columns[i]} (${data_types[i]})\n"
    done

  
    zenity --info --title="Table is Empty" --text="$meta_info"
else
    
    table_data=$(cat "$data_file")

   
    columns=($(sed -n '1p' "$meta_file"))

    
    headers=""
    for column in "${columns[@]}"; do
        headers="$headers$column|"
    done
    headers="${headers%|}"

    
    zenity --list --title="Table View" --column="$headers" --text="Current Data:" --editable --width=800 --height=400 --ok-label="OK" <<< "$table_data"
fi

