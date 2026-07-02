#!/bin/bash

bspc node -t fullscreen & xargs -0 -a <(misfortune -m "awesome") -I{} cbonsai -l -L 32 -i -w 10 -t 0.03 -m {}
