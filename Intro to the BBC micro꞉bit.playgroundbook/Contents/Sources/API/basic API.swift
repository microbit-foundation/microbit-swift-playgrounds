/*
 MIT License
 
 Copyright (c) 2018 micro:bit Educational Foundation
 Written by Gary J.H. Atkinson of Stinky Kitten Ltd.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import Foundation

/**
 Shows a number on the LED screen. It will slide left if it has more than one digit.
 - parameters:
    - _ A number as an Int or a Double, this cannot be omitted.
 */
public func showNumber(_ number: Int) {
    
    showString(String(number))
}

/**
 Shows a number on the LED screen. It will slide left if it has more than one digit.
 - parameters:
    - _ A number as an Int or a Double, this cannot be omitted.
 */
public func showNumber(_ number: Double) {
    
    showString(String(number))
}

/**
 Shows a picture on the LED screen.
 - parameters:
    - _ A string that controls which LEDs are on and off. This is a multi-line string with a # to turn the LED on and a . to turn it off.
 */
public func showLeds(_ string: String) {
    
    MicrobitImage(string).showImage()
}

/**
 Shows the chosen icon on the LED screen.
 - parameters:
    - _ The icon name of the image you want to show. You can pick an icon image such as: .heart
 */
public func showIcon(_ iconName: MicrobitImage.IconName) {
    
    iconImage(iconName).showImage()
}

/**
 Scrolls a text string onto the LED screen
 - parameters:
    - _ Text as a String, this cannot be omitted.
 */
public func showString(_ text: String) {
    
    ContentMessenger.messenger.sendMessageOfType(.writeData,
                                                 forCharacteristicUUID: .ledTextUUID,
                                                 withData: text.microbitData)
}

/**
 Sets the delay when scrolling text.
 - parameters:
    - _ delay: A number that sets how many milli-seconds between each movement of the scroll. The bigger the value the slower the text will scroll.
 */
public func setScrollingDelay(_ delay: Int) {
    
    ContentMessenger.messenger.sendMessageOfType(.writeData,
                                                 forCharacteristicUUID: .ledScrollingDelayUUID,
                                                 withData: Data.littleEndianUInt16FromInt(delay))
}

/**
 Scroll (slide) an image (picture) from one side to the other of the LED screen.
 
 - parameters:
    - _ delayInSeconds: A number that sets how many seconds between each movement of the scroll.  The bigger the value the slower the text will scroll.
 */
public func setScrollingDelayInSeconds(_ delayInSeconds: Double) {
    setScrollingDelay(Int(delayInSeconds * 1_000))
}

/**
 Shows the chosen arrow on the LED screen.
 - parameters:
    - _ The arrow name of the image you want to show. You can pick an arrow image such as: .north
 */
public func showArrow(_ arrowName: MicrobitImage.ArrowName) {
    
    arrowImage(arrowName).showImage()
}

/**
Turn off all the LED lights on the LED screen.
 */
public func clearScreen() {
    MicrobitImage().showImage()
}
