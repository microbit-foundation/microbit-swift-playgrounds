//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "InputAPINarative")
 
 This page demonstrates the 'input' API for reading data from the micro:bit.
 All the code is fully editable and documentation on each call is available by selecting the function and tapping 'Help'.
 */
import Foundation

onButtonPressed(.A, handler: {
    let image = arrowImage(.west)
    image.showImage()
})

onButtonPressed(.B, handler: {
    let image = arrowImage(.east)
    image.showImage()
})

onButtonPressed(.AB, handler: {
    let image = arrowImage(.west) + arrowImage(.east)
    image.showImage()
})

onPinPressed(.pin0, handler: {
    Character("0").microbitImage.showImage()
})

onPinPressed(.pin1, handler: {
    Character("1").microbitImage.showImage()
})

onPinPressed(.pin2, handler: {
    Character("2").microbitImage.showImage()
})
