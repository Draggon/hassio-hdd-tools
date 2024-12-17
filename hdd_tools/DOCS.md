<div align="center">
<h1>HDD Tools Hass.io Add-on</h1>
</div>

### Configuration parameters

| Parameter                        | Description                                                                                                                                                    |
|----------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| sensor_state_type                | Type of the sensor which is exposed to home-assistant. Can be `smart_state` or `temperature`.                                                                  |
| additional_sensor_state_types    | Type of the sensor for additional drives. See below for details.                                                                                               |
| sensor_name                      | Name for the sensor which is exposed to home-assistant. For `smart_state` it must begin with `binary_sensor.`, for `temperature` it must begin with `sensor.`. |
| additional_sensor_names          | Name for the sensor for additional drives. See below for details.                                                                                              |
| friendly_name                    | Friendly name for the sensor which is exposed to home-assistant                                                                                                |
| additional_friendly_names        | Friendly name for the sensor for additional drives. See below for details.                                                                                     |
| hdd_path                         | Path to drive to monitor                                                                                                                                       |
| additional_hdd_paths             | Path to additional drives. See below for details.                                                                                                              |
| device_type                      | Type of block device which `smartctl` will try to use for communication. Default `auto`. Check https://www.smartmontools.org/wiki/USB                          |
| additional_device_types          | Type of block device for additional drives. See below for details.                                                                                             |
| attributes_format                | One of `object` or `list`. See more details [here](#attributes).                                                                                               |
| additional_attributes_formats    | Format for additional drives. See below for details.                                                                                                           |
| attributes_property              | Attribute you want to merge with the attributes in your sensor. Check the `output_file` for the available properties.                                          |
| additional_attributes_properties | Attribute for additional drives. See below for details.                                                                                                        |
| check_period                     | Interval in minutes / how often to read temperature                                                                                                            |
| database_update                  | Flag to enable the update of the smartmontools drives database                                                                                                 |
| database_update_period           | Interval in hours / how often the drives database is updated                                                                                                   |
| performance_check                | Flag to enable or disable the execution of performance check at startup                                                                                        |
| debug                            | Flag to enable or disable debugging. Activate this if you want to debug which property from the JSON output of `smartctl` you want to be merged to the sensor. |
| output_file                      | Log file                                                                                                                                                       |

### Attributes

`smartctl` returns multiple formats of the attributes, depending on what setup is used.

This addon supports either a `list` (table) of attributes or an `object` of attributes:


#### Attributes as an object

This is returned for a NVMe setup for example: 

```json
{
  "nvme_smart_health_information_log": {
    "critical_warning": 0,
    "temperature": 36,
    "available_spare": 100,
    "available_spare_threshold": 5,
    "percentage_used": 0,
    "data_units_read": 519679,
    "data_units_written": 326973,
    "host_reads": 8780844,
    "host_writes": 7257199,
    "controller_busy_time": 472,
    "power_cycles": 33,
    "power_on_hours": 153,
    "unsafe_shutdowns": 13,
    "media_errors": 0,
    "num_err_log_entries": 0,
    "warning_temp_time": 0,
    "critical_comp_time": 0
  }
}
```

The addon configuration for this setup would look like:

```yaml
attributes_property: nvme_smart_health_information_log
attributes_format: object
```

#### Attributes as a list (table)

This is returned for a SATA setup for example:

```json
{
  "ata_smart_attributes": {
    "revision": 1,
    "table": [
      {
        "id": 1,
        "name": "Raw_Read_Error_Rate",
        "value": 100,
        "worst": 100,
        "thresh": 50,
        "when_failed": "",
        "flags": {
          "value": 47,
          "string": "POSR-K ",
          "prefailure": true,
          "updated_online": true,
          "performance": true,
          "error_rate": true,
          "event_count": false,
          "auto_keep": true
        },
        "raw": {
          "value": 0,
          "string": "0"
        }
      },
      {
        "id": 5,
        "name": "Reallocate_NAND_Blk_Cnt",
        "value": 100,
        "worst": 100,
        "thresh": 10,
        "when_failed": "",
        "flags": {
          "value": 50,
          "string": "-O--CK ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": true
        },
        "raw": {
          "value": 0,
          "string": "0"
        }
      },
      {
        "id": 9,
        "name": "Power_On_Hours",
        "value": 100,
        "worst": 100,
        "thresh": 50,
        "when_failed": "",
        "flags": {
          "value": 50,
          "string": "-O--CK ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": true
        },
        "raw": {
          "value": 744,
          "string": "744"
        }
      },
      {
        "id": 12,
        "name": "Power_Cycle_Count",
        "value": 100,
        "worst": 100,
        "thresh": 50,
        "when_failed": "",
        "flags": {
          "value": 50,
          "string": "-O--CK ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": true
        },
        "raw": {
          "value": 35,
          "string": "35"
        }
      },
      {
        "id": 171,
        "name": "Program_Fail_Count",
        "value": 100,
        "worst": 100,
        "thresh": 50,
        "when_failed": "",
        "flags": {
          "value": 50,
          "string": "-O--CK ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": true
        },
        "raw": {
          "value": 0,
          "string": "0"
        }
      },
      {
        "id": 172,
        "name": "Erase_Fail_Count",
        "value": 100,
        "worst": 100,
        "thresh": 50,
        "when_failed": "",
        "flags": {
          "value": 50,
          "string": "-O--CK ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": true
        },
        "raw": {
          "value": 0,
          "string": "0"
        }
      },
      {
        "id": 173,
        "name": "Ave_Block-Erase_Count",
        "value": 100,
        "worst": 100,
        "thresh": 50,
        "when_failed": "",
        "flags": {
          "value": 50,
          "string": "-O--CK ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": true
        },
        "raw": {
          "value": 9,
          "string": "9"
        }
      },
      {
        "id": 174,
        "name": "Unexpect_Power_Loss_Ct",
        "value": 100,
        "worst": 100,
        "thresh": 50,
        "when_failed": "",
        "flags": {
          "value": 50,
          "string": "-O--CK ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": true
        },
        "raw": {
          "value": 24,
          "string": "24"
        }
      },
      {
        "id": 180,
        "name": "Unused_Reserve_NAND_Blk",
        "value": 100,
        "worst": 100,
        "thresh": 50,
        "when_failed": "",
        "flags": {
          "value": 50,
          "string": "-O--CK ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": true
        },
        "raw": {
          "value": 100,
          "string": "100"
        }
      },
      {
        "id": 183,
        "name": "SATA_Interfac_Downshift",
        "value": 100,
        "worst": 100,
        "thresh": 50,
        "when_failed": "",
        "flags": {
          "value": 50,
          "string": "-O--CK ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": true
        },
        "raw": {
          "value": 0,
          "string": "0"
        }
      },
      {
        "id": 184,
        "name": "Error_Correction_Count",
        "value": 100,
        "worst": 100,
        "thresh": 50,
        "when_failed": "",
        "flags": {
          "value": 50,
          "string": "-O--CK ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": true
        },
        "raw": {
          "value": 0,
          "string": "0"
        }
      },
      {
        "id": 187,
        "name": "Reported_Uncorrect",
        "value": 100,
        "worst": 100,
        "thresh": 50,
        "when_failed": "",
        "flags": {
          "value": 50,
          "string": "-O--CK ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": true
        },
        "raw": {
          "value": 0,
          "string": "0"
        }
      },
      {
        "id": 194,
        "name": "Temperature_Celsius",
        "value": 64,
        "worst": 48,
        "thresh": 50,
        "when_failed": "past",
        "flags": {
          "value": 34,
          "string": "-O---K ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": false,
          "auto_keep": true
        },
        "raw": {
          "value": 223340199972,
          "string": "36 (Min/Max 29/52)"
        }
      },
      {
        "id": 196,
        "name": "Reallocated_Event_Count",
        "value": 100,
        "worst": 100,
        "thresh": 50,
        "when_failed": "",
        "flags": {
          "value": 50,
          "string": "-O--CK ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": true
        },
        "raw": {
          "value": 0,
          "string": "0"
        }
      },
      {
        "id": 197,
        "name": "Current_Pending_Sector",
        "value": 100,
        "worst": 100,
        "thresh": 50,
        "when_failed": "",
        "flags": {
          "value": 50,
          "string": "-O--CK ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": true
        },
        "raw": {
          "value": 0,
          "string": "0"
        }
      },
      {
        "id": 198,
        "name": "Offline_Uncorrectable",
        "value": 100,
        "worst": 100,
        "thresh": 50,
        "when_failed": "",
        "flags": {
          "value": 48,
          "string": "----CK ",
          "prefailure": false,
          "updated_online": false,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": true
        },
        "raw": {
          "value": 0,
          "string": "0"
        }
      },
      {
        "id": 199,
        "name": "UDMA_CRC_Error_Count",
        "value": 100,
        "worst": 100,
        "thresh": 50,
        "when_failed": "",
        "flags": {
          "value": 50,
          "string": "-O--CK ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": true
        },
        "raw": {
          "value": 29,
          "string": "29"
        }
      },
      {
        "id": 202,
        "name": "Percent_Lifetime_Remain",
        "value": 100,
        "worst": 100,
        "thresh": 1,
        "when_failed": "",
        "flags": {
          "value": 48,
          "string": "----CK ",
          "prefailure": false,
          "updated_online": false,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": true
        },
        "raw": {
          "value": 100,
          "string": "100"
        }
      },
      {
        "id": 206,
        "name": "Write_Error_Rate",
        "value": 100,
        "worst": 100,
        "thresh": 50,
        "when_failed": "",
        "flags": {
          "value": 46,
          "string": "-OSR-K ",
          "prefailure": false,
          "updated_online": true,
          "performance": true,
          "error_rate": true,
          "event_count": false,
          "auto_keep": true
        },
        "raw": {
          "value": 0,
          "string": "0"
        }
      },
      {
        "id": 210,
        "name": "Success_RAIN_Recov_Cnt",
        "value": 100,
        "worst": 100,
        "thresh": 50,
        "when_failed": "",
        "flags": {
          "value": 50,
          "string": "-O--CK ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": true
        },
        "raw": {
          "value": 0,
          "string": "0"
        }
      },
      {
        "id": 246,
        "name": "Total_LBAs_Written",
        "value": 100,
        "worst": 100,
        "thresh": 50,
        "when_failed": "",
        "flags": {
          "value": 50,
          "string": "-O--CK ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": true
        },
        "raw": {
          "value": 619033175,
          "string": "619033175"
        }
      },
      {
        "id": 247,
        "name": "Host_Program_Page_Count",
        "value": 100,
        "worst": 100,
        "thresh": 50,
        "when_failed": "",
        "flags": {
          "value": 50,
          "string": "-O--CK ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": true
        },
        "raw": {
          "value": 19344786,
          "string": "19344786"
        }
      },
      {
        "id": 248,
        "name": "FTL_Program_Page_Count",
        "value": 100,
        "worst": 100,
        "thresh": 50,
        "when_failed": "",
        "flags": {
          "value": 50,
          "string": "-O--CK ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": true
        },
        "raw": {
          "value": 16994048,
          "string": "16994048"
        }
      }
    ]
  }
}
```

The addon configuration for this setup would look like:

```yaml
attributes_property: ata_smart_attributes.table
attributes_format: list
```

### Adding additional drives
To keep backward compatibility, the addon supports multiple drives via the `additional_X`  configuration parameters. 
This ensures that the addon can be used with multiple drives without breaking existing setups with a single drive. 

To add additional drives, you need to add the following configuration parameters, the order of the values inside each list important. 
Each value in the list corresponds to the same index in the other lists (e.g. the first sensor_name in the additional_sensor_names list will map to the first path in the additional_hdd_paths list. The second name will map to the second path and so).

```yaml
additional_hdd_paths:
    - /dev/sdb
    - ...
additional_sensor_state_types:
    - smart_state
    - ...
additional_sensor_names:
    - binary_sensor.hdd_temp_sdb
    - ...
additional_friendly_names:
    - HDD Temp SDB
    - ...
additional_device_types:
    - auto
    - ...
additional_attributes_formats:
    - list
    - ...
additional_attributes_properties:
    - ata_smart_attributes.table
    - ...
```

Filling these values using UI can be done, but it's quite error-prone since it does not seem to accept duplicate list entries which are likely required here. Therefore, it is recommended to use the configuration file for this.
The path of the various disks can be copied from the Supervisor -> System -> Hardware page, using a tool like `lsblk` or any other method you prefer. 

Technically it is irrelevant if you use the `/dev/disk/by-id/` or `/dev/sdX` paths, the code will handle both but the UI seems to enforce `by-id` paths. These paths are anyway more stable (as the `dev/sdX` pass can be re-assigned at boot or if the disks have been physically swapped).

A full example configuration file with two drives would look like this:

```yaml
sensor_state_type: temperature
additional_sensor_state_types:
  - temperature
  - temperature
sensor_name: sensor.boot_disk
additional_sensor_names:
  - sensor.backup_disk_1
  - sensor.backup_disk_2
friendly_name: Boot NVME
additional_friendly_names:
  - Backup Disk 1
  - Backup Disk 2
hdd_path: /dev/disk/by-id/nvme-ABC-XXXXXXXX
additional_hdd_paths:
  - /dev/disk/by-id/ata-ABC-YYYYYYYY
  - /dev/disk/by-id/ata-AAB-ZZZZZZZZ
device_type: auto
additional_device_types:
  - auto
  - auto
attributes_format: object
additional_attributes_formats:
    - list
    - list
attributes_property: nvme_smart_health_information_log
additional_attributes_properties:
    - ata_smart_attributes.table
    - ata_smart_attributes.table
check_period: 720
database_update: true
database_update_period: 168
performance_check: false
debug: true
output_file: temp.log
```