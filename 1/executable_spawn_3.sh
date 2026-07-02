#!/bin/bash

bspc node -t fullscreen & misfortune -s -n 30 | awk '{print "\""$0"\""}' | tee /usr/share/arttime/textart/myart1 | figlet >> /usr/share/arttime/textart/myart1; arttime --nolearn -a myart1
