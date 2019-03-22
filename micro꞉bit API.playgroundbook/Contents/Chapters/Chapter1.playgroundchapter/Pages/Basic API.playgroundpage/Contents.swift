//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "BasicAPINarative")
 
 This page demonstrates the _basic_ API for sending data to the micro:bit.
 All the code is fully editable and documentation on each call is available by selecting the function and tapping 'Help'.
 */
import Foundation
//: Define a wait function that pauses the code for a given number of seconds. Typically you might want to hide this function at the beginning of the Contents.swift file.
func wait(_ delayInSeconds: Double) {
    usleep(UInt32(delayInSeconds * 1_000_000))
}
//: Set the scrolling delay in milli-seconds. This is the time between each scrolling action.
setScrollingDelay(500)
//: Show a string with the new scrolling delay.
//: We wait after each of the showString functions as they execute 'immediately' over Bluetooth.
showString("X")
wait(6)
//: Define a constant for the scrolling delay and set the scrolling delay in seconds.
let scrollingDelay = 0.2
setScrollingDelayInSeconds(scrollingDelay)
//: Define a constant for a text string and display it.
let textToDisplay = "Hello World!"
showString(textToDisplay)
wait(scrollingDelay * Double((textToDisplay.count + 1) * 6 + 2))
//: Scroll a number on the LED display. This can be either an Int or a Double.
showNumber(scrollingDelay)
wait(scrollingDelay * 30)
//: Display an 'Image' on the LED display. This is defined as a multi-line string. The # represent an ON LED where the . is OFF. Any spaces or other whitespace is ignored. A newline however defines the next row of LEDs.
showLeds("""
#.#.#
.#.#.
#.#.#
.#.#.
#.#.#
""")
wait(2)
//: Display one of the pre-defined icons on the LED display.
showIcon(.heart)
wait(2)
//: Display one of the pre-defined arrows on the LED display.
showArrow(.north)
wait(2)
//: Clear the LED display.
clearScreen()
