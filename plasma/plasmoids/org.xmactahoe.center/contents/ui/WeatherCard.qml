/*
    Weather for the location XMacTahoe already knows (~/.config/xmactahoe/location, the one the
    automatic light/dark appearance uses), from Open-Meteo, which needs no account and no key.
    It stays quiet when there is no location or no network: the card simply does not show.
*/
import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Item {
    id: weather

    property string latitude: ""
    property string longitude: ""
    property bool ready: false
    property real temperature: 0
    property real low: 0
    property real high: 0
    property int code: -1

    property string status: i18n("Loading…")
    implicitHeight: row.implicitHeight

    // WMO weather codes, grouped the way the icon set names them
    function iconFor(c) {
        if (c === 0) return "weather-clear";
        if (c <= 2) return "weather-few-clouds";
        if (c === 3) return "weather-many-clouds";
        if (c <= 48) return "weather-fog";
        if (c <= 57) return "weather-showers-scattered";
        if (c <= 67) return "weather-showers";
        if (c <= 77) return "weather-snow";
        if (c <= 82) return "weather-showers";
        if (c <= 86) return "weather-snow";
        return "weather-storm";
    }

    function describe(c) {
        if (c === 0) return i18n("Clear");
        if (c <= 2) return i18n("Partly cloudy");
        if (c === 3) return i18n("Cloudy");
        if (c <= 48) return i18n("Fog");
        if (c <= 67) return i18n("Rain");
        if (c <= 77) return i18n("Snow");
        if (c <= 82) return i18n("Showers");
        return i18n("Storm");
    }

    function fetch() {
        if (!latitude || !longitude) {
            ready = false;
            status = i18n("No location set");
            return;
        }
        status = i18n("Loading…");
        const url = "https://api.open-meteo.com/v1/forecast?latitude=" + latitude + "&longitude=" + longitude
                  + "&current=temperature_2m,weather_code&daily=temperature_2m_max,temperature_2m_min"
                  + "&forecast_days=1&timezone=auto";
        const api = new XMLHttpRequest();
        api.onreadystatechange = function () {
            if (api.readyState !== XMLHttpRequest.DONE) {
                return;
            }
            if (api.status !== 200) {
                weather.ready = false;
                weather.status = i18n("Weather unavailable");
                return;
            }
            if (!api.responseText) {
                weather.ready = false;
                weather.status = i18n("Weather unavailable");
                return;
            }
            try {
                const data = JSON.parse(api.responseText);
                weather.temperature = Math.round(data.current.temperature_2m);
                weather.code = data.current.weather_code;
                weather.high = Math.round(data.daily.temperature_2m_max[0]);
                weather.low = Math.round(data.daily.temperature_2m_min[0]);
                weather.ready = true;
                weather.status = "";
            } catch (e) {
                weather.ready = false;
                weather.status = i18n("Weather unavailable");
            }
        };
        api.open("GET", url);
        api.send();
    }

    onLatitudeChanged: fetch()

    Component.onCompleted: fetch()

    Timer {
        interval: 30 * 60 * 1000
        running: true
        repeat: true
        onTriggered: weather.fetch()
    }

    Text {                      // while there is no reading yet, say why
        anchors.verticalCenter: parent.verticalCenter
        visible: !weather.ready
        text: weather.status
        color: Kirigami.Theme.textColor
        opacity: 0.6
        font: Kirigami.Theme.smallFont
    }

    RowLayout {
        id: row
        anchors.fill: parent
        visible: weather.ready
        spacing: Kirigami.Units.largeSpacing

        Kirigami.Icon {
            source: weather.iconFor(weather.code)
            Layout.preferredWidth: Kirigami.Units.iconSizes.large
            Layout.preferredHeight: Kirigami.Units.iconSizes.large
        }

        ColumnLayout {
            spacing: 0
            Layout.fillWidth: true

            Kirigami.Heading {
                level: 2
                text: weather.temperature + "°"
            }
            Text {
                text: weather.describe(weather.code)
                color: Kirigami.Theme.textColor
                opacity: 0.7
                font: Kirigami.Theme.smallFont
            }
        }

        Text {
            text: i18n("H:%1°  L:%2°", weather.high, weather.low)
            color: Kirigami.Theme.textColor
            opacity: 0.7
            font: Kirigami.Theme.smallFont
        }
    }
}
