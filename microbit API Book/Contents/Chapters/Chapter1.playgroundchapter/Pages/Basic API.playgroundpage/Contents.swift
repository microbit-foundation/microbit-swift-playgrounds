//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "BasicAPINarative")
 
 This page demonstrates the 'basic' API for sending data to the micro:bit.
 All the code is fully editable and documentation on each call is available by selecting the function and tapping 'Help'.
 */
import Foundation

func wait(_ delayInSeconds: Double) {
    usleep(UInt32(delayInSeconds * 1_000_000))
}

setScrollingDelay(500)
showString("X")
wait(6)

let scrollingDelay = 0.2
setScrollingDelayInSeconds(scrollingDelay)

let textToDisplay = "Hello World!"
showString(textToDisplay)
wait(scrollingDelay * Double((textToDisplay.count + 1) * 6 + 2))

showNumber(scrollingDelay)
wait(scrollingDelay * 30)

showLeds("""
#.#.#
.#.#.
#.#.#
.#.#.
#.#.#
""")
wait(2)

showIcon(.heart)
wait(2)

showArrow(.north)
wait(2)

clearScreen()
