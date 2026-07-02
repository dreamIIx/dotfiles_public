#!/bin/zsh

source ~/.cache/wal/colors.sh

if [ $(systemctl status bluetooth | grep "active (running)" | wc -c) -eq 0 ]
then
	echo "%{F#707880}󰂯"
else
	if [ $(echo info | bluetoothctl | grep 'Paired' | grep 'yes' | wc -c) -eq 0 ]
	then
		echo "%{F$color7}󰂯"
	fi
	battery_percentage=$(echo info | bluetoothctl | grep 'Battery Percentage' | cut -d '(' -f 2 | cut -d ')' -f 1)
	if [[ "$battery_percentage" =~ ^[0-9]+$ ]]; then
		if (( $battery_percentage > 80 ));
		then
			battery_percentage="󰁹"
		elif (( $battery_percentage > 60 ));
		then
			battery_percentage="󰂀"
		elif (( $battery_percentage > 40 ));
		then
			battery_percentage="󰁾"
		elif (( $battery_percentage > 20 ));
		then
			battery_percentage="󰁼"
		elif (( $battery_percentage > 10 ));
		then
			battery_percentage="󰁺"
		elif (( $battery_percentage > 0 ));
		then
			battery_percentage="󱃍"
		elif (( $battery_percentage == 0 ));
		then
			battery_percentage="󱃍"
		fi
	else
		echo "%{F$color7}󰥊"
	fi
	echo "%{F$color7}󰂱$battery_percentage"
fi
