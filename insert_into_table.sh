#!/usr/bin/bash

db_path="$1"

table_name=$(zenity --entry --text="Enter Table Name That You Want To Insert " --width=400)

meta_file="$db_path/${table_name}.meta"
data_file="$db_path/${table_name}.data"

if [[ ! -f $meta_file ]]; then
    zenity --error --text ="Table doesn't exist" --width=300
    exit 1
fi


IFS=' ' read -a columns < "$meta_file"  # Read column names w bakhzenha fe arr
IFS=' ' read -a data_types <<< "$(sed -n '2p' "$meta_file")"  # Read data types

row=()
for i in "${!columns[@]}"; do #! beacces index in array
    echo "Enter value for ${columns[i]} (type: ${data_types[i]}): "
    read value
    
    if [[ "${data_types[i]}" == "digit" && ! "$value" =~ ^[0-9]+$ ]]; then
        echo "Invalid value"
        exit
    elif [[ "${data_types[i]}" == "string" && "$value" =~ [^a-zA-Z] ]]; then
        echo "Invalid value"
        exit
    fi

    row+=("$value")
done

echo "${row[*]}" | tr ' ' ',' >> "$data_file"
echo "Row inserted successfully."

