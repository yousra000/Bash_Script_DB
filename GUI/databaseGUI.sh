#!/bin/bash

items=("1.Create Database" "2.List Database" "3.Connect To Databases" "4.Drop Database")

while item=$(zenity --title="Database options" --text="select one of the following: " --list \
               --column="Main menu" "${items[@]}" --width=300 --height=300)
do
    case "$item" in
	    "${items[0]}")
		    echo "Launching Create Database script..."
		    bash ./create_DB 
		    ;;
	    "${items[3]}")
		    echo "Launching Drop Database Script..."
		    bash ./dropFrom_DB
		    ;;
	    "${items[1]}")
		    echo "Launching List Database Script..."
		    bash ./listInfo_DB
		    ;;
        "${items[2]}") echo "Selected $item, item #3";;
        *) echo "Invalid option.";;
    esac
done
