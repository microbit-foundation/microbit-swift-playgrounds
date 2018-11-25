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

extension String {
    
    var microbitData: Data {
        get {
            let utf8String = self.utf8.prefix(20)
            return Data(utf8String)
        }
    }
    
    /**
     A variable for getting an array of type MicrobitImage from a String.
     
     There are extensions to Array\<MicrobitImage\> to simplify the scrolling of multiple images on the micro:bit display.
     - returns: An array of MicrobitImages
     */
    public var microbitImages: Array<MicrobitImage> {
        get {
            return self.map { $0.microbitImage }
        }
    }
}

extension Character {
    
    var asciiValue: UInt32? {
        get {
            if let firstScalar = self.unicodeScalars.first {
                if firstScalar.isASCII {
                    return firstScalar.value
                }
            }
            return nil
        }
    }
    
    /**
     A variable for getting the MicrobitImage for a Character.
     
     - returns: a MicrobitImage
     */
    public var microbitImage: MicrobitImage {
        get {
            return MicrobitFont.defaultFont.microbitImageForCharacter(self)
        }
    }
}
