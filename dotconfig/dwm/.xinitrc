#! /bin/sh
# for hybrid mode
#xrandr --output LVDS-1 --scale "1.4055x1.4062" & 
# nvidia mode
#xrandr --output VGA-0 --scale "1.875x1.4062" & 
~/.local/bin/dwmscripts/dwmbar
# setbg 
#while xsetroot -name "`date` `uptime | sed 's/.*,//'`"
# do
#	sleep 1
#done &
# sxhkd &
dunst &
# picom --experimental-backends &
#xrandr --setprovideroutputsource modesetting NVIDIA-0 &
#xrandr --auto &
while type dwm >/dev/null; do dwm && continue || break; done
#dwm

