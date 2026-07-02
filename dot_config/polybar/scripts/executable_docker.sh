#!/bin/zsh

source ~/.cache/wal/colors.sh

if [[ $(systemctl status docker | grep "active (running)" | wc -c) -eq 0 ]];
then
	echo "%{F#707880}";
else
	echo "%{F$color7}";
fi
