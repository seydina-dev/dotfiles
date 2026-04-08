#!/bin/bash

DIR=$HOME/Pictures/wallpapers/
PICS=($(find ${DIR} -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" \)))
RANDOMPICS=${PICS[ $RANDOM % ${#PICS[@]} ]}

change_swaybg(){
  pkill awww
  pkill swaybg
  swaybg -m fill -i ${RANDOMPICS}
}

change_awww(){
  pkill swaybg
  awww query || awww-daemon &
  awww img ${RANDOMPICS} --transition-fps 30 --transition-type any --transition-duration 3
}

change_current(){
  if pidof swaybg > /dev/null; then
    change_swaybg
  else
    change_awww
  fi
}

switch(){
  if pidof swaybg > /dev/null; then
    change_awww
  else
    change_swaybg
  fi
}

case "$1" in
	"swaybg")
		change_swaybg
		;;
	"awww")
		change_awww
		;;
  "s")
		switch
		;;
	*)
		change_current
		;;
esac