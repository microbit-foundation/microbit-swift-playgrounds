//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "GesturesAPINarative")
 
 This page demonstrates the 'gestures' API for accelerometer events from the micro:bit.
 All the code is fully editable and documentation on each call is available by selecting the function and tapping 'Help'.
 */
import Foundation

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
