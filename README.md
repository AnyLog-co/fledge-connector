# Fledge

The following code is based on [fledge-http-north](https://github.com/fledge-iot/fledge-north-http), but instead of 
sending data between FLEDGE nodes, it allows sending data into AnyLog via _POST_ or _PUT_. 

* [Docker Hub](https://hub.docker.com/r/robraesemann/fledge)
* [Fledge Documentation](https://fledge-iot.readthedocs.io/en/latest/quick_start/index.html)

## Deployment & Configuring on the Fledge Side
The following deployment is using docker-compose packages created by [Rob Raesemann](https://hub.docker.com/u/robraesemann)

0. Install docker & docker-compose 

1. Clone lfedge-code
```shell
git clone https://github.com/AnyLog-co/lfedge-code 
```

2. Deploy Fledge + Fledge GUI
```shell
cd lfedge-code/fledge 
docker-compose up -d 
```

3. Attach to `fledge` container
```shell
docker exec -it --detach-keys=ctrl-d fledge bash
```

4. Clone lfedge code into the container  
```shell
git clone https://github.com/AnyLog-co/fledge-connector 
```

5. Copy anylog_plugin into _FLEDGE_
```shell
cp -r /app/fledge-connector/anylog_rest_conn/ /usr/local/fledge/python/fledge/plugins/north/
```

On the Fledge GUI - URL: `http://${YOUR_IP}/`


1. Begin sending data & view `readings` columns. - We'll be using the OpenWeatherMap asset as an example
```json
# Sample data being generated
{
 "asset": "OpenWeatherMap",
 "reading": {
   "city": "London",
   "wind_speed": 5.14,
   "clouds": 100,
   "temperature": 289.21,
   "pressure": 1009,
   "humidity": 74,
   "visibility": 10000
 },
 "timestamp": "2022-06-25 19:42:09.916403"
}
```

2. Under the _North_ section add `anylog_rest_conn` 
   * **URL** - The IP:Port address to send data to
   * **REST Topic Name** - REST topic to send data to
   * **Asset List**: - Comma separated list of assets to send using this AnyLog connection. If no assets set, then data 
   from all assets will be sent
   * **Database Name** - logical database to store data in AnyLog
![North Plugin Configs](imgs/north_plugin.png)

At this point data will send into AnyLog via REST. 


## Configuring AnyLog REST Client
When sending data via _PUT_, all that's required is for AnyLog to accept REST requests - which is done by default. 

When sending data via _POST_, an MQTT client accepting the requests should be running. 

[fledge.al](fledge.al) provides an example for receiving data from the [random](https://github.com/fledge-iot/fledge-south-random) 
data generator FLEDGE southbound plugin, and the [OpenWeatherMap](https://github.com/fledge-iot/fledge-south-openweathermap) 
southbound plugin.

In AnyLog / EdgeLake, the script [fledge.al](fledge.al) can be found under $EDGELAKE_PATH/deployment-scripts/demo-scripts/fledge.al
```anylog
process $EDGELAKE_PATH/deployment-scripts/demo-scripts/fledge.al
```
