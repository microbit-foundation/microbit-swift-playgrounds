//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "PinAPINarative")
 
 This page demonstrates the _pin_ API for configuring the GPIO on the micro:bit.
 All the code is fully editable and documentation on each call is available by selecting the function and tapping 'Help'.
 
 ---
 
 In order to see this page in action you will need to have a light sensor connected appropriately to pin0.
 */
import Foundation
//: Define two images for display.
let moonImage: MicrobitImage = """
XXX..
.XXX.
..XX.
.XXX.
XXX..
"""

let sunImage: MicrobitImage = """
X.X.X
.XXX.
XXXXX
.XXX.
X.X.X
"""
//: Configure which pins you wish to use for input and output.
setInputPins([.pin0, .pin1, .pin2])
//: Configure which pins you wish to use as either analogue or digital.
setAnaloguePins([.pin0, .pin1, .pin2])
//: Call `onPins()` with a handler which is called whenever one of the values changes on an input pin. The handler returns a _PinStore_ which acts like a dictionary container for pin values.
clearScreen()
var lastImage: MicrobitImage? = nil
onPins({(pinStore: PinStore) in
    if let pinValue = pinStore[.pin0] {
        var newImage: MicrobitImage? = nil
        if pinValue > 100 {
            newImage = sunImage
        } else {
            newImage = moonImage
        }
        if lastImage != newImage {
            newImage!.showImage()
            lastImage = newImage
        }
    }
})
