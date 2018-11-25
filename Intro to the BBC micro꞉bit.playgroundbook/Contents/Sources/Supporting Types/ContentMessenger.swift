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
import PlaygroundSupport

public typealias ReadAccelerometerHandler = (AccelerometerValues) -> Void
public typealias ReadTemperatureHandler = (Double) -> Void
public typealias ReadCompassHeadingHandler = (Double) -> Void
public typealias ReadPinIOHandler = (PinStore) -> Void

public class ContentMessenger: PlaygroundRemoteLiveViewProxyDelegate {
    
    public static let messenger = ContentMessenger()
    var handlers = [Set<AnyHashable>: Array<Any>]()
    var cachedMicrobitImage = MicrobitImage()
    
    public init() {
        
        let proxy = PlaygroundPage.current.liveView as! PlaygroundRemoteLiveViewProxy
        proxy.delegate = self
    }
    
    public func remoteLiveViewProxy(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy, received message: PlaygroundValue) {
        
        //sendLogMessage("message received from live view: \(message)")
        if let actionType = message.actionType {
            
            if (actionType == .connectionChanged) {
                self.finishExecution()
                return
            }
            
            if let data = message.data {
                
                var handlerKey: Set<AnyHashable> = []
                
                _ = handlerKey.insert(actionType)
                if actionType == .requestEvent, let event = BTMicrobit.Event(data) {
                    _ = handlerKey.insert(event)
                }
                
                if let characteristicUUID = message.characteristicUUID {
                    _ = handlerKey.insert(characteristicUUID)
                    if characteristicUUID == .ledStateUUID && actionType == .readData {
                        self.cachedMicrobitImage = MicrobitImage(data)
                    }
                }
                
                callHandlers(handlers[handlerKey], data: data, error: nil)
                
                if actionType == .readData || actionType == .writeData {
                    handlers[handlerKey] = nil
                }
            }
        }
    }
    
    func callHandlers(_ handlers: Array<Any>?,
                      data: Data,
                      error: Error?) {
        
        if (handlers != nil) {
            for handler in handlers! {
                
                switch handler {
                    
                case let handler as EventHandler:
                    handler()
                    
                case let handler as ReadButtonStateHandler:
                    if let buttonState = BTMicrobit.ButtonState(rawValue: data[0]) {
                        handler(buttonState)
                    }
                    
                case let handler as ReadAccelerometerPeriodHandler:
                    if let intPeriod = data.integerFromLittleUInt16,
                        let period = BTMicrobit.AccelerometerPeriod(rawValue: intPeriod) {
                        handler(period)
                    }
                    
                case let handler as ReadAccelerometerHandler:
                    if let accelerationValues = AccelerometerValues(data: data) {
                        handler(accelerationValues)
                    }
                    
                case let handler as ReadTemperaturePeriodHandler: // BEWARE - This will also catch other Int handlers
                    // case let handler as ReadPinConfigurationHandler: This also has an Int handler but the data is UInt32 not UInt16
                    switch data.count {
                    case 2:
                        if let value = data.integerFromLittleUInt16 {
                            handler(value)
                        }
                        
                    case 4:
                        if let value = data.integerFromLittleUInt32 {
                            handler(value)
                        }
                        
                    default:
                        break
                    }
                    
                case let handler as ReadTemperatureHandler: // This also handles the compass bearing
                    //case let handler as ReadCompassHeadingHandler:
                    switch data.count {
                    case 1:
                        let value = Double(data[0])
                        handler(value)
                        
                    case 2:
                        if let value = data.integerFromLittleUInt16 {
                            handler(Double(value))
                        }
                        
                    default:
                        break
                    }
                    
                case let handler as ReadMagnetometerPeriodHandler:
                    if let intPeriod = data.integerFromLittleUInt16,
                        let period = BTMicrobit.MagnetometerPeriod(rawValue: intPeriod) {
                        handler(period)
                    }
                    
                case let handler as ReadMagnetometerHandler:
                    if let magnetometerValues = MagnetometerValues(data: data) {
                        handler(magnetometerValues)
                    }
                                        
                case let handler as ReadPinIOHandler:
                    handler(data.pinStore)
                    
                case let handler as ReadImageHandler:
                    if data.count >= 5 {
                        handler(MicrobitImage(data))
                    } else {
                        handler(nil)
                    }
                    
                default:
                    sendLogMessage("No handler type for \(handler)")
                }
            }
        }
    }
    
    func finishExecution() {
        handlers.removeAll(keepingCapacity: true)
        // Finish the user process if LiveView process closed.
        PlaygroundPage.current.finishExecution()
    }
    
    public func remoteLiveViewProxyConnectionClosed(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy) {
        self.finishExecution()
    }
    
    public func sendMessageOfType(_ actionType: ActionType,
                                  forCharacteristicUUID characteristicUUID: BTMicrobit.CharacteristicUUID? = nil,
                                  withData data: Data? = nil,
                                  handler: Any? = nil) {
        
        if handler != nil {
            if actionType == .requestEvent {
                self.addHandler(handler!, actionType: actionType, event: BTMicrobit.Event(data!))
            } else {
                self.addHandler(handler!, forCharacteristicUUID: characteristicUUID, actionType: actionType)
            }
        }
        
        if characteristicUUID == .ledStateUUID && actionType == .writeData && data != nil {
            self.cachedMicrobitImage = MicrobitImage(data!)
        }
        
        let message = PlaygroundValue.fromActionType(actionType,
                                                     characteristicUUID: characteristicUUID,
                                                     data: data)
        let proxy = PlaygroundPage.current.liveView as! PlaygroundRemoteLiveViewProxy
        proxy.send(message)
    }
    
    public func sendLogMessage(_ message: String) {
        sendMessageOfType(.logMessage,
                          withData: Data(message.utf8))
    }
    
    //MARK: - Handler Functions
    
    func addHandler(_ handler: Any,
                    forCharacteristicUUID characteristicUUID: BTMicrobit.CharacteristicUUID? = nil,
                    actionType: ActionType,
                    event: BTMicrobit.Event? = nil) {
        
        let page = PlaygroundPage.current
        page.needsIndefiniteExecution = true
        
        var handlerKey: Set<AnyHashable> = [actionType]
        
        if characteristicUUID != nil {
            
            // Return the cached image synchronously with no message to be sent.
            if characteristicUUID == .ledStateUUID && actionType == .readData {
                if let handler = handler as? ReadImageHandler {
                    handler(self.cachedMicrobitImage)
                }
                return
            }
            
            _ = handlerKey.insert(characteristicUUID!)
        }
        
        if event != nil {
            _ = handlerKey.insert(event!)
        }
        var mutHandlers = handlers[handlerKey]
        
        if mutHandlers == nil {
            mutHandlers = [handler]
        } else {
            mutHandlers!.append(handler)
        }
        
        handlers[handlerKey] = mutHandlers
    }
    
    // MARK: - Bluetooth Action Types
    
    public enum ActionType: Int {
        case writeData
        case readData
        case startNotifications
        case stopNotifications
        case requestEvent
        case removeEvent
        case connectionChanged
        case shareData
        case logMessage
    }
}
