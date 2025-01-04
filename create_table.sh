#!/usr/bin/bash

source ./conditions


db_path="$1"


name_table=$(zenity --entry --title="Create Table" --text="Enter Table Name:" --width=400)
name_table=$(echo "$name_table" | tr ' ' '_')


CheckIfValid "$name_table"
if [ $? -ne 0 ]; then
    zenity --error --text="Invalid table name. Only alphanumeric characters are allowed." --width=300
    exit 1
fi


data_file="$db_path/${name_table}.data"
meta_data_file="$db_path/${name_table}.meta"


if [ -f "$meta_data_file" ]; then
    zenity --error --text="The table '$name_table' already exists in the selected database." --width=300
    exit 1
fi


num_col=$(zenity --entry --title="Number of Columns" --text="Enter Number of Columns:" --width=300)

if ! [[ "$num_col" =~ ^[0-9]+$ ]] || [ "$num_col" -le 0 ]; then
    zenity --error --text="Invalid number of columns. Please enter a positive integer." --width=300
    exit 1
fi


column=()
data_type=()


for ((i=1; i<=num_col; i++)); do
    col_name=$(zenity --entry --title="Column Name" --text="Enter name for column $i:" --width=400)

    
    CheckIfValid "$col_name"
    if [ $? -ne 0 ]; then
        zenity --error --text="Invalid column name for column $i. Only alphanumeric characters are allowed." --width=300
        exit 1
    fi
    column+=("$col_name")

    col_type=$(zenity --list --title="Data Type" --text="Select data type for column $i:" \
        --column="Data Type" "string" "int" --width=400 --height=200)

    if [ $? -ne 0 ] || { [ "$col_type" != "string" ] && [ "$col_type" != "int" ]; }; then
        zenity --error --text="Invalid data type for column $i. Please select 'string' or 'int'." --width=300
        exit 1
    fi
    data_type+=("$col_type")
done


echo "${column[*]}" > "$meta_data_file"
echo "${data_type[*]}" >> "$meta_data_file"


touch "$data_file"

zenity --info --text="Table '$name_table' created successfully in database '$db_path'." --width=300

