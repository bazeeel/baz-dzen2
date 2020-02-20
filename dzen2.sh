#!/bin/bash
sleeptime=0.3
while true; do
    ~/.local/bin/statusbar.sh
sleep $sleeptime; done | dzen2 -e - -h '20' -w '1920' -ta l
