CONFIG_PATH=/data/options.json

SENSOR_STATE_TYPE="$(jq --raw-output '.sensor_state_type' $CONFIG_PATH)"
SENSOR_NAME="$(jq --raw-output '.sensor_name' $CONFIG_PATH)"
FRIENDLY_NAME="$(jq --raw-output '.friendly_name' $CONFIG_PATH)"
HDD_PATH="$(jq --raw-output '.hdd_path' $CONFIG_PATH)"
DEVICE_TYPE="$(jq --raw-output '.device_type' $CONFIG_PATH)"
DEBUG="$(jq --raw-output '.debug' $CONFIG_PATH)"
OUTPUT_FILE="$(jq --raw-output '.output_file' $CONFIG_PATH)"
ATTRIBUTES_PROPERTY="$(jq --raw-output '.attributes_property' $CONFIG_PATH)"
ATTRIBUTES_FORMAT="$(jq --raw-output '.attributes_format' $CONFIG_PATH)"

SMARTCTL_OUTPUT=$(/usr/sbin/smartctl -a $HDD_PATH -d $DEVICE_TYPE --json)

if [ "$DEBUG" = "true" ]; then
    echo "$SMARTCTL_OUTPUT" > /share/hdd_tools/${OUTPUT_FILE}
fi

if ! [ -z "$SENSOR_STATE_TYPE" ]; then
    case "$SENSOR_STATE_TYPE" in
        temperature)
            if [[ $SENSOR_NAME != sensor\.* ]]; then
                echo "[$(date)][ERROR] The sensor name \"$SENSOR_NAME\" must start by 'sensor.' for 'temperature' mode!"
                exit 1
            fi
            TEMPERATURE_VALUE=$(echo $SMARTCTL_OUTPUT | jq --raw-output '.temperature.current')
            echo "[$(date)][INFO] Sensor value as temperature: ${TEMPERATURE_VALUE}"
            SENSOR_DATA='{"state": "'"$TEMPERATURE_VALUE"'", "attributes": {"unit_of_measurement":"°C","friendly_name":"'"$FRIENDLY_NAME"'","device_class":"temperature","state_class":"measurement"}}'
        ;;
        smart_state)
            if [[ $SENSOR_NAME != binary_sensor\.* ]]; then
                echo "[$(date)][ERROR] The sensor name \"$SENSOR_NAME\" must start by 'binary_sensor.' for 'smart_state' mode!"
                exit 1
            fi
            SMART_STATUS_VALUE=$(echo $SMARTCTL_OUTPUT | jq --raw-output '.smart_status.passed')            
            PROBLEM_STATUS_VALUE="on"
            if [ "$SMART_STATUS_VALUE" = "true" ]; then
                PROBLEM_STATUS_VALUE="off"
            fi
            echo "[$(date)][INFO] Sensor value as smart_state: ${SMART_STATUS_VALUE}, problem: ${PROBLEM_STATUS_VALUE}"
            SENSOR_DATA='{"state": "'"$PROBLEM_STATUS_VALUE"'", "attributes": {"friendly_name":"'"$FRIENDLY_NAME"'","device_class":"problem"}}'
        ;;
        *)
            echo "[$(date)][ERROR] Unsupported sensor state type \"$SENSOR_STATE_TYPE\" given!"
            exit 1
        ;;
    esac
fi

if [ "$DEBUG" = "true" ]; then
    echo "[$(date)][DEBUG] Sensor data before attributes: $SENSOR_DATA"
fi

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
