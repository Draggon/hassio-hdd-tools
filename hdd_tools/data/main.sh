CONFIG_PATH=/data/options.json
SMARTCTL_BINARY=/usr/sbin/smartctl

# Test configuration (do not commit)
#CONFIG_PATH=./test_options.json
#SMARTCTL_BINARY=/opt/homebrew/bin/smartctl

# Get configuration
SENSOR_STATE_TYPE="$(jq --raw-output '.sensor_state_type' $CONFIG_PATH)"
MERGED_SENSOR_STATE_TYPES=$(jq --arg newSensor "$SENSOR_STATE_TYPE" '.additional_sensor_state_types + [$newSensor]' "$CONFIG_PATH")
SENSOR_NAME="$(jq --raw-output '.sensor_name' $CONFIG_PATH)"
MERGED_SENSOR_NAMES=$(jq --arg newSensor "$SENSOR_NAME" '.additional_sensor_names + [$newSensor]' "$CONFIG_PATH")
FRIENDLY_NAME="$(jq --raw-output '.friendly_name' $CONFIG_PATH)"
MERGED_FRIENDLY_NAMES=$(jq --arg newFriendly "$FRIENDLY_NAME" '.additional_friendly_names + [$newFriendly]' "$CONFIG_PATH")
HDD_PATH="$(jq --raw-output '.hdd_path' $CONFIG_PATH)"
MERGED_HDD_PATHS=$(jq --arg newHdd "$HDD_PATH" '.additional_hdd_paths + [$newHdd]' "$CONFIG_PATH")
DEVICE_TYPE="$(jq --raw-output '.device_type' $CONFIG_PATH)"
MERGED_DEVICE_TYPES=$(jq --arg newDevice "$DEVICE_TYPE" '.additional_device_types + [$newDevice]' "$CONFIG_PATH")
DEBUG="$(jq --raw-output '.debug' $CONFIG_PATH)"
OUTPUT_FILE="$(jq --raw-output '.output_file' $CONFIG_PATH)"
ATTRIBUTES_PROPERTY="$(jq --raw-output '.attributes_property' $CONFIG_PATH)"
MERGED_ATTRIBUTES_PROPERTY=$(jq --arg newAttributes "$ATTRIBUTES_PROPERTY" '.additional_attributes_properties + [$newAttributes]' "$CONFIG_PATH")
ATTRIBUTES_FORMAT="$(jq --raw-output '.attributes_format' $CONFIG_PATH)"
MERGED_ATTRIBUTES_FORMAT=$(jq --arg newAttributesFormat "$ATTRIBUTES_FORMAT" '.additional_attributes_formats + [$newAttributesFormat]' "$CONFIG_PATH")

if [ "$DEBUG" = "true" ]; then
    # Print the merged arrays
    echo "Merged Sensor State Types: ${MERGED_SENSOR_STATE_TYPES[*]}"
    echo "Merged Sensor Names: ${MERGED_SENSOR_NAMES[*]}"
    echo "Merged Friendly Names: ${MERGED_FRIENDLY_NAMES[*]}"
    echo "Merged HDD Paths: ${MERGED_HDD_PATHS[*]}"
    echo "Merged Device Types: ${MERGED_DEVICE_TYPES[*]}"
    echo "Merged Attributes Properties: ${MERGED_ATTRIBUTES_PROPERTY[*]}"
    echo "Merged Attributes Formats: ${MERGED_ATTRIBUTES_FORMAT[*]}"
fi

# Check if all merged arrays have the same length using length_hdd_paths as reference
length_sensor_state_types=$(echo "$MERGED_SENSOR_STATE_TYPES" | jq 'length')
length_sensor_names=$(echo "$MERGED_SENSOR_NAMES" | jq 'length')
length_friendly_names=$(echo "$MERGED_FRIENDLY_NAMES" | jq 'length')
length_device_types=$(echo "$MERGED_DEVICE_TYPES" | jq 'length')
length_hdd_paths=$(echo "$MERGED_HDD_PATHS" | jq 'length')
length_attributes_properties=$(echo "$MERGED_ATTRIBUTES_PROPERTY" | jq 'length')
length_attributes_formats=$(echo "$MERGED_ATTRIBUTES_FORMAT" | jq 'length')

if [ "$length_hdd_paths" -ne "$length_sensor_state_types" ] || \
   [ "$length_hdd_paths" -ne "$length_sensor_names" ] || \
   [ "$length_hdd_paths" -ne "$length_friendly_names" ] || \
   [ "$length_hdd_paths" -ne "$length_device_types" ] || \
   [ "$length_hdd_paths" -ne "$length_attributes_properties" ] || \
   [ "$length_hdd_paths" -ne "$length_attributes_formats" ]; then
    echo "[$(date)][ERROR] Merged arrays have different lengths:"
    echo "HDD Paths: $length_hdd_paths"
    echo "Sensor State Types: $length_sensor_state_types"
    echo "Sensor Names: $length_sensor_names"
    echo "Friendly Names: $length_friendly_names"
    echo "Device Types: $length_device_types"
    echo "Attributes Properties: $length_attributes_properties"
    echo "Attributes Formats: $length_attributes_formats"
    exit 1
fi

# Loop all HDD paths and get the SMART data
index=0
for HDD_PATH in $(echo "$MERGED_HDD_PATHS" | jq -r '.[]'); do

    printf "\n\n[$(date)][INFO] Processing disk at list index %s with path %s" "$index" "$HDD_PATH"

    SENSOR_STATE_TYPE=$(echo "$MERGED_SENSOR_STATE_TYPES" | jq -r --argjson idx "$index" '.[$idx]')
    SENSOR_NAME=$(echo "$MERGED_SENSOR_NAMES" | jq -r --argjson idx "$index" '.[$idx]')
    FRIENDLY_NAME=$(echo "$MERGED_FRIENDLY_NAMES" | jq -r --argjson idx "$index" '.[$idx]')
    DEVICE_TYPE=$(echo "$MERGED_DEVICE_TYPES" | jq -r --argjson idx "$index" '.[$idx]')
    ATTRIBUTES_FORMAT=$(echo "$MERGED_ATTRIBUTES_FORMAT" | jq -r --argjson idx "$index" '.[$idx]')
    ATTRIBUTES_PROPERTY=$(echo "$MERGED_ATTRIBUTES_PROPERTY" | jq -r --argjson idx "$index" '.[$idx]')

    SMARTCTL_OUTPUT=$($SMARTCTL_BINARY -a "$HDD_PATH" -d "$DEVICE_TYPE" --json)

    if [ "$DEBUG" = "true" ]; then
        echo "$SMARTCTL_OUTPUT" > "/share/hdd_tools/${OUTPUT_FILE}_$index"
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
    else
      curl -X POST -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
             -s \
             -o /dev/null \
             -H "Content-Type: application/json" \
             -d "$SENSOR_DATA" \
             -w "[$(date)][INFO] Sensor update response code: %{http_code}\n" \
             "http://supervisor/core/api/states/${SENSOR_NAME}"
    fi

    index=$((index + 1))
done