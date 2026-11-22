#!/bin/bash
set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="$DIR/build"
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

echo "==> 1. Checking App Icon..."
ICNS_FILE="$DIR/AppIcon.icns"
if [ ! -f "$ICNS_FILE" ]; then
    echo "Error: AppIcon.icns not found in $DIR"
    exit 1
fi

echo "==> 2. Building 'Switch Mouse to Mac.app'..."
APP_BUNDLE="$DIR/Switch Mouse to Mac.app"
rm -rf "$APP_BUNDLE"
mkdir -p "$APP_BUNDLE/Contents/MacOS"
mkdir -p "$APP_BUNDLE/Contents/Resources"

cp "$ICNS_FILE" "$APP_BUNDLE/Contents/Resources/AppIcon.icns"

swiftc "$DIR/App.swift" -o "$APP_BUNDLE/Contents/MacOS/SwitchMouseApp" -framework Cocoa -framework IOBluetooth

cat << 'EOF' > "$APP_BUNDLE/Contents/Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>SwitchMouseApp</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundleIdentifier</key>
    <string>com.btmouseswitcher.mac</string>
    <key>CFBundleName</key>
    <string>Switch Mouse to Mac</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>NSBluetoothAlwaysUsageDescription</key>
    <string>Bluetooth Mouse Switcher needs Bluetooth access to discover, unpair, and connect your Bluetooth mouse.</string>
    <key>NSBluetoothPeripheralUsageDescription</key>
    <string>Bluetooth Mouse Switcher needs Bluetooth access to discover, unpair, and connect your Bluetooth mouse.</string>
</dict>
</plist>
EOF

rm -rf "$BUILD_DIR"

echo "==> Done! Successfully created:"
echo "    - $APP_BUNDLE"
