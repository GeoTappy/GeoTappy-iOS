#!/bin/bash
echo "Building GeoTappy Hockey"
ipa build -s GeoTappy -m Provisioning/GeoTappyAdHoc.mobileprovision -d build/HockeyApp/
osascript -e 'display notification "Build for HockeyApp completed." with title "GeoTappy" sound name "Glass"'
echo "Done"
