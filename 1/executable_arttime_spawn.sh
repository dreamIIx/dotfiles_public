#!/bin/bash

bspc node -t fullscreen & xargs -0 -a <(misfortune -m "night" -L 1 -s) -I{} arttime --nolearn -a colorowl2 -b colorowl3 -t {}
