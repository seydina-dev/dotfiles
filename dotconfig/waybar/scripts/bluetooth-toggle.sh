#!/bin/bash
if bluetoothctl show | grep -q "Powered: yes"; then
    bluetoothctl power off
    notify-send "Bluetooth" "Powered Off" -i bluetooth
else
    bluetoothctl power on
    notify-send "Bluetooth" "Powered On" -i bluetooth
fi
