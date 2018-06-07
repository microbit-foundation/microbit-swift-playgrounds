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

@objc(MicrobitMimic)
@IBDesignable public class MicrobitMimic: UIView {
    
    let mimicImage: UIImage?
    var _microbitImage: MicrobitImage = MicrobitImage()
    var buttonALayer: CAShapeLayer?
    var buttonBLayer: CAShapeLayer?
    
    public var isActive: Bool = true
    
    override public init(frame: CGRect) {
        
        mimicImage = UIImage(named: "microbit-mimic-blue")
        
        super.init(frame: frame)
        
        self.setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        mimicImage = UIImage(named: "microbit-mimic-blue")
        
        super.init(coder: aDecoder)
        
        self.setupView()
    }
    
    func setupView() {
        
        self.backgroundColor = UIColor.clear
        self.isOpaque = false
        self.layer.contents = self.mimicImage?.cgImage
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        
        if let ledImage = UIImage(named: "mimic-led") {
            for ledX in 0...4 {
                for ledY in 0...4 {
                    let ledLayer = CALayer()
                    ledLayer.contents = ledImage.cgImage
                    ledLayer.opacity = 0.8
                    let frameOrigin = CGPoint(x: 91 + ledX * 28, y: 58 + ledY * 27)
                    ledLayer.name = "\(ledX),\(ledY)"
                    ledLayer.frame = CGRect(origin: frameOrigin, size: ledImage.size)
                    ledLayer.isHidden = true
                    self.layer.addSublayer(ledLayer)
                }
            }
        }
        
        let buttonSize = CGSize(width: 23, height: 23)
        let path = UIBezierPath(ovalIn: CGRect(origin: CGPoint.zero, size:buttonSize))
        self.buttonALayer = CAShapeLayer()
        self.buttonALayer!.path = path.cgPath
        self.buttonALayer!.fillColor = UIColor.orange.cgColor
        var frameRect = CGRect(origin: CGPoint(x: 27.5, y:130.5), size: buttonSize)
        self.buttonALayer!.frame = frameRect
        self.buttonALayer!.isHidden = true
        self.layer.addSublayer(self.buttonALayer!)
        
        self.buttonBLayer = CAShapeLayer()
        self.buttonBLayer!.path = path.cgPath
        self.buttonBLayer!.fillColor = UIColor.orange.cgColor
        frameRect.origin.x = 313
        self.buttonBLayer!.frame = frameRect
        self.buttonBLayer!.isHidden = true
        self.layer.addSublayer(self.buttonBLayer!)
    }
    
    var microbitImage: MicrobitImage {
        get {
            return _microbitImage
        }
        set {
            _microbitImage = newValue
            if let sublayers = self.layer.sublayers {
                for sublayer in sublayers {
                    if let substrings = sublayer.name?.split(separator: ",") {
                        if substrings.count > 1, let x = Int(substrings[0]), let y = Int(substrings[1]) {
                            sublayer.isHidden = _microbitImage[x, y] == .off
                        }
                    }
                }
            }
        }
    }
    
    public func showButtonAPressed(_ flag: Bool) {
        self.buttonALayer?.isHidden = !flag
    }
    
    public func showButtonBPressed(_ flag: Bool) {
        self.buttonBLayer?.isHidden = !flag
    }
    
    override public var intrinsicContentSize: CGSize {
        get {
            return mimicImage != nil ? mimicImage!.size : CGSize.zero
        }
    }
}
