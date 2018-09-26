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

@objc(GradientView)
@IBDesignable public class GradientView: UIView {
    
    override public class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }
    
    @IBInspectable var startColor: UIColor = UIColor.lanternBlue {
        didSet {
            self.setupGradientLayer()
        }
    }
    
    @IBInspectable var endColor: UIColor = UIColor.lanternGreen {
        didSet{
            self.setupGradientLayer()
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        guard let gradientLayer = self.layer as? CAGradientLayer else { return }
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
    }
    
    func setupGradientLayer() {
        guard let gradientLayer = self.layer as? CAGradientLayer else { return }
        gradientLayer.colors = [self.startColor.cgColor, self.endColor.cgColor]
    }
}
