#!/bin/bash

choice=$(( $RANDOM % 4 ))
# if (( $choice == 0 ));

# then	alacritty -e ~/1/asciiquarium_spawn.sh & alock -cursor none -bg none; xdotool key --clearmodifiers q
# else	alacritty -e ~/1/cbonsai_spawn.sh & alock -cursor none -bg none; xdotool key --clearmodifiers q
# fi

base_spawn_path=~/1/
spawn_path=spawn_${choice}.sh
full_spawn_path=${base_spawn_path}${spawn_path}
echo ${full_spawn_path}
echo ${full_spawn_path} | xargs kitty -e & alock -cursor none -bg none -auth pam; xdotool key --clearmodifiers q; xdotool key --clearmodifiers y
