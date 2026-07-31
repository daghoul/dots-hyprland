pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick
import QtPositioning
import qs.services
import qs.modules.common

Singleton {
    id: root
    // 10 minute
    readonly property int fetchInterval: Config.options.weather.fetchInterval * 60 * 1000
    readonly property string city: Config.options.weather.city
    readonly property bool useUSCS: Config.options.weather.useUSCS
    readonly property bool gpsEnable: Config.options.weather.enableGPS
    readonly property bool weatherEnable: Config.options.weather.enable && 
        (Config.options.bar.weather.enable || Config.options.background.widgets.weather.enable)

    // This will prevent change handlers to call getData
    // immediately when reloading quickshell after
    // root.weatherEnable was true. Preventing excessive API calls.
    property bool ready: false
    Component.onCompleted: { 
        ready = true;

        // Initial startup: if weather is enabled, start the service
        if (root.weatherEnable) {

            if (root.gpsEnable) {
                // GPS enabled: invalidate location, start GPS, wait for fix
                root.location.valid = false;
                console.info("[WeatherService] Initial startup: GPS enabled. Starting GPS.");
                schedule(gpsDebounce, 1000);
                // Note: fetch will happen when a valid position is received
            } else {
                // GPS disabled: fetch city weather immediately
                console.info("[WeatherService] Initial startup: GPS disabled. Fetching city weather.");
                root.getData();
            }

        } else {
            console.info("[WeatherService] Initial startup: Weather service disabled.");
        }
    }

    // To prevent curl-ing wttr.in too much
    // When a user tried to change city for example, 
    // the timer starts and waits for a period of user input inactivity.
    // If the user keeps typing (e.g. changing a letter), timer resets.
    // Only after the user stops typing does it trigger getData().
    // This also applies to toggles and gps.
    Timer {
        id: fetchDebounce
        repeat: false
        onTriggered: {
            root.getData();
        }
    }

    Timer {
        id: gpsDebounce
        repeat: false
        onTriggered: {
            if (root.gpsEnable) {
                positionSource.start();
            } else {
                positionSource.stop();
            }
        }
    }

    function schedule(timer, delay) {
        timer.stop();
        timer.interval = Math.max(1, delay);
        timer.start();
    }

    onUseUSCSChanged: {
        if (!root.ready || !root.weatherEnable) return;
        console.info("[WeatherService] Scheduling weather refresh (Fahrenheit: %1)".arg(useUSCS));
        schedule(fetchDebounce, 1000);
    }
    onCityChanged: {
        if (!root.ready || !root.weatherEnable) return;
        console.info("[WeatherService] Scheduling weather refresh (City: %1)".arg(city));
        schedule(fetchDebounce, 3000);
    }

    onGpsEnableChanged: {
        if (!root.ready) return;

        if (!root.weatherEnable) {
            if (positionSource.active) positionSource.stop();
            return;
        }

        if (root.gpsEnable) {
            // Enabling GPS: invalidate location and start GPS
            root.location.valid = false;
            console.info("[WeatherService] Scheduling GPS start.");
            schedule(gpsDebounce, 1000);
        } else {
            // Disabling GPS: stop it and fetch city weather NOW
            if (positionSource.active) positionSource.stop();
            root.location.valid = false;
            console.info("[WeatherService] GPS disabled. Fetching city weather.");
            schedule(fetchDebounce, 1000);
        }
    }

    onWeatherEnableChanged: {
        if (!root.ready) return;

        if (!root.weatherEnable) {
            fetchDebounce.stop();
            gpsDebounce.stop();
            if (positionSource.active) positionSource.stop();
            return;
        }
        
        if (root.gpsEnable) {
            console.info("[WeatherService] GPS enabled. Starting GPS if not already.");
            if (!positionSource.active) {
                schedule(gpsDebounce, 1000);
            }
            // If we already have a valid location, fetch GPS weather right away.
            if (root.location.valid) {
                console.info("[WeatherService] Using cached GPS location. Fetching weather.");
                root.getData();
            } else {
                console.info("[WeatherService] Waiting for GPS fix.");
            }
        } else {
            root.location.valid = false;
            console.info("[WeatherService] GPS disabled. Fetching city weather.");
            schedule(fetchDebounce, 1000);
        }
    }

    property var location: ({
        valid: false,
        lat: 0,
        long: 0
    })

    property var data: ({
        uv: 0,
        humidity: 0,
        sunrise: 0,
        sunset: 0,
        windDir: 0,
        wCode: 0,
        city: 0,
        wind: 0,
        precip: 0,
        visib: 0,
        press: 0,
        temp: 0,
        tempFeelsLike: 0,
        lastRefresh: 0,
    })

    function refineData(data) {
        let temp = {};
        temp.uv = data?.current?.uvIndex || 0;
        temp.humidity = (data?.current?.humidity || 0) + "%";
        temp.sunrise = data?.astronomy?.sunrise || "0.0";
        temp.sunset = data?.astronomy?.sunset || "0.0";
        temp.windDir = data?.current?.winddir16Point || "N";
        temp.wCode = data?.current?.weatherCode || "113";
        temp.city = data?.location?.areaName[0]?.value || "City";
        temp.temp = "";
        temp.tempFeelsLike = "";
        if (root.useUSCS) {
            temp.wind = (data?.current?.windspeedMiles || 0) + " mph";
            temp.precip = (data?.current?.precipInches || 0) + " in";
            temp.visib = (data?.current?.visibilityMiles || 0) + " m";
            temp.press = (data?.current?.pressureInches || 0) + " psi";
            temp.temp += (data?.current?.temp_F || 0);
            temp.tempFeelsLike += (data?.current?.FeelsLikeF || 0);
            temp.temp += "°F";
            temp.tempFeelsLike += "°F";
        } else {
            temp.wind = (data?.current?.windspeedKmph || 0) + " km/h";
            temp.precip = (data?.current?.precipMM || 0) + " mm";
            temp.visib = (data?.current?.visibility || 0) + " km";
            temp.press = (data?.current?.pressure || 0) + " hPa";
            temp.temp += (data?.current?.temp_C || 0);
            temp.tempFeelsLike += (data?.current?.FeelsLikeC || 0);
            temp.temp += "°C";
            temp.tempFeelsLike += "°C";
        }
        temp.lastRefresh = DateTime.time + " • " + DateTime.date;
        root.data = temp;
    }

    function getData() {
        console.log("[WeatherService] Fetching weather data...")
        let command = "curl -s wttr.in";

        if (root.gpsEnable && root.location.valid) {
            command += `/${root.location.lat},${root.location.long}`;
        } else {
            command += `/${formatCityName(root.city)}`;
        }

        // format as json
        command += "?format=j1";
        command += " | ";
        // only take the current weather, location, asytronmy data
        command += "jq '{current: .current_condition[0], location: .nearest_area[0], astronomy: .weather[0].astronomy[0]}'";
        fetcher.command[2] = command;
        fetcher.running = true;
    }

    function formatCityName(cityName) {
        return cityName.trim().split(/\s+/).join('+');
    }

    Process {
        id: fetcher
        command: ["bash", "-c", ""]
        stdout: StdioCollector {
            onStreamFinished: {
                if (text.length === 0)
                    return;
                try {
                    const parsedData = JSON.parse(text);
                    root.refineData(parsedData);
                    // console.info(`[ data: ${JSON.stringify(parsedData)}`);
                } catch (e) {
                    console.error(`[WeatherService] ${e.message}`);
                }
            }
        }
        stderr: StdioCollector { // <-- ADD THIS
            onStreamFinished: {
                if (text.length > 0) {
                    console.error(`[WeatherService] stderr: ${text}`);
                }
            }
        }
    }

    PositionSource {
        id: positionSource
        updateInterval: root.fetchInterval

        onPositionChanged: {
            // update the location if the given location is valid
            // if it fails getting the location, use the last valid location
            if (position.latitudeValid && position.longitudeValid) {
                root.location.lat = position.coordinate.latitude;
                root.location.long = position.coordinate.longitude;
                root.location.valid = true;
                console.info(`📍 Location: ${position.coordinate.latitude}, ${position.coordinate.longitude}`);
                schedule(fetchDebounce, 1000);
                // if can't get initialized with valid location deactivate the GPS
            } else {
                console.error("[WeatherService] Failed to get the GPS location.");
            }
        }

        onValidityChanged: {
            if (!positionSource.valid) {
                positionSource.stop();
                root.location.valid = false;
                Quickshell.execDetached(["notify-send", Translation.tr("Weather Service"), Translation.tr("Cannot find a GPS service. Using the fallback method instead."), "-a", "Shell"]);
                console.error("[WeatherService] Could not aquire a valid backend plugin.");
            }
        }
    }

    Timer {
        running: root.weatherEnable && !root.gpsEnable
        repeat: true
        interval: root.fetchInterval
        onTriggered: {
            fetchDebounce.stop();
            console.info("[WeatherService] Refreshing weather data due to config changes (Enable: %1)".arg(root.weatherEnable));
            root.getData();
        }
    }
}
