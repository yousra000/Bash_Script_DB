#!/usr/bin/bash


exec 2>/dev/null


table_name=$(zenity --entry --text="Enter Table Name That You Want To Insert" --width=400)


db_path="$1"
meta_file="$db_path/${table_name}.meta"
data_file="$db_path/${table_name}.data"


if [[ ! -f "$meta_file" ]]; then
    zenity --error --text="Table doesn't exist" --width=300
    exit 1
fi


./view.sh "$meta_file" "$data_file"


IFS=' ' read -a columns_array <<< "$(sed -n '1p' "$meta_file")"
IFS=' ' read -a data_types_array <<< "$(sed -n '2p' "$meta_file")"


id_index=-1
for i in "${!columns_array[@]}"; do
    if [[ "${columns_array[i]}" == "id" ]]; then
        id_index=$i
        break
    fi
done

row=()


for i in "${!columns_array[@]}"; do
    while :; do
        value=$(zenity --entry --title="Enter Value" --text="Enter value for ${columns_array[i]} (type: ${data_types_array[i]}):")

        
        [[ $? -ne 0 ]] && exit 1

        
        if [[ "${data_types_array[i]}" == "int" && ! "$value" =~ ^[0-9]+$ ]]; then
            zenity --error --text="Invalid value. Enter a valid number."
            continue
        elif [[ "${data_types_array[i]}" == "string" && "$value" =~ [^a-zA-Z] ]]; then
            zenity --error --text="Invalid value. Enter a valid string."
            continue
        fi

       
        if [[ $i -eq $id_index ]]; then
            if [[ -s "$data_file" && $(cut -d',' -f$((id_index + 1)) "$data_file" | grep -w "$value") ]]; then
                zenity --error --text="ID must be unique. The value '$value' already exists."
                continue
            fi
        fi

        row+=("$value")
        break
    done
done

echo "${row[*]}" | tr ' ' ',' >> "$data_file"
zenity --info --text="Row inserted successfully."

