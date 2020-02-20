#!/bin/bash

basedir=$(dirname $0)

separator()
{
    echo -n " ^fg()| "
}

fg()
{
    echo -n "^fg($1)"
}

bg()
{
    echo -n "^bg($1)"
}

align()
{
    echo -n "^p($1)"
}

workspaces()
{
    for i  in {2..11}; do
        SPACE=$(bspc wm --get-status | cut -d ":" -f $i)
        if [ "${SPACE:0:1}" == 'O' ] || [ "${SPACE:0:1}" == "F" ]; then
            fg "#79abd2"
        #elif [ "${SPACE:0:1}" == 'o' ]; then
        #    fg
        elif [ "${SPACE:0:1}" == 'f' ]; then
            fg "#717171"
        elif [ "${SPACE:0:1}" == 'U' ]; then
            fg "#F2D134"
        elif [ "${SPACE:0:1}" == 'u' ]; then
            fg "#932727"
        fi
        echo -n "${SPACE:1} ^fg()| "
    done
}

curtime()
{
    echo -n " "$(date)
}

battery()
{
    echo -n "Charge: "
    charge=$(acpi | cut -d ',' -f2)
    #set color based on charge
    #time left? on hover maybe?
    echo -n $charge
}

diskspace()
{
    echo -n "Disk Usage: "
    usage=$(df -h /dev/sda | tail -n 1 | cut -d ' ' -f 14)
    echo -n $usage
}

keyboard()
{
    read -r enabled < $HOME/.keyboard
    if [ $enabled = "enabled" ]; then
        fg "#11AA11"
    elif [ $enabled = "disabled" ]; then
        fg "#AABFFF"
    fi
    echo -n "^ca(1, $basedir/keyboardtoggle.sh)$enabled^ca()"
}

mouse()
{
    read -r enabled < $HOME/.mouse
    if [ $enabled = "enabled" ]; then
        fg "#11AA11"
    elif [ $enabled = "disabled" ]; then
        fg "#AABFFF"
    fi
    echo -n "^ca(1, $basedir/mousetoggle.sh)$enabled^ca()"
}

mem()
{
  memory=$(free | awk '/Mem/ {printf "%d MiB/%d MiB\n", $3 / 1024.0, $2 / 1024.0 }')
  echo -n "🖪 $memory"
}

vol(){
    volume=$(amixer get Master | awk -F'[]%[]' '/%/ {if ($7 == "off") { print "MM" } else { print $2 }}' | head -n 1)
    echo -n "$volume%"
}

cpu(){
  read cpu a b c previdle rest < /proc/stat
  prevtotal=$((a+b+c+previdle))
  sleep 0.5
  read cpu a b c idle rest < /proc/stat
  total=$((a+b+c+idle))
  cpu=$((100( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
  echo -n "$cpu%"
}

temp(){
  temp1=$(sensors | awk '/Core 0/ {print $3}')
  echo -n "$temp1"
}

wth(){
  weather=$(curl -s v2.wttr.in | grep -e "Weather" | sed 's/C,./C/g; s/+//g; s/.*\[0m.//g; s/.//2')
  echo -n "$weather"
}


#ADD: mpc, vol
align "_LEFT"
workspaces
align "_CENTER"
align "-90"
curtime
align "_RIGHT"
align "-740"
# battery
# separator
diskspace
separator
# keyboard
separator
mem
separator
vol
separator
temp
separator
wth
# mouse
echo
