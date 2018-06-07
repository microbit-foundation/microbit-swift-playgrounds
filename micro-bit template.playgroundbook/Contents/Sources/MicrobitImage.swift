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

import UIKit

public enum LEDState: Int {
    case off = 0
    case on = 255
}

public class MicrobitImage: CustomStringConvertible, Equatable {
    
    internal (set) var imageData = Data(count: 5)
    
    public init() {
    }
    
    public init(_ imageData: Data) {
        
        self.imageData = imageData
    }
    
    public init(_ imageText: String) {
        
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
    
    public func plot(column: Int, row: Int) {
        self[column, row] = .on
    }
    
    public func unplot(column: Int, row: Int) {
        self[column, row] = .off
    }
    
    public func ledState(column: Int, row: Int) -> LEDState {
        return self[column, row]
    }
    
    public func setLEDState(column: Int, row: Int, state: LEDState) {
        self[column, row] = state
    }
    
    func indexIsValid(column: Int, row: Int) -> Bool {
        return column >= 0 && column < 5 && row >= 0 && row < 5
    }
    
    public subscript(column: Int, row: Int) -> LEDState {
        
        get {
            assert(indexIsValid(column: column, row: row), "Index out of range")
            let ledRow: UInt8 = self.imageData[row]
            let bitValue = UInt8(1 << (4 - column))
            return (ledRow & bitValue) != 0 ? .on : .off
        }
        
        set {
            assert(indexIsValid(column: column, row: row), "Index out of range")
            var ledRow: UInt8 = self.imageData[row]
            let bitValue = UInt8(1 << (4 - column))
            ledRow = newValue == .on ? (ledRow | bitValue) : (ledRow & ~bitValue)
            self.imageData[row] = ledRow
        }
    }
    
    public static func == (lhs: MicrobitImage, rhs: MicrobitImage) -> Bool {
        return lhs.imageData == rhs.imageData
    }
    
    public static prefix func ~ (image: MicrobitImage) -> MicrobitImage {
        
        var imageData = image.imageData
        for row in 0...4 {
            imageData[row] ^= 0b00011111
        }
        
        return MicrobitImage(imageData)
    }
    
    public static func | (image1: MicrobitImage, image2: MicrobitImage) -> MicrobitImage {
        
        var imageData = image1.imageData
        for row in 0...4 {
            imageData[row] |= image2.imageData[row]
        }
        
        return MicrobitImage(imageData)
    }
    
    public static func + (image1: MicrobitImage, image2: MicrobitImage) -> MicrobitImage {
        return image1 | image2
    }
    
    public var description: String {
        
        var stringDescription = ""
        
        for y in 0...4 {
            for x in 0...4 {
                if self.ledState(column: x, row: y) == .on {
                    stringDescription += "#"
                } else {
                    stringDescription += "."
                }
            }
            stringDescription += "\n"
        }
        return stringDescription
    }
    
    public func imageOffsetBy(_ x: Int) -> MicrobitImage {
        
        if x == 0 {
            return self
        } else if abs(x) > 4 {
            return MicrobitImage()
        }
        
        var imageData = self.imageData
        for row in 0...4 {
            imageData[row] = (imageData[row] << x) & 0b00011111
        }
        
        return MicrobitImage(imageData)
    }
    
    // MARK: - Convenience class constructors
}
