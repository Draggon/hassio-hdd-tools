CONFIG_PATH=/data/options.json

HDD_PATH="$(jq --raw-output '.hdd_path' $CONFIG_PATH)"
OUTPUT_FILE="$(jq --raw-output '.output_file' $CONFIG_PATH)"
ATTRIBUTES_PROPERTY="$(jq --raw-output '.attributes_property' $CONFIG_PATH)"

SMARTCTL_OUTPUT=$(/usr/sbin/smartctl -a $HDD_PATH --json)
echo "$SMARTCTL_OUTPUT" > /share/hdd_tools/${OUTPUT_FILE}

CURRENT_TEMPERATURE=$(echo $SMARTCTL_OUTPUT | jq --raw-output '.temperature.current')
SENSOR_DATA='{"state": "'"$CURRENT_TEMPERATURE"'", "attributes": {"unit_of_measurement":"°C","friendly_name":"HDD Temperature"}}'

if ! [ -z "$ATTRIBUTES_PROPERTY" ]; then
    ATTRIBUTES=$(echo $SMARTCTL_OUTPUT | jq -e --raw-output '.$ATTRIBUTES_PROPERTY' || echo "{}")
    SENSOR_DATA=$(echo $SENSOR_DATA | jq -n ".attributes += $ATTRIBUTES")
fi

echo "[$(date)][Info] Sensor value: $CURRENT_TEMPERATURE°"

curl -X POST -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
       -s \
       -o /dev/null \
       -H "Content-Type: application/json" \
       -d "$SENSOR_DATA" \
       -w "[$(date)][Info] Sensor update response code: %{http_code}\n" \
       http://supervisor/core/api/states/sensor.system_disk
