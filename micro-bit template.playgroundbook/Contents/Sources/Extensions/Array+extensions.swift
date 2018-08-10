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

extension Array where Element: MicrobitImage {
    
    /**
     A function that returns the start index for scrolling an array of MicrobitImages.
     - returns:
     An Int suitable for the lower bounds in a loop for getting the image for scroll index.
     */
    public func scrollStartIndex() -> Int {
        return 1
    }
    
    /**
     A function that returns the end index for scrolling an array of MicrobitImages.
     - parameters:
        - withSpacing: An Int that adds an additional number of blank columns between each image. This parameter is optional and defaults to 0.
     - returns:
     An Int suitable for the upper bounds in a loop for getting the image for scroll index.
     */
    public func scrollEndIndex(withSpacing spacing: Int = 0) -> Int {
        return (self.count + 1) * (5 + spacing)
    }
    
    /**
     A function that returns an image that is offset by the scroll index for an array of MicrobitImages. This function ensures that upto two images are appropriate offset and added together when creating the returned image.
     - parameters:
        - _ scrollIndex: An Int that specifies the scroll index to the given image to return. This value needs to be between the scrollStartIndex() and scrollEndIndex().
        - withSpacing: an Int that adds an additional number of blank columns between each image. This parameter is optional and defaults to 0.
     - returns:
     A MicrobitImage that is offset by the specifed scroll index.
     */
    public func imageAtScrollIndex(_ scrollIndex: Int, withSpacing spacing: Int = 0) -> MicrobitImage {
        
        let imageWidth = 5 + spacing
        if scrollIndex % imageWidth == 0 {
            // There's only one character to display
            return self.microbitImageAtIndex(scrollIndex / imageWidth - 1)
        } else {
            
            let leftCharacterImage = self.microbitImageAtIndex(scrollIndex / imageWidth - 1, offsetBy: scrollIndex % imageWidth)
            let rightCharacterImage = self.microbitImageAtIndex(scrollIndex / imageWidth, offsetBy: scrollIndex % imageWidth - imageWidth)
            return leftCharacterImage + rightCharacterImage
        }
    }
    
    func microbitImageAtIndex(_ index: Int, offsetBy imageOffset: Int = 0) -> MicrobitImage {
        
        if !self.indices.contains(index) { return MicrobitImage() }
        return self[index].imageOffsetBy(dx: imageOffset)
    }
}
