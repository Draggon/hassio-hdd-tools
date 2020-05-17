CONFIG_PATH=/data/options.json

HDD_PATH="$(jq --raw-output '.hdd_path' $CONFIG_PATH)"
OUTPUT_FILE="$(jq --raw-output '.output_file' $CONFIG_PATH)"

SMARTCTL_OUTPUT=$(/usr/sbin/smartctl -a $HDD_PATH)
echo "$SMARTCTL_OUTPUT" > /share/hdd_tools/${OUTPUT_FILE}

ATTRIBUTES=$(echo "$SMARTCTL_OUTPUT" | egrep -o '^[0-9 ]+.*[0-9]+$' | awk '{print "\"" $2 "\":\"" $(NF) "\"," }' | awk '{print tolower($0)}' | tr -d '\n') 
MAIN_VALUE=$(echo "$SMARTCTL_OUTPUT" | grep Temperature_Celsius | awk '{print $(NF)}')
API_CALL_BODY='{"state": "'"$MAIN_VALUE"'", "attributes": {"unit_of_measurement":"°C","friendly_name":"Hdd Temp",'"${ATTRIBUTES::-1}"'}}'

echo "[$(date)][Info] Sensor value: $MAIN_VALUE°"
#echo "[$(date)][Debug] API call body: $API_CALL_BODY" > /proc/1/fd/1 2>/proc/1/fd/2

curl -X POST -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
       -s \
       -o /dev/null \
       -H "Content-Type: application/json" \
       -d "$API_CALL_BODY" \
       -w "[$(date)][Info] Sensor update response code: %{http_code}\n" \
       http://supervisor/core/api/states/sensor.hdd_temp 