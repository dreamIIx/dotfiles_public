#!/bin/bash
xprop -spy -root _NET_CURRENT_DESKTOP | while read change;
do
   polybar-msg -p $(pidof polybar) hook desk 1>/dev/null
done
