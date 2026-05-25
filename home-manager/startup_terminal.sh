#!/usr/bin/env bash

CURRENT_WS=$(hyprctl activeworkspace | awk '/workspace ID/ { print $3 }')
kitty --class="grid_terminal" --title="top_left" -- bluetoothctl &
sleep 0.5
kitty --class="grid_terminal" --title="top_right" -- wiremix &  
sleep 0.5
kitty --class="grid_terminal" --title="bottom_left" --hold -- ~/.config/home-manager/hello-duck.sh &
sleep 0.5
hyprctl dispatch focuswindow title:^top_right$ 
sleep 0.5
kitty --class="grid_terminal" --title="bottom_right" &
sleep 0.5
hyprctl dispatch workspace $CURRENT_WS
