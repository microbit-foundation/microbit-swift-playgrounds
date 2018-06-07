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

public func plot(x: Int, y: Int) {
    readImage{(image: MicrobitImage?, error: Error?) in
        if image != nil {
            image!.plot(column: x, row: y)
            image!.showImage()
        }
    }
}

public func unplot(x: Int, y: Int) {
    readImage{(image: MicrobitImage?, error: Error?) in
        if image != nil {
            image!.unplot(column: x, row: y)
            image!.showImage()
        }
    }
}

public func toggle(x: Int, y: Int) {
    readImage{(image: MicrobitImage?, error: Error?) in
        if image != nil {
            image![x, y] = image![x, y] == .off ? .on : .off
            image!.showImage()
        }
    }
}

public func readPoint(x: Int, y: Int, handler: (LEDState) -> Void) {
    readImage{(image: MicrobitImage?, error: Error?) in
        if image != nil {
            handler(image![x, y])
        }
    }
}

func readImage(handler: ReadImageHandler) {
    ContentMessenger.messenger.sendMessageOfType(.readData,
                                                 forCharacteristicUUID: .ledStateUUID,
                                                 handler: handler)
}
