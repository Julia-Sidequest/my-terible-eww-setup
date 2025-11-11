#!/bin/bash


##### Getting the raw data from playerctl ################################################################################################################################
IFS="|" read -r artist album title < <(playerctl metadata --format '{{artist}}|{{album}}|{{title}}' 2>/dev/null) # gets information about what is playing ignoring empty 
playpause="$(playerctl status)"


##### Cleans up the data so it's easier to use ##########################################################################################################################
title=${title//\([^)]*\)/} 
album=${album//\([^)]*\)/} # removes anything inside of "()"
artist_lower="${artist,,}"


##### Setting up some variables that the scrip uses ######################################################################################################################
track="$artist: $album, $title"
trackshort="$album, $title"
repeat="100"
separator="     •     "
maxlength=57
artistlength=${#artist}
newlength=$((maxlength - artistlength)) 


##### Paths to other files that the script uses #########################################################################################################################
mapfile -t blacklist < "$HOME/.config/eww/blacklist.txt"
tickfile="/tmp/eww_ticker"


##### Makes sure the tickfile works #####################################################################################################################################
[[ -f "$tickfile" ]] && tick=$(<"$tickfile") || tick=0


##### Checks if we want to skip any track ###############################################################################################################################
for skip in "${blacklist[@]}"; do # iterates the list of artists to skip
    if [[ "$artist_lower" == "${skip,,}" ]]; then # skips if any of the artists match
        playerctl next
        exit 0
    fi
done

if [[ "${title,,}" == *" live "* ]]; then
    playerctl next
fi


##### Makes sure that long tracks scroll corecctly #######################################################################################################################
trackscroll=""
for ((i=0; i<repeat; i++)); do
    trackscroll+="$trackshort$separator" # repetedly puts the track short information into the trackscroll variable  
done   


##### Checks and outputs what if anything is playing and 
if [[ "$playpause" == "Playing" ]]; then # checks if something is playing
    if ((${#track} > maxlength)); then # checks if the track is to long
	((tick++))
	echo "$tick" > "$tickfile" # increases a counter by 1 
        start=$((tick % ${#trackscroll}))
	echo " Now playing:$artist: ${trackscroll:start:newlength}"
    else
	echo "0" > "$tickfile"    
        echo " Now playing: $track"
    fi
elif [[ "$playpause" == "Paused" ]]; then
    if ((${#track} > maxlength)); then # checks if the track is too long
	((tick++))
	echo "$tick" > "$tickfile" 
        start=$((tick % ${#trackscroll}))
	echo " Music paused:$artist: ${trackscroll:start:newlength}"
    else
	echo "0" > "$tickfile"    
        echo " Music paused: $track"
    fi
else  
    echo " nothing is playing, enjoy the silence"
fi

