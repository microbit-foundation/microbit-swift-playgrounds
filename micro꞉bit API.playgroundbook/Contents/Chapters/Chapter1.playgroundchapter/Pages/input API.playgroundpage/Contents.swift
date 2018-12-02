//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "InputAPINarative")
 
 This page demonstrates some of the _input_ API for reading data from the micro:bit.
 All the code is fully editable and documentation on each call is available by selecting the function and tapping 'Help'.
 */
import Foundation
//: `onButtonPressed` detects when a button is pressed depending on the first parameter, in this case button A. We then pass a handler which is the code that gets called when the button is pressed. In this case an arrow is displayed pointing to the button.
onButtonPressed(.A, handler: {
    let image = arrowImage(.west)
    image.showImage()
})
//: Similar to the above, this is the same function but with a different parameter and a different arrow is displayed.
onButtonPressed(.B, handler: {
    let image = arrowImage(.east)
    image.showImage()
})
//: This time we react to both buttons being pressed and we display arrows pointing to both buttons. But there is no pre-defined arrow for this. Notice that instead we are **adding** two images together.
onButtonPressed(.AB, handler: {
    let image = arrowImage(.west) + arrowImage(.east)
    image.showImage()
})
//: `onPinPressed` is similar to onButtonPressed except the first parameter is one of the pins and the second is the handler that gets called.
onPinPressed(.pin0, handler: {
    Character("0").microbitImage.showImage()
})

onPinPressed(.pin1, handler: {
    Character("1").microbitImage.showImage()
})

onPinPressed(.pin2, handler: {
    Character("2").microbitImage.showImage()
})
