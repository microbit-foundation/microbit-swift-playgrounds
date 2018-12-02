//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "MicrobitLEDAPINarative")
 
 This page demonstrates the _LED_ API.
 All the code is fully editable and documentation on each call is available by selecting the function and tapping 'Help'.
 
 ---
 
 Note that these functions execute immediately, so unless you _wait_ after each call then you will not see the effect.
 */
import Foundation
func wait(_ delayInSeconds: Double) {
    usleep(UInt32(delayInSeconds * 1_000_000))
}
clearScreen()
//: `plot()` sets an LED to the on state at the given x and y location. x and y values can be any integer in the range 0 - 4.
plot(x: 2, y: 2)
wait(2.0)
//: Plot a range of LEDs
for x in 0...4 {
    plot(x: x, y: 0)
    plot(x: x, y: 4)
}
for y in 1...3 {
    plot(x: 0, y: y)
    plot(x: 4, y: y)
}
wait(2.0)
//: `unplot()` sets an LED to the off state.
unplot(x: 2, y: 2)
wait(2.0)
//: The `toggle()` function toggles the state of the given LED.
toggle(x: 2, y: 2)
