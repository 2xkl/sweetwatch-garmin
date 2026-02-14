using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Communications;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Timer;
using Toybox.Application;

var glucoseValue = "--";
var trend = "";

(:background)
class SweetWatchView extends WatchUi.View {

    var _timer;

    function initialize() {
        View.initialize();
    }

    function onLayout(dc) {
    }

    function onShow() {
        fetchGlucose();
        _timer = new Timer.Timer();
        _timer.start(method(:onTimer), 60000, true);
    }

    function onHide() {
        if (_timer != null) {
            _timer.stop();
            _timer = null;
        }
    }

    function onTimer() as Void {
        fetchGlucose();
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();

        var clockTime = System.getClockTime();
        var hours = clockTime.hour.format("%02d");
        var minutes = clockTime.min.format("%02d");
        var timeString = hours + ":" + minutes;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            width / 2,
            height / 2 - 50,
            Graphics.FONT_NUMBER_THAI_HOT,
            timeString,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );

        var glucoseColor = getGlucoseColor();
        dc.setColor(glucoseColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            width / 2,
            height / 2 + 30,
            Graphics.FONT_NUMBER_MILD,
            glucoseValue,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );

        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            width / 2,
            height / 2 + 80,
            Graphics.FONT_MEDIUM,
            trend,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );

        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dateString = today.day.format("%02d") + " " + today.month;
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            width / 2,
            height - 30,
            Graphics.FONT_TINY,
            dateString,
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }

    function convertTrendArrow(arrow) {
        if (arrow.equals("↑") || arrow.equals("⬆")) {
            return "^^";
        } else if (arrow.equals("↗")) {
            return "^";
        } else if (arrow.equals("→") || arrow.equals("➡")) {
            return "-";
        } else if (arrow.equals("↘")) {
            return "v";
        } else if (arrow.equals("↓") || arrow.equals("⬇")) {
            return "vv";
        }
        return "-";
    }

    function getGlucoseColor() {
        if (glucoseValue.equals("--") || glucoseValue.equals("ERR")) {
            return Graphics.COLOR_WHITE;
        }
        var value = glucoseValue.toNumber();
        if (value == null) {
            return Graphics.COLOR_WHITE;
        }
        if (value < 70) {
            return Graphics.COLOR_RED;
        } else if (value <= 180) {
            return Graphics.COLOR_GREEN;
        } else if (value <= 250) {
            return Graphics.COLOR_YELLOW;
        } else {
            return Graphics.COLOR_RED;
        }
    }

    function fetchGlucose() as Void {
        Communications.makeWebRequest(
            "https://test.sweetwatch.app/api/glucose/current",
            null,
            {
                :method => Communications.HTTP_REQUEST_METHOD_GET,
                :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
            },
            method(:onReceive)
        );
    }

    function onReceive(responseCode as Lang.Number, data as Lang.Dictionary or Lang.String or Null) as Void {
        if (responseCode == 200 && data != null) {
            var val = data["value"];
            if (val != null) {
                glucoseValue = val.toNumber().toString();
            }
            var tr = data["trend_arrow"];
            if (tr != null) {
                trend = convertTrendArrow(tr);
            }
        } else {
            glucoseValue = "---";
            trend = "E" + responseCode.toString();
        }
        WatchUi.requestUpdate();
    }
}
