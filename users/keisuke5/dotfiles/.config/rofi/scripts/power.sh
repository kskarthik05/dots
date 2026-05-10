#!/bin/sh

# rofi calls this in two ways:
# 1) without args → expects menu list
# 2) with selection → executes action

if [ $# -eq 0 ]; then
    printf "lock\nhibernate\npoweroff\nreboot\n"
    exit 0
fi

case "$1" in
    lock)
        swaylock -f
        ;;
    hibernate)
        systemctl hibernate
        ;;
    poweroff)
        systemctl poweroff
        ;;
    reboot)
        systemctl reboot
        ;;
esac
