#!/bin/zsh

percentage=$(acpi -Vs | head -n 1 | cut -d ',' -f 2 | sed 's/ //g')
is_connected=$(acpi -Vs | head -n 1 | cut -d ',' -f 1 | cut -d ' ' -f 3 | tr '[:upper:]' '[:lower:]' | sed 's/discharging/!/g' | sed 's/charging/+/g' | sed 's/full/+++/g' | sed 's/not/~~~/g')
# Discharging/Charging/Full/Not charging

if [[ "$is_connected" == "+++" || "$is_connected" == "~~~" ]];
then
	echo "$is_connected"
else
	echo "$is_connected$percentage"
fi

