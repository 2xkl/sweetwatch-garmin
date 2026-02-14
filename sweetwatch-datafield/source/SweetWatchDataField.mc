using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Application;
using Toybox.Application.Storage;
using Toybox.Background;
using Toybox.Time;

class SweetWatchDataField extends WatchUi.SimpleDataField {

    function initialize() {
        SimpleDataField.initialize();
        label = "Glucose";

        // Register for background events every 1 minute
        var lastTime = Background.getLastTemporalEventTime();
        if (lastTime == null) {
            lastTime = Time.now();
        }
        Background.registerForTemporalEvent(lastTime.add(new Time.Duration(60)));
    }

    // Called each update cycle
    function compute(info) {
        var value = Storage.getValue("glucoseValue");
        var trend = Storage.getValue("glucoseTrend");

        if (value == null) {
            return "---";
        }

        var trendArrow = getTrendArrow(trend);
        return value.format("%d") + " " + trendArrow;
    }

    function getTrendArrow(trend) {
        if (trend == null) {
            return "-";
        }
        if (trend == 1) {
            return "vv";
        } else if (trend == 2) {
            return "v";
        } else if (trend == 3) {
            return "-";
        } else if (trend == 4) {
            return "^";
        } else if (trend == 5) {
            return "^^";
        }
        return "-";
    }
}
