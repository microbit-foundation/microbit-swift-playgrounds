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
import CoreGraphics

extension MicrobitImage: CustomPlaygroundDisplayConvertible {
    
    public var playgroundDescription: Any {
        
        let imageRect = CGRect(x: 0, y: 0, width: 69, height: 69)
        let renderer = UIGraphicsImageRenderer(size: imageRect.size)
        let image = renderer.image { (context) in
            let backgroundPath = UIBezierPath(roundedRect: imageRect, cornerRadius: 6.0)
            context.cgContext.setFillColor(UIColor(white: 0.1, alpha: 1.0).cgColor)
            context.cgContext.addPath(backgroundPath.cgPath)
            context.cgContext.fillPath(using: .evenOdd)
            
            if let ledOffImage = UIImage(named: "viewer-led-off"),
                let ledOnImage = UIImage(named: "viewer-led-on") {
                
                for y in 0...4 {
                    for x in 0...4 {
                        let ledRect = CGRect(x: 5 + x * 14, y: 5 + y * 13, width: 3, height: 7)
                        ledOffImage.draw(in: ledRect)
                        if self[x, y] == .on {
                            let ledRect = CGRect(x: -8 + x * 14, y: -8 + y * 13, width: 30, height: 33)
                            ledOnImage.draw(in: ledRect)
                        }
                    }
                }
            }
        }
        return image
    }
}
