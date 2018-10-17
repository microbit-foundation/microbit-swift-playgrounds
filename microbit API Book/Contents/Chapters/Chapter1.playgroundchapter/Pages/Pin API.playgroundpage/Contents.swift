//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "PinAPINarative")
 
 This page demonstrates the 'pin' API for configuring the GPIO on the micro:bit.
 All the code is fully editable and documentation on each call is available by selecting the function and tapping 'Help'.
 */
import Foundation

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

setInputPins([.pin0, .pin1, .pin2])
setAnaloguePins([.pin0, .pin1, .pin2])

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
