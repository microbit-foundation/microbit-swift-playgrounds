//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "GesturesAPINarative")
 
 This page demonstrates the _gestures_ API for accelerometer events from the micro:bit.
 All the code is fully editable and documentation on each call is available by selecting the function and tapping 'Help'.
 
 ---
 
 Note that the three accelerometer values displayed in the Live View need to be configured in the LiveView.swift file for this page. These are easily added with one line of code for each _measurement_. Refer to the LiveView.swift for further details.
 */
import Foundation
//: `onGesture` detects when a _gesture_ from the accelerometer has happened and then executes the code in the handler. The first parameter is the type of gesture. In each case below we display an appropriate image on the display.
onGesture(.shake, handler: {
    let image = iconImage(.confused)
    image.showImage()
})

onGesture(.tiltLeft, handler: {
    let image = iconImage(.west)
    image.showImage()
})

onGesture(.tiltRight, handler: {
    let image = iconImage(.east)
    image.showImage()
})

onGesture(.tiltUp, handler: {
    let image = iconImage(.north)
    image.showImage()
})

onGesture(.tiltDown, handler: {
    let image = iconImage(.south)
    image.showImage()
})

onGesture(.faceUp, handler: {
    let image = iconImage(.happy)
    image.showImage()
})

onGesture(.faceDown, handler: {
    let image = iconImage(.sad)
    image.showImage()
})
