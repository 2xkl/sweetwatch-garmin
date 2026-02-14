# SweetWatch Garmin

Garmin Connect IQ apps for glucose monitoring with SweetWatch.

## Projects

### sweetwatch-widget
Widget displaying glucose on the watch main screen.
- Shows: time, glucose, trend, date
- Fetches data every 60 seconds

### sweetwatch-datafield
Data field for sports activities (running, cycling, etc.)
- Shows: glucose + trend
- Background Service fetches data every 60 seconds

## Requirements

- Garmin Connect IQ SDK 3.1.0+
- Developer key (`developer_key.der`)

## Building

```bash
# Widget
monkeyc -f sweetwatch-widget/monkey.jungle -o sweetwatch-widget.prg -d fenix6pro -y /path/to/developer_key.der -r

# Data Field
monkeyc -f sweetwatch-datafield/monkey.jungle -o sweetwatch-datafield.prg -d fenix6pro -y /path/to/developer_key.der -r
```

## Installation

### Method 1: USB (fastest)

1. Connect watch via USB
2. Watch mounts as a drive (e.g., `/media/GARMIN` or `D:\`)
3. Copy `.prg` files to:
   ```
   GARMIN/Apps/sweetwatch-widget.prg
   GARMIN/Apps/sweetwatch-datafield.prg
   ```
4. Safely eject the watch
5. Apps will load automatically

### Method 2: Garmin Express

1. Build `.iq` package:
   ```bash
   monkeyc -f monkey.jungle -o sweetwatch-widget.iq -e -y /path/to/developer_key.der
   ```
2. Open Garmin Express
3. Select watch > IQ Apps > Sideload
4. Select the `.iq` file

## Configuration

Apps connect to:
```
https://test.sweetwatch.app/api/glucose/current
```

To change the URL, edit:
- `sweetwatch-widget/source/SweetWatchView.mc`
- `sweetwatch-datafield/source/BackgroundServiceDelegate.mc`

## Usage

### Widget
1. On watch: hold UP > Widgets
2. Add "SweetWatch" to widget list
3. Swipe left/right on watch face to see widget

### Data Field
1. On watch: hold UP > Activities > [select activity] > Settings > Data Screens
2. Add screen or edit existing
3. Select field > Connect IQ > SweetWatch DF

## Supported Devices

Currently: Fenix 6 Pro

To add other devices, edit `<iq:products>` in `manifest.xml`.

## License

MIT
