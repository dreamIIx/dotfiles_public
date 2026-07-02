#!/bin/bash

# Get the ID of the active window
window_id=$(xdotool getactivewindow 2>/dev/null)

if [ -z "$window_id" ]; then
    # If no active window ID is found, set default name
    echo "󰇄 Desktop"
else
    # Get the WM_CLASS property of the active window
    wm_class=$(xprop -id $window_id WM_CLASS 2>/dev/null)

    if [ -z "$wm_class" ]; then
        # If no WM_CLASS is found, set default name
        echo "--"
    else
        # Extract the application name from the WM_CLASS property
        app_name=$(echo $wm_class | awk -F '"' '{print $4}')

		if [[ -z $app_name ]]; 
		then
			echo "󱜺"
		fi
        # Check for specific cases
		shopt -s nocasematch
        if [[ "$app_name" == *"code"* ]]; then
            echo " VSCode"
        elif [[ "$app_name" == *"kitty"* ]]; then
            echo " Kitty"
        elif [[ "$app_name" == *"vivaldi"* ]]; then
            echo " Vivaldi"
        elif [[ "$app_name" == *"okular"* ]]; then
            echo " Okular"
        elif [[ "$app_name" == *"steam"* ]]; then
            echo " Steam"
        elif [[ "$app_name" == *"telegram"* ]]; then
            echo " Telegram"
        elif [[ "$app_name" == *"xdg-desktop-portal"* ]]; then
            echo "󱧱 Portal"
        elif [[ "$app_name" == *"thunar"* ]]; then
            echo " Thunar"
        elif [[ "$app_name" == *"mpv"* ]]; then
            echo " mpv"
		else 
            echo "$app_name"
        fi
    fi
fi
