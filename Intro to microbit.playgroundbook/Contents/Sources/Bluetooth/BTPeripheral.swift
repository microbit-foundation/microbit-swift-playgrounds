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
import CoreBluetooth

typealias GetServiceHandler = (CBService?, Error?) -> Void
typealias GetCharacteristicHandler = (CBCharacteristic?, Error?) -> Void

public typealias ReadCharacteristicHandler = (CBCharacteristic, BTPeripheral.HandlerType, Error?) -> Void

public class BTPeripheral: NSObject, CBPeripheralDelegate {
    
    public enum HandlerType {
        case discoveryHandler
        case characteristicReadHandler
        case characteristicNotifyHandler
    }
    
    internal (set) var peripheral: CBPeripheral!
    let isolationQueue = DispatchQueue(label: "org.microbit.peripheralHandlersQueue")
    var handlers = [BTPeripheral.HandlerType: [String: Array<Any>]]()
    var pinIOValues = Array.init(repeating: 0, count: 20)
    public weak var messageLogger: BTManagerDelegate?
    
    public init(peripheral: CBPeripheral) {
        
        super.init()
        
        self.peripheral = peripheral
        self.peripheral.delegate = self
        
        self.handlers = [.discoveryHandler: [String: Array<Any>](),
                         .characteristicReadHandler: [String: Array<Any>](),
                         .characteristicNotifyHandler: [String: Array<Any>]()]
    }
    
    //MARK: - CBPeripheral Delegate Functions
    
    public func peripheral(_ peripheral: CBPeripheral,
                           didDiscoverServices error: Error?) {
        
        if let error = error {
            self.messageLogger?.logMessage("[DEBUG] error discovering services: \(error)")
            return
        }
        
        if let services = peripheral.services {
            for service in services {
                
                //self.messageLogger?.logMessage ("[DEBUG] discovered service: \(service)")
                //print ("discovery handlers \(self.discoveryHandler)")
                if let handlers = self.handlersWithUUID(service.uuid.uuidString,
                                                        forType: .discoveryHandler) {
                    self.removeHandlersWithUUID(service.uuid.uuidString,
                                                forType: .discoveryHandler)
                    
                    for handler in handlers {
                        if let serviceHandler = handler as? GetServiceHandler {
                            serviceHandler(service, error)
                        }
                    }
                }
            }
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral,
                           didDiscoverCharacteristicsFor service: CBService,
                           error: Error?) {
        
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                
                //self.messageLogger?.logMessage ("[DEBUG] Discovered characteristic: \(characteristic)")
                if let handlers = self.handlersWithUUID(characteristic.uuid.uuidString,
                                                        forType: .discoveryHandler) {
                    self.removeHandlersWithUUID(characteristic.uuid.uuidString,
                                                forType: .discoveryHandler)
                    for handler in handlers {
                        if let characteristicHandler = handler as? GetCharacteristicHandler {
                            characteristicHandler(characteristic, error)
                        }
                    }
                }
            }
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral,
                           didUpdateValueFor characteristic: CBCharacteristic,
                           error: Error?) {
        
        let uuidString = characteristic.uuid.uuidString
        
        //self.messageLogger?.logMessage("characteristic: \(characteristic) did update value: \(characteristic.value!)")
        
        if let handlers = self.handlersWithUUID(uuidString, forType: .characteristicReadHandler) {
            for case let handler as ReadCharacteristicHandler in handlers {
                handler(characteristic, .characteristicReadHandler, error)
            }
        }
        
        if let handlers = self.handlersWithUUID(uuidString, forType: .characteristicNotifyHandler) {
            for case let handler as ReadCharacteristicHandler in handlers {
                handler(characteristic, .characteristicNotifyHandler, error)
            }
        }
        
        self.removeHandlersWithUUID(uuidString,
                                    forType: .characteristicReadHandler)
    }
    
    public func peripheral(_ peripheral: CBPeripheral,
                           didWriteValueFor characteristic: CBCharacteristic,
                           error: Error?) {
        
        if let handlers = self.handlersWithUUID(characteristic.uuid.uuidString,
                                                forType: .characteristicReadHandler) {
            if (error == nil) {
                // TODO: - Cannot read value for all characteristics so need a check here
                peripheral.readValue(for: characteristic)
            } else {
                print("[DEBUG] error writing value \(error!)")
                for handler in handlers {
                    if let dataHandler = handler as? ReadCharacteristicHandler {
                        dataHandler(characteristic, .characteristicReadHandler, error)
                    }
                }
            }
        }
    }
    
    //MARK: - Internal Discovery Functions
    
    func serviceWithUUIDString(_ serviceUUIDString: String,
                               handler: @escaping GetServiceHandler) {
        
        var serviceFound = false;
        if let services = self.peripheral.services {
            for service in services {
                if service.uuid.uuidString == serviceUUIDString {
                    serviceFound = true
                    handler(service, nil)
                    return
                }
            }
        }
        
        if !serviceFound {
            //self.messageLogger?.logMessage("Service not found")
            self.addHandlerWithUUID(serviceUUIDString,
                                    handler: handler,
                                    forType: .discoveryHandler)
            //self.messageLogger?.logMessage("handler \(handler)")
            //self.messageLogger?.logMessage("handlers \(self.handlers)")
            let cbUUID = CBUUID(string: serviceUUIDString)
            self.peripheral.discoverServices([cbUUID])
        }
    }
    
    func characteristicWithUUIDString(_ characteristicUUIDString: String,
                                      service: CBService,
                                      handler: @escaping GetCharacteristicHandler) {
        
        var characteristicFound = false;
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid.uuidString == characteristicUUIDString {
                    characteristicFound = true
                    handler(characteristic, nil)
                    return
                }
            }
        }
        
        if !characteristicFound {
            self.addHandlerWithUUID(characteristicUUIDString,
                                    handler: handler,
                                    forType: .discoveryHandler)
            let cbUUID = CBUUID(string: characteristicUUIDString)
            self.peripheral.discoverCharacteristics([cbUUID], for:service)
        }
    }
    
    //MARK: - Public Read/Write/Notify Functions
    
    public func readValueFor(serviceUUIDString: String,
                             characteristicUUIDString: String,
                             handler: @escaping ReadCharacteristicHandler) {
        
        self.serviceWithUUIDString(serviceUUIDString,
                                   handler: {
                                    (service: CBService?, error: Error?) in
                                    if service != nil {
                                        self.characteristicWithUUIDString(characteristicUUIDString,
                                                                          service: service!,
                                                                          handler: {
                                                                            (characteristic: CBCharacteristic?, error: Error?) in
                                                                            if let validCharacteristic = characteristic {
                                                                                self.messageLogger?.logMessage("Characteristic: \(validCharacteristic)")
                                                                                self.addHandlerWithUUID(validCharacteristic.uuid.uuidString,
                                                                                                        handler:handler, forType:.characteristicReadHandler)
                                                                                self.peripheral.readValue(for: validCharacteristic)
                                                                            }
                                        })
                                    } else {
                                        //handler(nil as Any?, error)
                                        if error != nil {
                                            print("Error retrieving service: \(error!)")
                                        }
                                    }
        })
    }
    
    public func writeValue(_ dataValue: Data,
                           serviceUUIDString: String,
                           characteristicUUIDString: String,
                           handler: @escaping ReadCharacteristicHandler) {
        
        self.messageLogger?.logMessage("writeValue: \(dataValue as NSData)")
        self.serviceWithUUIDString(serviceUUIDString,
                                   handler: {
                                    (service: CBService?, error: Error?) in
                                    if service != nil {
                                        self.characteristicWithUUIDString(characteristicUUIDString,
                                                                          service: service!,
                                                                          handler: {
                                                                            (characteristic: CBCharacteristic?, error: Error?) in
                                                                            if let validCharacteristic = characteristic {
                                                                                self.addHandlerWithUUID(validCharacteristic.uuid.uuidString,
                                                                                                        handler:handler, forType:.characteristicReadHandler)
                                                                                
                                                                                //self.messageLogger?.logMessage("writing dataValue: \(dataValue)")
                                                                                self.peripheral.writeValue(dataValue,
                                                                                                           for: validCharacteristic,
                                                                                                           type: .withResponse)
                                                                            }
                                        })
                                    } else {
                                        // FIXME: handler(nil as Any?, error)
                                    }
        })
    }
    
    public func setNotifyValue(_ enabled: Bool,
                               serviceUUIDString: String,
                               characteristicUUIDString: String,
                               handler: ReadCharacteristicHandler? = nil) {
        
        self.serviceWithUUIDString(serviceUUIDString,
                                   handler: {
                                    (service: CBService?, error: Error?) in
                                    if service != nil {
                                        self.characteristicWithUUIDString(characteristicUUIDString,
                                                                          service: service!,
                                                                          handler: {
                                                                            (characteristic: CBCharacteristic?, error: Error?) in
                                                                            if let validCharacteristic = characteristic {
                                                                                if enabled && handler != nil {
                                                                                    self.addHandlerWithUUID(validCharacteristic.uuid.uuidString,
                                                                                                            handler: handler!,
                                                                                                            forType: .characteristicNotifyHandler)
                                                                                    
                                                                                } else {
                                                                                    self.removeHandlersWithUUID(validCharacteristic.uuid.uuidString,
                                                                                                                forType: .characteristicNotifyHandler)
                                                                                }
                                                                                self.peripheral.setNotifyValue(enabled,
                                                                                                               for: validCharacteristic)
                                                                            }
                                        })
                                    } else {
                                        // FIXME: handler(nil, error)
                                    }
        })
    }
    
    //MARK: - Private Handler Storage
    
    func addHandlerWithUUID<HandlerType>(_ uuidKey: String,
                                         handler: (HandlerType),
                                         forType handlerTypeDictionary: BTPeripheral.HandlerType) {
        
        var mutBlocks = self.handlersWithUUID(uuidKey, forType: handlerTypeDictionary)
        
        if (mutBlocks == nil) {
            mutBlocks = Array<Any>()
        }
        
        self.isolationQueue.async {
            mutBlocks!.append(handler)
            self.handlers[handlerTypeDictionary]![uuidKey] = mutBlocks
        }
        self.isolationQueue.sync {}
        //self.messageLogger?.logMessage("Adding handler: \(self.handlers)")
    }
    
    func removeHandlersWithUUID(_ uuidKey: String,
                                forType handlerTypeDictionary: BTPeripheral.HandlerType) {
        
        self.isolationQueue.async {
            self.handlers[handlerTypeDictionary]![uuidKey] = nil
        }
        self.isolationQueue.sync {}
        //self.messageLogger?.logMessage("Removing handlers: \(self.handlers)")
    }
    
    func removeHandler(_ handler: Any,
                       uuidKey: String,
                       forType handlerTypeDictionary: BTPeripheral.HandlerType) {
        
        self.isolationQueue.async {
            var localDict = self.handlers[handlerTypeDictionary]
            if var handlers = localDict![uuidKey] {
                if let index = handlers.index(where: { $0 as AnyObject === handler as AnyObject}) {
                    handlers.remove(at: index)
                }
                self.handlers[handlerTypeDictionary]![uuidKey] = handlers
            }
        }
        self.isolationQueue.sync {}
        //self.messageLogger?.logMessage("Removing handler: \(self.handlers)")
    }
    
    func handlersWithUUID(_ uuidKey: String,
                          forType handlerTypeDictionary: BTPeripheral.HandlerType) -> Array<Any>? {
        
        var mutArray: Array<Any>?
        self.isolationQueue.sync() {
            mutArray = self.handlers[handlerTypeDictionary]![uuidKey]
        }
        
        return mutArray
    }
    
    public func clearHandlers() {
        self.handlers[.characteristicReadHandler]!.removeAll(keepingCapacity: true)
        self.handlers[.characteristicNotifyHandler]!.removeAll(keepingCapacity: true)
    }
}
