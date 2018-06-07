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

public class ContentMessenger: PlaygroundRemoteLiveViewProxyDelegate {
    
    public static let messenger = ContentMessenger()
    var handlers = [Set<AnyHashable>: Array<Any>]()
    
    public init() {
        
        let proxy = PlaygroundPage.current.liveView as! PlaygroundRemoteLiveViewProxy
        proxy.delegate = self
    }
    
    public func remoteLiveViewProxy(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy, received message: PlaygroundValue) {
        
        //print("message received from live view: \(message)")
        if let data = message.data {
            
            var handlerKey: Set<AnyHashable> = []
            
            if let actionType = message.actionType {
                _ = handlerKey.insert(actionType)
                if actionType == .requestEvent, let event = BTMicrobit.Event(data) {
                    _ = handlerKey.insert(event)
                }
            }
            
            if let characteristicUUID = message.characteristicUUID {
                _ = handlerKey.insert(characteristicUUID)
            }
            
            callHandlers(handlers[handlerKey], data: data, error: nil)
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
                    
                case let handler as ReadValueHandler:
                    
                    handler(data.integerFromLittleUInt16, error)
                    
                case let handler as ReadButtonStateHandler:
                    
                    var buttonState: BTMicrobit.ButtonState?
                    buttonState = BTMicrobit.ButtonState(rawValue: data[0])
                    handler(buttonState, error)
                    
                case let handler as ReadAccelerometerHandler:
                    
                    break
                    //self.accelerometerValues.setValuesFromMicrobitData(data)
                    //handler(self.accelerometerValues, error)
                    
                case let handler as ReadPinIOHandler:
                    
                    break
                    /*for index in stride(from: 0, to: data.count, by: 2) {
                     self.pinIOValues[Int(data[index])] = Int(data[index + 1])
                     }
                     handler(self.pinIOValues, error)*/
                    
                case let handler as ReadImageHandler:
                    
                    let image = MicrobitImage(data)
                    handler(image, nil)
                    
                default:
                    print("No handler type for \(handler)")
                }
            }
        }
    }
    
    public func remoteLiveViewProxyConnectionClosed(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy) {
        
        handlers.removeAll(keepingCapacity: true)
        // Finish the user process if LiveView process closed.
        PlaygroundPage.current.finishExecution()
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
        
        let message = PlaygroundValue.fromActionType(actionType,
                                                     characteristicUUID: characteristicUUID,
                                                     data: data)
        let proxy = PlaygroundPage.current.liveView as! PlaygroundRemoteLiveViewProxy
        proxy.send(message)
    }
    
    public func addHandler(_ handler: Any,
                           forCharacteristicUUID characteristicUUID: BTMicrobit.CharacteristicUUID? = nil,
                           actionType: ActionType,
                           event: BTMicrobit.Event? = nil) {
        
        let page = PlaygroundPage.current
        page.needsIndefiniteExecution = true
        
        var handlerKey: Set<AnyHashable> = [actionType]
        
        if (characteristicUUID != nil) {
            _ = handlerKey.insert(characteristicUUID!)
        }
        
        if event != nil {
            _ = handlerKey.insert(event!)
        }
        var mutHandlers = handlers[handlerKey]
        
        if (mutHandlers == nil) {
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
    }
}
