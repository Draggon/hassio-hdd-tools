<div align="center">
<h1>HDD Tools Hass.io Add-on</h1>
</div>

## General

This add-on provides information about HDD Temperature from S.M.A.R.T using smartmontools.
- Temperature is visible in Home-Assistant via sensor `sensor.hdd_temp`.
- SMART attributes are mapped to `sensor.hdd_temp` sensor attributes.
- Optionally, at start, add-on runs PiBenchmarks https://jamesachambers.com/raspberry-pi-storage-benchmarks-2019-benchmarking-script/ and stores output in _/share/hdd_tools/performance.log_

You can get more information about the addon [here](hdd_tools/README.md) and all the details about it's options and parameters [here](hdd_tools/DOCS.md).
## Installation

Add the repository URL under **Supervisor (Hass.io) → Add-on Store** in your Home Assistant front-end:

    https://github.com/Draggon/hassio-hdd-tools

## Configuration

Configure the add-on via your Home Assistant front-end under **Supervisor (Hass.io) → Dashboard → HDD Tools**.
