CONFIG_PATH=/data/options.json

SENSOR_NAME="$(jq --raw-output '.sensor_name' $CONFIG_PATH)"
FRIENDLY_NAME="$(jq --raw-output '.friendly_name' $CONFIG_PATH)"
HDD_PATH="$(jq --raw-output '.hdd_path' $CONFIG_PATH)"
DEBUG="$(jq --raw-output '.debug' $CONFIG_PATH)"
OUTPUT_FILE="$(jq --raw-output '.output_file' $CONFIG_PATH)"
ATTRIBUTES_PROPERTY="$(jq --raw-output '.attributes_property' $CONFIG_PATH)"
ATTRIBUTES_FORMAT="$(jq --raw-output '.attributes_format' $CONFIG_PATH)"

SMARTCTL_OUTPUT=$(/usr/sbin/smartctl -a $HDD_PATH --json)

if [ "$DEBUG" = "true" ]; then
    echo "$SMARTCTL_OUTPUT" > /share/hdd_tools/${OUTPUT_FILE}
fi

CURRENT_TEMPERATURE=$(echo $SMARTCTL_OUTPUT | jq --raw-output '.temperature.current')
SENSOR_DATA='{"state": "'"$CURRENT_TEMPERATURE"'", "attributes": {"unit_of_measurement":"°C","friendly_name":"'"$FRIENDLY_NAME"'"}}'

if ! [ -z "$ATTRIBUTES_PROPERTY" ]; then
    ATTRIBUTES=$(echo $SMARTCTL_OUTPUT | jq -e --raw-output ".${ATTRIBUTES_PROPERTY}" || echo "{}")

    case "$ATTRIBUTES_FORMAT" in
        object)
        ;;
        list)
            ATTRIBUTES=$(echo $ATTRIBUTES | jq 'map({(if .name == "Unknown_Attribute" then "Unknown_Attribute_" + (.id | tostring) else .name end): .raw.string | capture("^(?<value>[[:digit:]]+)").value | tonumber}) | add | with_entries(.key |= ascii_downcase)')
        ;;
        *)
            echo "[$(date)][ERROR] Unsupported attributes format \"$ATTRIBUTES_FORMAT\" given!"
            exit 1;
        ;;
    esac

    SENSOR_DATA=$(echo $SENSOR_DATA | jq ".attributes += $ATTRIBUTES")
fi

echo "[$(date)][INFO] Sensor value: ${CURRENT_TEMPERATURE}°"

if [ "$DEBUG" = "true" ]; then
    echo "[$(date)][DEBUG] Sensor data which would be pushed to home-assistant and exposed as \"$SENSOR_NAME\": $SENSOR_DATA"
    echo "[$(date)][DEBUG] debug is enabled, sensor data is not published to home-assistant!"
    exit 0;
fi

curl -X POST -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
       -s \
       -o /dev/null \
       -H "Content-Type: application/json" \
       -d "$SENSOR_DATA" \
       -w "[$(date)][INFO] Sensor update response code: %{http_code}\n" \
       http://supervisor/core/api/states/${SENSOR_NAME}
