#!/bin/bash


##### Gets the information about the artist and makes it lowercase ######################################################################################################
artist="$(playerctl metadata artist)" 
artist_lower="${artist,,}"


##### Writes the name of the artist I don't want to hear to blacklist.txt ############################################################################################### 
echo "$artist_lower" >> "$HOME/.config/eww/blacklist.txt"


