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
 A Swift enum to represent the state of an LED.
 
 It is either .on or .off
 */
public enum LEDState: Int {
    case off = 0
    case on = 255
}

/**
 An object for representing images that can be displayed on the micro:bit's display.
 
 Images can be created from multi-line Strings or you can create a blank image and set its individual LEDs.
 
 You can do many operations on an image before it is displayed such as offseting (scrolling) and adding two images together.
 */
public final class MicrobitImage: Equatable, LosslessStringConvertible, ExpressibleByStringLiteral {
    
    var imageData = Data(count: 5)
    
    /**
     The basic initializer that creates an image with all the LEDs turned off.
     */
    public init() {
    }
    
    /**
     An initializer that takes Data as a parameter.
     - parameters:
        - _ The Data that represents the image.
     */
    public init(_ imageData: Data) {
        
        self.imageData = imageData
    }
    
    /**
     An initializer that takes a String as a parameter.
     ````
     let image = MicrobitImage("""
     #.#.#
     .#.#.
     #.#.#
     .#.#.
     #.#.#
     """)
     ````
     - parameters:
        - _ A string that represents the image. This should be a multi-line string with the # character to represent an LED that is on and a . for those that are off. Spaces are ignored.
     */
    required public init(_ imageText: String) {
        
        var x = 0, y = 0
        for char in imageText {
            
            switch (char) {
                
            case ".":
                x += 1
                
            case "\n":
                y += 1
                x = 0
                
            case " ":
                break
                
            default:
                self[x, y] = .on
                x += 1
            }
        }
    }
    
    required public init(stringLiteral imageText: String) {
        self.imageData = MicrobitImage(imageText).imageData
    }
    
    /**
     A function that returns a copy of the image
     ````
     let copiedImage = image.copy()
     ````
     - returns: A copy of the image.
     */
    public func copy() -> MicrobitImage {
        return MicrobitImage(self.imageData)
    }
    
    /**
     A function that sets an individual LED in the image to on.
     ````
     image.plot(x: 2, y: 3)
     ````
     - parameters:
        - x: The x, or horizontal offset, for the LED to turn on. Values are valid from 0 to 4, left to right.
        - y: The y, or vertical offset, for the LED to turn on. Values are valid from 0 to 4, top to bottom.
     */
    public func plot(x: Int, y: Int) {
        self[x, y] = .on
    }
    /**
     A function that sets an individual LED in the image to off.
     ````
     image.unplot(x: 2, y: 3)
     ````
     - parameters:
        - x: The x, or horizontal offset, for the LED to turn off. Values are valid from 0 to 4, left to right.
        - y: The y, or vertical offset, for the LED to turn off. Values are valid from 0 to 4, top to bottom.
     */
    public func unplot(x: Int, y: Int) {
        self[x, y] = .off
    }
    
    /**
     Reads an LED state in the image to determine if it is on or off.
     ````
     let ledState = image.ledState(x: 2, y: 3)
     ````
     - parameters:
        - x: The x, or horizontal offset, for the LED to read. Values are valid from 0 to 4, left to right.
        - y: The y, or vertical offset, for the LED to read. Values are valid from 0 to 4, top to bottom.
     - returns: The state of the LED, this is either .off or .on
     */
    public func ledState(x: Int, y: Int) -> LEDState {
        return self[x, y]
    }
    
    /**
     Sets an LED state in the image to either .on or .off
     ````
     image.setLEDState(x: 2, y: 3, state: .on)
     ````
     - parameters:
        - x: The x, or horizontal offset, for the LED to read. Values are valid from 0 to 4, left to right.
        - y: The y, or vertical offset, for the LED to read. Values are valid from 0 to 4, top to bottom.
        - state: The LED state, this is either: .on or .off
     */
    public func setLedState(x: Int, y: Int, state: LEDState) {
        self[x, y] = state
    }
    
    func indexIsValid(x: Int, y: Int) -> Bool {
        return x >= 0 && x < 5 && y >= 0 && y < 5
    }
    
    /**
     Reads or sets an LED state in the image to either .on or .off
     ````
     image[2, 3] = .on
     let ledState = image[1, 4]
     ````
     - parameters:
        - a subscript with an x and y value in square brackets.
     - returns: The state of the LED, this is either .off or .on
     */
    public subscript(x: Int, y: Int) -> LEDState {
        
        get {
            assert(indexIsValid(x: x, y: y), "Index out of range")
            let ledY: UInt8 = self.imageData[y]
            let bitValue = UInt8(1 << (4 - x))
            return (ledY & bitValue) != 0 ? .on : .off
        }
        
        set {
            assert(indexIsValid(x: x, y: y), "Index out of range")
            var ledY: UInt8 = self.imageData[y]
            let bitValue = UInt8(1 << (4 - x))
            ledY = newValue == .on ? (ledY | bitValue) : (ledY & ~bitValue)
            self.imageData[y] = ledY
        }
    }
    
    public static func == (lhs: MicrobitImage, rhs: MicrobitImage) -> Bool {
        return lhs.imageData == rhs.imageData
    }
    
    /**
     A prefix operator that creates an inverted image, that is LEDs that are on are turned off and those that are off are turned on.
     ````
     let invertedImage = ~image
     ````
     */
    public static prefix func ~ (image: MicrobitImage) -> MicrobitImage {
        
        var imageData = image.imageData
        for y in 0...4 {
            imageData[y] ^= 0b00011111
        }
        
        return MicrobitImage(imageData)
    }
    
    /**
     An overloaded operator that performs a binary OR to each LED in two MicrobitImages.
     - returns: A MicrobitImage
     */
    public static func | (image1: MicrobitImage, image2: MicrobitImage) -> MicrobitImage {
        
        var imageData = image1.imageData
        for y in 0...4 {
            imageData[y] |= image2.imageData[y]
        }
        
        return MicrobitImage(imageData)
    }
    
    public static func ^ (image1: MicrobitImage, image2: MicrobitImage) -> MicrobitImage {
        
        var imageData = image1.imageData
        for y in 0...4 {
            imageData[y] ^= image2.imageData[y]
        }
        
        return MicrobitImage(imageData)
    }
    
    public static func & (image1: MicrobitImage, image2: MicrobitImage) -> MicrobitImage {
        
        var imageData = image1.imageData
        for y in 0...4 {
            imageData[y] &= image2.imageData[y]
        }
        
        return MicrobitImage(imageData)
    }
    
    /**
     An overloaded operator that performs an addition of two MicrobitImages by applying a binary OR to each LED.
     - returns: A MicrobitImage
     */
    public static func + (image1: MicrobitImage, image2: MicrobitImage) -> MicrobitImage {
        return image1 | image2
    }
    
    public static func - (image1: MicrobitImage, image2: MicrobitImage) -> MicrobitImage {
        return image1 & ~image2
    }
    
    public var description: String {
        
        var stringDescription = ""
        
        for y in 0...4 {
            for x in 0...4 {
                if self.ledState(x: x, y: y) == .on {
                    stringDescription += "#"
                } else {
                    stringDescription += "."
                }
            }
            stringDescription += "\n"
        }
        return stringDescription
    }
    
    /**
     A function that returns an image offset in either the x or y direction or both. This function is useful for scrolling and animating images.
     
     The offsets can be either positive or negative and both are optional with default values of 0.
     
     Positive offsets move the image to left and up, whereas negative offsets move the image right and down.
     ````
     let offsetImage = image.imageOffsetBy(x: 2, y: 3)
     ````
     - parameters:
        - dx: The amount to offset in the x (or horizonal) direction.
        - dy: The amount to offset in the y (or vertical) direction.
     - returns: The offset image
     */
    public func imageOffsetBy(dx: Int = 0, dy: Int = 0) -> MicrobitImage {
        
        if dx == 0 && dy == 0 {
            return self.copy()
        } else if abs(dx) > 4 || abs(dy) > 4 {
            return MicrobitImage()
        }
        
        var imageData = self.imageData
        // Do the x shifting
        if abs(dx) > 0 {
            for row in 0...4 {
                imageData[row] = dx.signum() == 1 ? imageData[row] << dx : imageData[row] >> abs(dx)
            }
        }
        // Do the y shifting
        if abs(dy) > 0 {
            for row in 0...4 {
                let sourceRow = row + dy
                switch sourceRow {
                case 0...4:
                    imageData[row] = imageData[row + dy]
                    
                default:
                    imageData[row] = 0
                }
            }
        }
        
        return MicrobitImage(imageData)
    }
}
