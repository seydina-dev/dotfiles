#!/bin/sh

## CPU
cpu() {
  read cpu a b c previdle rest < /proc/stat
  prevtotal=$((a+b+c+previdle))
  sleep 0.5
  read cpu a b c idle rest < /proc/stat
  total=$((a+b+c+idle))
  cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
  echo -e "  $cpu%"
}

## RAM
mem() {
  mem="$(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
  echo -e " $mem"
}

## TEMP
temp(){
	TEMP="$(sensors|awk 'BEGIN{i=0;t=0;b=0}/id [0-9]/{b=$4};/Core/{++i;t+=$3}END{if(i>0){printf("%0.1f\n",t/i)}else{sub(/[^0-9.]/,"",b);print b}}')"
	printf " %s \\n" "$TEMP"
}

net() {
R1=`cat /sys/class/net/wlan0/statistics/rx_bytes`
T1=`cat /sys/class/net/wlan0/statistics/tx_bytes`
sleep 1
R2=`cat /sys/class/net/wlan0/statistics/rx_bytes`
T2=`cat /sys/class/net/wlan0/statistics/tx_bytes`
TBPS=`expr $T2 - $T1`
RBPS=`expr $R2 - $R1`
TKBPS=`expr $TBPS / 1024`
RKBPS=`expr $RBPS / 1024`
echo "🔻 $RKBPS kb  🔺 $TKBPS kb"
}

## BATT
power() {
STATUS=$(cat /sys/class/power_supply/BAT0/status)
BATT=$(cat /sys/class/power_supply/BAT0/capacity)

if [ "$STATUS" = "Discharging" ]; then

    ICON="🔋"
else
    ICON="⚡"
fi
echo " $ICON" "$BATT%"
}

## WIFI
wifi() {
dev="$(nmcli dev|grep wlan0)"
status="$(nmcli dev|grep wlan0|awk '{print $3}')"
ssid="$(nmcli dev|grep wlan0|awk '{print $4}')"
[[ "$status" == "connected" ]] && printf "  $ssid\n" || printf "$status\n"
}

## DATE
clock() {
dte="$(date +"%a, %B %d %l:%M%p"| sed 's/  / /g')"
echo -e "$dte "
}

while true; do
#xsetroot -name "|  $(cpu) |  $(mem) |   $(hdd) |  $(power) |  $(temp) |   $(volume) | $(date) |"
	xsetroot -name " $(net) | $(wifi) |  $(mem) | $(temp) | $(cpu) | $(power) | $(clock) "
	
	sleep 5s
done &

