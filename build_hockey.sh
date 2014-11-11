#!/bin/bash
echo "Building GeoTappy Hockey"
ipa build -s GeoTappy -m Provisioning/GeoTappyAdHoc.mobileprovision -d build/HockeyApp/
echo "Done"
