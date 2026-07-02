#!/bin/bash

killall -q polybar
echo "---" | tee -a /tmp/polybar.log
polybar root >> /tmp/polybar.log &
# sleep 1
# polybar bar2 >> /tmp/polybar.log & # Запуск бара example и запись его лога
# sleep 1
# polybar bar3 >> /tmp/polybar.log & # Запуск бара example и запись его лога

killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar $m &
  done
else
  polybar --reload primary &
fi
