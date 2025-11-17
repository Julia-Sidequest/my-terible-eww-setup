##### gets the latitude and longitude from latlon.txt ####################################################################################################################
mapfile -t latlon < "$HOME/.config/eww/latlon.txt"
lat="${latlon[0]}"
lon="${latlon[1]}"


##### gets the data from yr ##############################################################################################################################################
url="https://api.met.no/weatherapi/nowcast/2.0/complete?lat=${lat}&lon=${lon}"
data=$(curl -s "$url")
temp=$(jq -r '.properties.timeseries[0].data.instant.details.air_temperature' <<< "$data")
symbol=$(jq -r '.properties.timeseries[0].data.next_1_hours.summary.symbol_code' <<< "$data")
wind=$(jq -r '.properties.timeseries[0].data.instant.details.wind_speed' <<< "$data")


##### Checks if jq is installed ##########################################################################################################################################
if ! command -v jq &>/dev/null; then
    echo "Error: 'jq' is not installed."
    echo " Install with: sudo pacman -S jq"
    exit 1
fi


##### checks what the wether symbol is and returns it ###################################################################################################################
case "$symbol" in
    # Clear sky
    clearsky_day) icon=" " ;;       # day
    clearsky_night) icon=" " ;;     # night
    clearsky_polartwilight) icon=" " ;;  # polar twilight

    # Fair
    fair_day) icon="󰖕 " ;;               # day
    fair_night) icon="󰼱 " ;;             # night
    fair_polartwilight) icon="󰼱 " ;;     # polar twilight

    # Partly cloudy
    partlycloudy_day) icon="󰖕 " ;;      # day
    partlycloudy_night) icon="󰼱 " ;;    # night
    partlycloudy_polartwilight) icon="󰼱 " ;;  # polar twilight

    # Cloudy
    cloudy) icon=" " ;;              # always

    # Rain
    lightrain|lightrainshowers_day) icon=" " ;;      # day
    lightrainshowers_night) icon=" " ;;             # night
    lightrainshowers_polartwilight) icon=" " ;;     # polar twilight
    rain|rainshowers_day) icon=" " ;;                     # day
    rainshowers_night) icon=" " ;;                        # night
    rainshowers_polartwilight) icon=" " ;;                # polar twilight
    heavyrain|heavyrainshowers_day) icon=" " ;;     # day
    heavyrainshowers_night) icon=" " ;;             # night
    heavyrainshowers_polartwilight) icon=" " ;;     # polar twilight

    # Snow
    lightsnow|lightsnowshowers_day) icon=" " ;;     # day
    lightsnowshowers_night) icon=" " ;;            # night
    lightsnowshowers_polartwilight) icon=" " ;;    # polar twilight
    snow|snowshowers_day) icon=" " ;;                    # day
    snowshowers_night) icon=" " ;;                       # night
    snowshowers_polartwilight) icon=" " ;;               # polar twilight
    heavysnow|heavysnowshowers_day) icon=" " ;;    # day
    heavysnowshowers_night) icon=" " ;;            # night
    heavysnowshowers_polartwilight) icon=" " ;;    # polar twilight

    # Sleet
    lightsleet|lightsleetshowers_day) icon=" " ;;   # day
    lightsleetshowers_night) icon=" " ;;           # night
    lightsleetshowers_polartwilight) icon=" " ;;   # polar twilight
    sleet|sleetshowers_day) icon=" " ;;                  # day
    sleetshowers_night) icon=" " ;;                       # night
    sleetshowers_polartwilight) icon=" " ;;              # polar twilight
    heavysleet|heavysleetshowers_day) icon=" " ;;   # day
    heavysleetshowers_night) icon=" " ;;           # night
    heavysleetshowers_polartwilight) icon=" " ;;   # polar twilight

    # Thunderstorm
    thunderstorm|lightrainandthunder|rainandthunder|heavyrainandthunder|lightsnowandthunder|snowandthunder|heavysnowandthunder|lightsleetandthunder|sleetandthunder|heavysleetandthunder) icon="󰙾 " ;;                       # always
    
    # Fallback
    *) icon="$symbol" ;;
esac


##### fixed temperature gauge so it will fill up as it get's hoter #######################################################################################################
if (( $temp >= 0 && $temp <= 12 )); then
	termo=""
elif (( $temp >= 13 && $temp <= 17 )); then
    termo=""
elif (( $temp >= 18 && $temp <= 25 )); then
    termo=""
elif (( $temp >= 26 && $temp <= 100 )); then
    termo=""
else    
    termo=""
fi
    	


##### Outputs the data ###################################################################################################################################################
echo "${temp//./,}$termo°C ${icon}${wind//./,}m/s" 

