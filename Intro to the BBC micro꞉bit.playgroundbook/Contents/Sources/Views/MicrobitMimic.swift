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
import CoreMotion

private let MicrobitAccelerometerTiltTolerance = 300.0
private let MicrobitAccelerometerFreefallTolerance = 400.0
private let MicrobitAccelerometer3GTolerance = 3072.0
private let MicrobitAccelerometer6GTolerance = 6144.0
private let MicrobitAccelerometer8GTolerance = 8192.0
private let MicrobitGestureEventTolerance = 6 // The number of accelerometer events that must elapse before gestures are recognised

public typealias MimicAccelerometerHandler = (AccelerometerValues) -> MicrobitMimic.NotificationAction

@objc(MicrobitMimic)
@IBDesignable public class MicrobitMimic: UIView {
    
    let mimicImage: UIImage?
    var scrollingDelay = 120
    let mimicLayer = CALayer()
    let buttonALayer = CAShapeLayer()
    let buttonBLayer = CAShapeLayer()
    var pinLayers = Dictionary<BTMicrobit.Pin, CALayer>()
    var filteredAccelerometerValues = AccelerometerValues(x: 0.0, y: 0.0, z: 0.0,
                                                          unit: UnitAcceleration.microbitGravity)
    var gestureEventCount = 0
    
    var touchesMap = Dictionary<UITouch, CALayer>()
    
    let motionManager = CMMotionManager()
    public var orientation: UIInterfaceOrientation = .unknown
    
    public weak var messageLogger: LoggingProtocol?
    public weak var delegate: MicrobitMimicDelegate?
    
    let isolationQueue = DispatchQueue(label: "org.microbit.mimicHandlersQueue")
    var handlers = Dictionary<HandlerType, Dictionary<UUID, Any>>()
    
    enum HandlerType : Hashable {
        case accelerometer
        case magnetometer
    }
    
    public enum NotificationAction {
        case stopNotifications
        case continueNotifications
    }
    
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
    
    var isActive: Bool = true {
        
        didSet {
            if (isActive) {
                self.becomeFirstResponder()
                //self.messageLogger?.logMessage("Activate mimic")
            } else {
                //self.messageLogger?.logMessage("Deactivate mimic")
                self.stopAccelerometer()
                self.clearHandlers()
            }
        }
    }
    
    var microbitImage: MicrobitImage = MicrobitImage() {
        
        didSet {
            DispatchQueue.main.async {
                if let sublayers = self.mimicLayer.sublayers {
                    CATransaction.begin()
                    CATransaction.setAnimationDuration(0)
                    for sublayer in sublayers {
                        if let substrings = sublayer.name?.split(separator: ",") {
                            if substrings.count > 1, let x = Int(substrings[0]), let y = Int(substrings[1]) {
                                let layerHidden = self.microbitImage[x, y] == .off
                                if sublayer.isHidden != layerHidden {
                                    sublayer.isHidden = layerHidden
                                }
                            }
                        }
                    }
                    CATransaction.commit()
                }
            }
        }
    }
    
    var accelerometerValues: AccelerometerValues =
        AccelerometerValues(x: 0.0, y: 0.0, z: 0.0,
                            unit: UnitAcceleration.microbitGravity) {
        
        didSet {
            
            let alpha = self.lowPassFilterConstant
            filteredAccelerometerValues.x = accelerometerValues.x * alpha + filteredAccelerometerValues.x * (1.0 - alpha)
            filteredAccelerometerValues.y = accelerometerValues.y * alpha + filteredAccelerometerValues.y * (1.0 - alpha)
            filteredAccelerometerValues.z = accelerometerValues.z * alpha + filteredAccelerometerValues.z * (1.0 - alpha)
            
            let tau = CGFloat.tau
            var transform = CATransform3DIdentity
            transform.m34 = -1.0 / 1000.0
            transform = CATransform3DRotate(transform, max(min((tau / 4.0) * (CGFloat(filteredAccelerometerValues.x) / 1023.0), tau / 8.0), -tau / 8.0), 0.0, 1.0, 0.0)
            transform = CATransform3DRotate(transform, max(min((tau / 4.0) * (-CGFloat(filteredAccelerometerValues.y) / 1023.0), tau / 8.0), -tau / 8.0), 1.0, 0.0, 0.0)
            DispatchQueue.main.async {
                self.mimicLayer.transform = transform
            }
            
            let gStrength = accelerometerValues.strength
            /*DispatchQueue.main.async {
             self.messageLogger?.logMessage("\(gStrength)")
             }*/
            
            if gStrength > MicrobitAccelerometer3GTolerance{
                self.delegate?.microbitMimic(self, didGenerateEvent: BTMicrobit.Event(.threeG))
                
                if gStrength > MicrobitAccelerometer6GTolerance {
                    self.delegate?.microbitMimic(self, didGenerateEvent: BTMicrobit.Event(.sixG))
                }
                
                if gStrength > MicrobitAccelerometer8GTolerance {
                    self.delegate?.microbitMimic(self, didGenerateEvent: BTMicrobit.Event(.eightG))
                }
            }
            
            if self.gestureEventCount > MicrobitGestureEventTolerance {
                
                let filteredGStrength = filteredAccelerometerValues.strength
                if filteredGStrength < MicrobitAccelerometerFreefallTolerance {
                    self.delegate?.microbitMimic(self, didGenerateEvent: BTMicrobit.Event(.freeFall))
                }
                
                if filteredAccelerometerValues.x < (-1023 + MicrobitAccelerometerTiltTolerance) {
                    self.delegate?.microbitMimic(self, didGenerateEvent: BTMicrobit.Event(.tiltLeft))
                }
                
                if filteredAccelerometerValues.x > (1023 - MicrobitAccelerometerTiltTolerance) {
                    self.delegate?.microbitMimic(self, didGenerateEvent: BTMicrobit.Event(.tiltRight))
                }
                
                if filteredAccelerometerValues.y < (-1023 + MicrobitAccelerometerTiltTolerance) {
                    self.delegate?.microbitMimic(self, didGenerateEvent: BTMicrobit.Event(.tiltDown))
                }
                
                if filteredAccelerometerValues.y > (1023 - MicrobitAccelerometerTiltTolerance) {
                    self.delegate?.microbitMimic(self, didGenerateEvent: BTMicrobit.Event(.tiltUp))
                }
                
                if filteredAccelerometerValues.z < (-1023 + MicrobitAccelerometerTiltTolerance) {
                    self.delegate?.microbitMimic(self, didGenerateEvent: BTMicrobit.Event(.faceUp))
                }
                
                if filteredAccelerometerValues.z > (1023 - MicrobitAccelerometerTiltTolerance) {
                    self.delegate?.microbitMimic(self, didGenerateEvent: BTMicrobit.Event(.faceDown))
                }
                
            } else {
                self.gestureEventCount += 1
            }
        }
    }
    
    func setupView() {
        
        self.accelerometerPeriod = .ms80
        
        self.backgroundColor = UIColor.clear
        self.isOpaque = false
        
        if let image = self.mimicImage {
            self.mimicLayer.contents = image.cgImage
            self.mimicLayer.frame = CGRect(origin: CGPoint.zero, size: image.size)
        }
        self.mimicLayer.shadowOpacity = 0.5
        self.mimicLayer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        self.layer.addSublayer(self.mimicLayer)
        
        if let ledImage = UIImage(named: "mimic-led") {
            for ledX in 0...4 {
                for ledY in 0...4 {
                    let frameOrigin = CGPoint(x: 91 + ledX * 28, y: 58 + ledY * 27)
                    let ledLayer = makeImageLayer(image: ledImage, origin: frameOrigin)
                    ledLayer.name = "\(ledX),\(ledY)"
                }
            }
        }
        
        let buttonSize = CGSize(width: 23.0, height: 23.0)
        let path = UIBezierPath(ovalIn: CGRect(origin: CGPoint.zero, size:buttonSize))
        self.buttonALayer.path = path.cgPath
        self.buttonALayer.fillColor = UIColor.orange.cgColor
        var frameRect = CGRect(origin: CGPoint(x: 27.5, y:130.5), size: buttonSize)
        self.buttonALayer.frame = frameRect
        self.buttonALayer.opacity = 0.0
        self.mimicLayer.addSublayer(self.buttonALayer)
        
        var hitLayer = CALayer()
        hitLayer.frame = frameRect.insetBy(dx: -10.0, dy: -10.0)
        hitLayer.name = "buttonA"
        self.mimicLayer.addSublayer(hitLayer)
        
        self.buttonBLayer.path = path.cgPath
        self.buttonBLayer.fillColor = UIColor.orange.cgColor
        frameRect.origin.x = 313.0
        self.buttonBLayer.frame = frameRect
        self.buttonBLayer.opacity = 0.0
        self.mimicLayer.addSublayer(self.buttonBLayer)
        
        hitLayer = CALayer()
        hitLayer.frame = frameRect.insetBy(dx: -10.0, dy: -10.0)
        hitLayer.name = "buttonB"
        self.mimicLayer.addSublayer(hitLayer)
        
        if let pinImage = UIImage(named: "mimic-pin0-press") {
            self.pinLayers[.pin0] = makeImageLayer(image:pinImage,
                                                   origin: CGPoint(x: 12.5, y: 221.0),
                                                   hitLayerName: "pin0")
        }
        if let pinImage = UIImage(named: "mimic-pin1-press") {
            self.pinLayers[.pin1] = makeImageLayer(image:pinImage,
                                                   origin: CGPoint(x: 83.5, y: 221.0),
                                                   hitLayerName: "pin1")
        }
        if let pinImage = UIImage(named: "mimic-pin2-press") {
            self.pinLayers[.pin2] = makeImageLayer(image:pinImage,
                                                   origin: CGPoint(x: 163.0, y: 221.0),
                                                   hitLayerName: "pin2")
        }
        if let pinImage = UIImage(named: "mimic-pin-gnd-press") {
            self.pinLayers[.pinGND] = makeImageLayer(image:pinImage,
                                                     origin: CGPoint(x: 314.0, y: 221.0),
                                                     hitLayerName: "pinGND")
        }
    }
    
    func makeImageLayer(image: UIImage, origin: CGPoint, hitLayerName: String? = nil) -> CALayer {
        let layer = CALayer()
        layer.contents = image.cgImage
        let frameRect = CGRect(origin: origin, size: image.size)
        layer.frame = frameRect
        layer.isHidden = true
        self.mimicLayer.addSublayer(layer)
        
        if let layerName = hitLayerName {
            let hitLayer = CALayer()
            hitLayer.name = layerName
            hitLayer.frame = frameRect
            self.mimicLayer.addSublayer(hitLayer)
        }
        
        return layer
    }
    
    public override var canBecomeFirstResponder: Bool {
        get {
            return self.isActive
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        get {
            return mimicImage != nil ? mimicImage!.size : CGSize.zero
        }
    }
    
    // MARK: - General Functions & Accessors
    
    var accelerometerPeriod: BTMicrobit.AccelerometerPeriod? {
        get {
            return BTMicrobit.AccelerometerPeriod(rawValue: Int(self.motionManager.accelerometerUpdateInterval * 1000))
        }
        set {
            if newValue != nil {
                self.motionManager.accelerometerUpdateInterval = Double(newValue!.rawValue) / 1000.0
            }
        }
    }
    
    var lowPassFilterConstant: Double {
        get {
            let updateInterval = self.motionManager.accelerometerUpdateInterval
            let RC = max(updateInterval, 0.2) 
            return updateInterval / (updateInterval + RC)
        }
    }
    
    public func addAccelerometerHandler(_ handler: @escaping MimicAccelerometerHandler) {
        if self.isActive {
            self.addHandler(handler, forType: .accelerometer)
            self.startAccelerometer()
        }
    }
    
    func startAccelerometer() {
        
        if self.isActive && !self.motionManager.isAccelerometerActive {
            
            //UIDevice.current.beginGeneratingDeviceOrientationNotifications() // These don't work
            self.gestureEventCount = 0
            self.motionManager.startAccelerometerUpdates(to: OperationQueue(),
                                                         withHandler: {(accelerometerData, error) in
                                                            if (error != nil) {
                                                                self.stopAccelerometer()
                                                            } else if accelerometerData != nil {
                                                                var accelerometerValues = AccelerometerValues(accelerometerData!.acceleration)
                                                                
                                                                /*DispatchQueue.main.async {
                                                                 self.messageLogger?.logMessage("\(self.orientation.isLandscape)")
                                                                 }*/
                                                                
                                                                // orientation is currently only .landscapeLeft and .portrait
                                                                switch self.orientation {
                                                                    
                                                                case .portrait:
                                                                    let x = accelerometerValues.x
                                                                    accelerometerValues.x = accelerometerValues.y
                                                                    accelerometerValues.y = x
                                                                    
                                                                case .landscapeLeft:
                                                                    accelerometerValues.y = -accelerometerValues.y
                                                                    
                                                                default:
                                                                    break
                                                                }
                                                                
                                                                self.accelerometerValues = accelerometerValues
                                                                
                                                                if let handlers = self.handlersForType(.accelerometer) {
                                                                    for case let (handlerUUID, handler as MimicAccelerometerHandler) in handlers {
                                                                        let notificationAction = handler(accelerometerValues)
                                                                        if notificationAction == .stopNotifications {
                                                                            self.removeHandlerWithUUID(handlerUUID, forType: .accelerometer)
                                                                            if handlers.count == 1 {
                                                                                self.stopAccelerometer()
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
            })
        }
    }
    
    func stopAccelerometer() {
        if self.motionManager.isAccelerometerActive {
            self.motionManager.stopAccelerometerUpdates()
            //UIDevice.current.endGeneratingDeviceOrientationNotifications() // These don't work
        }
    }
    
    public override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake && self.isActive {
            self.delegate?.microbitMimic(self, didGenerateEvent: BTMicrobit.Event(.shake))
        }
    }
    
    public func showButtonAPressed(_ flag: Bool) {
        self.buttonALayer.opacity = flag ? 1.0 : 0.0
    }
    
    public func showButtonBPressed(_ flag: Bool) {
        self.buttonBLayer.opacity = flag ? 1.0 : 0.0
    }
    
    public func showPin(_ pin: BTMicrobit.Pin, touched flag: Bool) {
        if let pinLayer = self.pinLayers[pin], pinLayer.isHidden == flag {
            pinLayer.isHidden = !flag
        }
    }
    
    func pinIsTouched(_ pin: BTMicrobit.Pin) -> Bool {
        if let pinLayer = self.pinLayers[pin] {
            return !pinLayer.isHidden
        }
        return false
    }
    
    public func scrollText(_ text: String) {
        
        self.microbitImage = MicrobitImage()
        
        if text.count > 0 {
            DispatchQueue.global().async {
                usleep(UInt32(self.scrollingDelay) * 1_000) // Extra delay to get display in sync with micro:bit
                let microbitImages = text.microbitImages
                for scrollIndex in microbitImages.scrollStartIndex()...microbitImages.scrollEndIndex(withSpacing: 1) {
                    
                    usleep(UInt32(self.scrollingDelay) * 1_000)
                    self.microbitImage = microbitImages.imageAtScrollIndex(scrollIndex, withSpacing: 1)
                }
            }
        }
    }
    
    // MARK: - Handle Touches
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if self.isActive {
            for touch in touches {
                let touchPoint = touch.location(in: self)
                let layerPoint = self.mimicLayer.convert(touchPoint, from: self.layer)
                //messageLogger?.logMessage("Point: \(layerPoint)")
                
                if let layer = self.mimicLayer.hitTest(layerPoint), let layerName = layer.name {
                    //messageLogger?.logMessage("touch began: \(layerName)")
                    touchesMap[touch] = layer // Note: we're only storing layers with names
                    
                    self.setLayerWithName(layerName, touched: true)
                    
                    if self.pinIsTouched(.pinGND) {
                        switch layerName {
                            
                        case "pin0":
                            self.sendValue(0x0F, forPin: .pin0)
                            
                        case "pin1":
                            self.sendValue(0x0F, forPin: .pin1)
                            
                        case "pin2":
                            self.sendValue(0x0F, forPin: .pin2)
                            
                        default:
                            break
                        }
                    }
                }
            }
        }
        //super.touchesBegan(touches, with: event)
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if self.isActive {
            for touch in touches {
                let touchPoint = touch.location(in: self)
                let layerPoint = self.mimicLayer.convert(touchPoint, from: self.layer)
                
                if let hitLayer = self.mimicLayer.hitTest(layerPoint), let touchLayer = touchesMap[touch] {
                    let touched = hitLayer == touchLayer
                    self.setLayerWithName(touchLayer.name!, touched: touched)
                    //messageLogger?.logMessage("touch moved: \(touchLayer.name!) touched: \(touched)")
                    let pinValue: UInt8 = touched && self.pinIsTouched(.pinGND) ? 0x0F : 0x00
                    switch touchLayer.name! {
                        
                    case "pin0":
                        self.sendValue(pinValue, forPin: .pin0)
                        
                    case "pin1":
                        self.sendValue(pinValue, forPin: .pin1)
                        
                    case "pin2":
                        self.sendValue(pinValue, forPin: .pin2)
                        
                    default:
                        break
                    }
                }
            }
        }
        //super.touchesMoved(touches, with: event)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if self.isActive {
            
            for touch in touches {
                if let layer = touchesMap[touch] {
                    touchesMap[touch] = nil
                    if let layerName = layer.name {
                        //messageLogger?.logMessage("touch ended: \(layerName)")
                        
                        switch layerName {
                            
                        case "buttonA":
                            if self.buttonBLayer.opacity == 1 {
                                self.delegate?.microbitMimic(self, didGenerateEvent: BTMicrobit.Event(button: .AB, buttonEvent: .click))
                                self.setLayerWithName("buttonB", touched: false)
                            } else if self.buttonALayer.opacity == 1 {
                                self.delegate?.microbitMimic(self, didGenerateEvent: BTMicrobit.Event(button: .A, buttonEvent: .click))
                            }
                            
                        case "buttonB":
                            if self.buttonALayer.opacity == 1 {
                                self.delegate?.microbitMimic(self, didGenerateEvent: BTMicrobit.Event(button: .AB, buttonEvent: .click))
                                self.setLayerWithName("buttonA", touched: false)
                            } else if self.buttonBLayer.opacity == 1 {
                                self.delegate?.microbitMimic(self, didGenerateEvent: BTMicrobit.Event(button: .B, buttonEvent: .click))
                            }
                            
                        case "pin0":
                            self.sendValue(0x00, forPin: .pin0)
                            
                        case "pin1":
                            self.sendValue(0x00, forPin: .pin1)
                            
                        case "pin2":
                            self.sendValue(0x00, forPin: .pin2)
                            
                        default:
                            break
                        }
                        self.setLayerWithName(layerName, touched: false) // Need to do this here as it's used for testing the button presses.
                    }
                }
            }
        }
        //super.touchesEnded(touches, with: event)
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            if let layer = touchesMap[touch] {
                if let layerName = layer.name {
                    //messageLogger?.logMessage("touches cancelled: \(layerName)")
                    self.setLayerWithName(layerName, touched: false)
                }
                touchesMap[touch] = nil
            }
        }
        //super.touchesCancelled(touches, with: event)
    }
    
    func setLayerWithName(_ layerName: String, touched: Bool) {
        
        switch layerName {
        case "buttonA":
            self.showButtonAPressed(touched)
            
        case "buttonB":
            self.showButtonBPressed(touched)
            
        case "pin0":
            self.showPin(.pin0, touched: touched)
            
        case "pin1":
            self.showPin(.pin1, touched: touched)
            
        case "pin2":
            self.showPin(.pin2, touched: touched)
            
        case "pinGND":
            self.showPin(.pinGND, touched: touched)
            
        default:
            break
        }
    }
    
    func clearAllTouches() {
        
        //messageLogger?.logMessage("clearing all touches")
        self.touchesMap.removeAll(keepingCapacity: true)
        self.showButtonAPressed(false)
        self.showButtonBPressed(false)
        self.showPin(.pin0, touched: false)
        self.showPin(.pin1, touched: false)
        self.showPin(.pin2, touched: false)
        self.showPin(.pinGND, touched: false)
        if self.isActive {
            for pin in 0...2 {
                let data = Data(bytes: [UInt8(pin), 0x00])
                self.delegate?.microbitMimic(self, didGenerateData: data,
                                             forCharacteristicUUID: .pinDataUUID)
            }
        }
    }
    
    func sendValue(_ pinValue: UInt8, forPin pin: BTMicrobit.Pin) {
        let data = Data(bytes: [UInt8(pin.rawValue), pinValue])
        self.delegate?.microbitMimic(self, didGenerateData:data,
                                     forCharacteristicUUID: .pinDataUUID)
    }
    
    //MARK: - Microbit Mimic Handlers
    
    func addHandler(_ handler: Any,
                    forType handlerType: MicrobitMimic.HandlerType) {
        
        var mutDictionary = self.handlersForType(handlerType)
        
        if (mutDictionary == nil) {
            mutDictionary = Dictionary<UUID, Any>()
        }
        
        self.isolationQueue.async {
            mutDictionary![UUID()] = handler
            self.handlers[handlerType] = mutDictionary
        }
        self.isolationQueue.sync {}
        //self.messageLogger?.logMessage("Adding handler: \(self.handlers)")
    }
    
    
    func removeHandlerWithUUID(_ handlerUUID: UUID,
                               forType handlerType: MicrobitMimic.HandlerType) {
        
        self.isolationQueue.async {
            if var handlers = self.handlers[handlerType] {
                handlers[handlerUUID] = nil
                self.handlers[handlerType] = handlers
            }
        }
        self.isolationQueue.sync {}
        //self.messageLogger?.logMessage("Removing handler: \(self.handlers)")
    }
    
    func handlersForType(_ handlerType: MicrobitMimic.HandlerType) -> Dictionary<UUID, Any>? {
        
        var mutDictionary: Dictionary<UUID, Any>?
        self.isolationQueue.sync() {
            mutDictionary = self.handlers[handlerType]
        }
        
        return mutDictionary
    }
    
    public func clearHandlers() {
        self.isolationQueue.async {
            self.handlers.removeAll(keepingCapacity: true)
        }
        self.isolationQueue.sync {}
    }
    
    public func resetInterface() {
        self.microbitImage = MicrobitImage()
        self.clearAllTouches()
    }
}

//MARK: - MicrobitMimicDelegate

public protocol MicrobitMimicDelegate: AnyObject {
    
    func microbitMimic(_ microbitMimic: MicrobitMimic, didGenerateEvent event: BTMicrobit.Event)
    
    func microbitMimic(_ microbitMimic: MicrobitMimic, didGenerateData data: Data,
                       forCharacteristicUUID characteristicUUID: BTMicrobit.CharacteristicUUID)
}
