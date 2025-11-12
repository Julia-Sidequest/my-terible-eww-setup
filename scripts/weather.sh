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


##### Outputs the data ###################################################################################################################################################
echo "${temp//./,}°C ${symbol} ${wind//./,} m/s" 

