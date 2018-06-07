#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DESTINATION_BOOK="$DIR/Intro to microbit.playgroundbook"
DESTINATION_RESOURCES="$DESTINATION_BOOK/Contents/PrivateResources"
TEMPLATE_BOOK="$DIR/micro-bit template.playgroundbook"
SOURCE_MATERIALS="$DIR/Intro to microbit"

rm -fR "$DESTINATION_BOOK"

mkdir "$DESTINATION_BOOK"

cp -R "$TEMPLATE_BOOK/Contents" "$DESTINATION_BOOK"
cp -Rf "$SOURCE_MATERIALS/Contents" "$DESTINATION_BOOK"

ibtool --compile "$DESTINATION_RESOURCES/LiveView.storyboardc" "$DESTINATION_RESOURCES/LiveView.storyboard"
rm -f "$DESTINATION_RESOURCES/LiveView.storyboard"

xcrun actool "$DESTINATION_RESOURCES/Assets.xcassets" --compile "$DESTINATION_RESOURCES" --platform iphoneos --minimum-deployment-target 8.0
rm -Rf "$DESTINATION_RESOURCES/Assets.xcassets"
