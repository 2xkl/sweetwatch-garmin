using Toybox.Background;
using Toybox.Communications;
using Toybox.System;
using Toybox.Time;
using Toybox.Lang;

(:background)
class BackgroundServiceDelegate extends System.ServiceDelegate {

    function initialize() {
        ServiceDelegate.initialize();
    }

    // Called when a temporal event fires
    function onTemporalEvent() {
        fetchGlucose();
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
        var result = {};

        if (responseCode == 200 && data != null && data instanceof Lang.Dictionary) {
            var dict = data as Lang.Dictionary;
            var val = dict.get("value");
            if (val != null) {
                if (val instanceof Lang.Number) {
                    result.put("value", val);
                } else if (val instanceof Lang.Float) {
                    result.put("value", val.toNumber());
                }
            }
            var tr = dict.get("trend");
            if (tr != null) {
                result.put("trend", tr);
            }
            result.put("timestamp", Time.now().value());
        }

        // Send data back to the main app
        Background.exit(result);
    }
}
