#-----------------------------------------------------------------------------------------------------------------------
# The following demonstrate receiving data from 2 different assets coming from FLEDGE, each with its own topic.
# For demonstration, FLEDGE is running Random data generator (topic: fledge-random) and OpenWeather data
# (topic: fledge-weather).
# :documents:
#   - Generic MQTT script: !local_scripts/deployment_scripts/mqtt.al
#   - Documentation: https://github.com/AnyLog-co/documentation/blob/master/mapping%20data%20to%20tables.md
#   - Deploying FLEDGE: https://github.com/AnyLog-co/lfedge-code/tree/main/fledges
#   - AnyLog Northbound Plugin on FLEDGE: https://github.com/AnyLog-co/lfedge-code/tree/main/fledge
#-----------------------------------------------------------------------------------------------------------------------

:set-params:
if not !mqtt_log then set mqtt_log = false
if not !default_dbms then default_dbms=test

:mqtt-call:
on error goto mqtt-error
<run msg client where broker=rest and user-agent=anylog and log=!mqtt_log and topic=(
    name=fledge-random and
    dbms=!default_dbms and
    table="bring [asset]" and
    column.timestamp.timestamp="bring [timestamp]" and
    column.random=(type=float and value="bring [readings][random]" and optional=true)
) and topic=(
    name=fledge-weather and
    dbms=!default_dbms and
    table="bring [asset]" and
    column.timestamp.timestamp="bring [timestamp]" and
    column.city=(type=str and value="bring [readings][city]" and optional=true) and
    column.clouds=(type=float and value="bring [readings][clouds]" and optional=true) and
    column.humidity=(type=float and value="bring [readings][humidity]" and optional=true) and
    column.pressure=(type=float and value="bring [readings][pressure]" and optional=true) and
    column.temperature=(type=float and value="bring [readings][temperature]" and optional=true) and
    column.visibility=(type=float and value="bring [readings][visibility]" and optional=true) and
    column.wind_speed=(type=float and value="bring [readings][wind_speed]" and optional=true)
)>

:end-script:
get msg client
end script

:mqtt-error:
echo "Failed to deploy MQTT process"
goto end-script
