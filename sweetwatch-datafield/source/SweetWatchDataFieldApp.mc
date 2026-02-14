using Toybox.Application;
using Toybox.Application.Storage;
using Toybox.WatchUi;
using Toybox.Background;
using Toybox.System;
using Toybox.Lang;

(:background)
class SweetWatchDataFieldApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() {
        return [new SweetWatchDataField()];
    }

    // Called when background data is received
    function onBackgroundData(data) {
        if (data != null && data instanceof Lang.Dictionary) {
            var dict = data as Lang.Dictionary;
            var val = dict.get("value");
            if (val != null) {
                Storage.setValue("glucoseValue", val);
            }
            var tr = dict.get("trend");
            if (tr != null) {
                Storage.setValue("glucoseTrend", tr);
            }
            var ts = dict.get("timestamp");
            if (ts != null) {
                Storage.setValue("glucoseTimestamp", ts);
            }
        }
        WatchUi.requestUpdate();
    }

    // Return the service delegate for background execution
    function getServiceDelegate() {
        return [new BackgroundServiceDelegate()];
    }
}
