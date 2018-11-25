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
 Turns on a single LED on the micro:bit display.
 - parameters:
    - x: The x, or horizontal offset, for the LED to turn on. Values are valid from 0 to 4, left to right.
    - y: The y, or vertical offset, for the LED to turn on. Values are valid from 0 to 4, top to bottom.
 */
public func plot(x: Int, y: Int) {
    readImage{(image: MicrobitImage?) in
        if image != nil {
            image!.plot(x: x, y: y)
            image!.showImage()
        }
    }
}

/**
 Turns off a single LED on the micro:bit display.
 - parameters:
    - x: The x, or horizontal offset, for the LED to turn off. Values are valid from 0 to 4, left to right.
    - y: The y, or vertical offset, for the LED to turn off. Values are valid from 0 to 4, top to bottom.
 */
public func unplot(x: Int, y: Int) {
    readImage{(image: MicrobitImage?) in
        if image != nil {
            image!.unplot(x: x, y: y)
            image!.showImage()
        }
    }
}

/**
 Toggles a single LED on the micro:bit display. This means if the LED is off it will be turned on or if it is on it will be turned off.
 - parameters:
    - x: The x, or horizontal offset, for the LED to toggle. Values are valid from 0 to 4, left to right.
    - y: The y, or vertical offset, for the LED to toggle. Values are valid from 0 to 4, top to bottom.
 */
public func toggle(x: Int, y: Int) {
    readImage{(image: MicrobitImage?) in
        if image != nil {
            image![x, y] = image![x, y] == .off ? .on : .off
            image!.showImage()
        }
    }
}

/**
 Reads an LED on the display to determine if it is on or off.
 - parameters:
    - x: The x, or horizontal offset, for the LED to read. Values are valid from 0 to 4, left to right.
    - y: The y, or vertical offset, for the LED to read. Values are valid from 0 to 4, top to bottom.
    - handler: A handler with one parameter, that being the state of the LED, this is either .off or .on
 */
public func readPoint(x: Int, y: Int, handler: @escaping (LEDState) -> Void) {
    readImage{(image: MicrobitImage?) in
        if image != nil {
            handler(image![x, y])
        }
    }
}

func readImage(handler: @escaping ReadImageHandler) {
    
    ContentMessenger.messenger.sendMessageOfType(.readData,
                                                 forCharacteristicUUID: .ledStateUUID,
                                                 handler: handler)
}
