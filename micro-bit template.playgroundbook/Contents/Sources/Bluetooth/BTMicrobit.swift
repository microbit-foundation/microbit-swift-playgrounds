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

public typealias EventHandler = () -> Void
public typealias ReadValueHandler = (Int?, Error?) -> Void
public typealias ReadButtonStateHandler = (BTMicrobit.ButtonState?, Error?) -> Void
public typealias ReadImageHandler = (MicrobitImage?, Error?) -> Void
public typealias DisplayTextHandler = (Error?) -> Void
public typealias ReadAccelerometerHandler = (AccelerometerValues?, Error?) -> Void
public typealias ReadPinIOHandler = ([Int]?, Error?) -> Void

public class BTMicrobit: BTPeripheral {
    
    var requiredEvents: Set<BTMicrobit.Event> = []
    
    // MARK: - Microbit Types
    public enum Button: UInt16 {
        case A = 1
        case B = 2
        case AB = 26
    }
    
    public enum ButtonState: UInt8 {
        case notPressed = 0
        case pressed = 1
        case longPress = 2
        
        public init?(_ data: Data) {
            guard data.count >= 1 else { return nil }
            guard let buttonState = BTMicrobit.ButtonState(rawValue: data[0]) else { return nil }
            self = buttonState
        }
    }
    
    // MARK: - General Read Write Functions
    public func readValueForCharacteristic(_ characteristicUUID: CharacteristicUUID, handler: @escaping ReadCharacteristicHandler) {
        
        self.readValueFor(serviceUUIDString: characteristicUUID.serviceUUID.rawValue,
                          characteristicUUIDString: characteristicUUID.rawValue,
                          handler: handler)
    }
    
    public func writeValue(_ dataValue: Data,
                           forCharacteristicUUID characteristicUUID: BTMicrobit.CharacteristicUUID,
                           handler: @escaping ReadCharacteristicHandler) {
        
        self.writeValue(dataValue,
                        serviceUUIDString: characteristicUUID.serviceUUID.rawValue,
                        characteristicUUIDString: characteristicUUID.rawValue,
                        handler: handler)
        
    }
    
    public func setNotifyValue(_ enabled: Bool,
                               forCharacteristicUUID characteristicUUID: BTMicrobit.CharacteristicUUID,
                               handler: ReadCharacteristicHandler? = nil) {
        
        self.setNotifyValue(enabled,
                            serviceUUIDString: characteristicUUID.serviceUUID.rawValue,
                            characteristicUUIDString: characteristicUUID.rawValue,
                            handler: handler)
    }
    
    // MARK: - LED Functions
    public func displayText(_ text: String, handler: DisplayTextHandler?) {
        
        self.writeValue(text.microbitData,
                        forCharacteristicUUID: .ledTextUUID,
                        handler: {
                            (characteristic: CBCharacteristic, handlerType, error: Error?) in
        })
    }
    
    public func showImage(_ image: MicrobitImage, handler: ReadImageHandler?) {
        
        self.writeValue(image.imageData,
                        forCharacteristicUUID: .ledStateUUID,
                        handler: {
                            (characteristic: CBCharacteristic, handlerType, error: Error?) in
        })
    }
    
    public func readScrollingDelay(handler: ReadValueHandler) {
        self.readValueForCharacteristic(.ledScrollingDelayUUID,
                                        handler: {
                                            (characteristic: CBCharacteristic, handlerType, error: Error?) in
        })
    }
    
    public func setScrollingDelay(_ delay: Int, handler: ReadValueHandler) {
        
        let data = Data.littleEndianUInt16FromInt(delay)
        self.writeValue(data,
                        forCharacteristicUUID: .ledScrollingDelayUUID,
                        handler: {
                            (characteristic: CBCharacteristic, handlerType, error: Error?) in
        })
    }
    
    // MARK: - Button Functions
    
    public func readButtonState(button: Button, handler: ReadButtonStateHandler) {
        
        let characteristicUUID: BTMicrobit.CharacteristicUUID = button == .A ? .buttonStateAUUID : .buttonStateBUUID
        self.readValueForCharacteristic(characteristicUUID,
                                        handler: {
                                            (characteristic: CBCharacteristic, handlerType, error: Error?) in
        })
    }
    
    public func setNotifyValue(_ enabled: Bool, forButton button: Button, handler: ReadButtonStateHandler) {
        
        let characteristicUUID: BTMicrobit.CharacteristicUUID = button == .A ? .buttonStateAUUID : .buttonStateBUUID
        self.setNotifyValue(enabled,
                            forCharacteristicUUID: characteristicUUID,
                            handler: {
                                (characteristic: CBCharacteristic, handlerType, error: Error?) in
        })
    }
    
    // MARK: - Accelerometer Functions
    
    public func readAccelerometerPeriod(handler: ReadValueHandler) {
        
        self.readValueForCharacteristic(.accelerometerPeriodUUID,
                                        handler: {
                                            (characteristic: CBCharacteristic, handlerType, error: Error?) in
        })
    }
    
    public func setAccelerometerPeriod(_ period: Int, handler: ReadValueHandler) {
        
        let data = Data.littleEndianUInt16FromInt(period)
        self.writeValue(data,
                        forCharacteristicUUID: .accelerometerPeriodUUID,
                        handler: {
                            (characteristic: CBCharacteristic, handlerType, error: Error?) in
        })
    }
    
    public func setNotifyValueForAccelerometer(_ enabled: Bool, handler: ReadAccelerometerHandler) {
        
        self.setNotifyValue(enabled,
                            forCharacteristicUUID: .accelerometerDataUUID,
                            handler: {
                                (characteristic: CBCharacteristic, handlerType, error: Error?) in
        })
    }
    
    // MARK: - Magnetometer Functions
    
    public func readMagnetometerPeriod(handler: ReadValueHandler) {
        
        self.readValueForCharacteristic(.magnetometerPeriodUUID,
                                        handler: {
                                            (characteristic: CBCharacteristic, handlerType, error: Error?) in
        })
    }
    
    public func setMagnetometerPeriod(_ period: Int, handler: ReadValueHandler) {
        
        let data = Data.littleEndianUInt16FromInt(period)
        self.writeValue(data,
                        forCharacteristicUUID: .magnetometerPeriodUUID,
                        handler: {
                            (characteristic: CBCharacteristic, handlerType, error: Error?) in
        })
    }
    
    public func setNotifyValueForMagnetometerBearing(_ enabled: Bool, handler: ReadValueHandler) {
        
        self.setNotifyValue(enabled,
                            forCharacteristicUUID: .magnetometerBearingUUID,
                            handler: {
                                (characteristic: CBCharacteristic, handlerType, error: Error?) in
        })
    }
    
    // MARK: - Pin IO Functions
    
    public func readPinADConfiguration(handler: ReadValueHandler) {
        
        self.readValueForCharacteristic(.pinADConfigurationUUID,
                                        handler: {
                                            (characteristic: CBCharacteristic, handlerType, error: Error?) in
        })
    }
    
    public func setPinADConfiguration(_ pinConfiguration: Int, handler: ReadValueHandler) {
        
        let data = Data.littleEndianUInt16FromInt(pinConfiguration)
        self.writeValue(data,
                        forCharacteristicUUID: .pinADConfigurationUUID,
                        handler: {
                            (characteristic: CBCharacteristic, handlerType, error: Error?) in
        })
    }
    
    public func readPinIOConfiguration(handler: ReadValueHandler) {
        
        self.readValueForCharacteristic(.pinIOConfigurationUUID,
                                        handler: {
                                            (characteristic: CBCharacteristic, handlerType, error: Error?) in
        })
    }
    
    public func setPinIOConfiguration(_ pinConfiguration: Int, handler: ReadValueHandler) {
        
        let data = Data.littleEndianUInt16FromInt(pinConfiguration)
        self.writeValue(data,
                        forCharacteristicUUID: .pinIOConfigurationUUID,
                        handler: {
                            (characteristic: CBCharacteristic, handlerType, error: Error?) in
        })
    }
    
    public func setNotifyValueForPinIO(_ enabled: Bool, handler: ReadPinIOHandler) {
        
        self.setNotifyValue(enabled,
                            forCharacteristicUUID: .pinDataUUID,
                            handler: {
                                (characteristic: CBCharacteristic, handlerType, error: Error?) in
        })
    }
    
    /*
     
     OLD HANDLER STUFF - now required in here
     
     switch handler {
     
     case let handler as ReadCharacteristicHandler:
     
     
     
     case let handler as ReadValueHandler:
     
     handler(characteristic.value != nil ? characteristic.value!.integerFromLittleUInt16 : nil as Int? , error)
     
     case let handler as ReadButtonStateHandler:
     
     var buttonState: BTMicrobit.ButtonState?
     if (characteristic.value != nil) {
     buttonState = BTMicrobit.ButtonState(rawValue: characteristic.value![0])
     }
     handler(buttonState, error)
     
     case let handler as ReadAccelerometerHandler:
     if (characteristic.value != nil) {
     let accelerometerValues = AccelerometerValues(data: characteristic.value!)
     handler(accelerometerValues, error)
     } else {
     handler(nil, error)
     }
     
     case let handler as ReadPinIOHandler:
     
     if let data = characteristic.value {
     for index in stride(from: 0, to: data.count, by: 2) {
     self.pinIOValues[Int(data[index])] = Int(data[index + 1])
     }
     handler(self.pinIOValues, error)
     } else {
     handler(nil, error)
     }
     
     case let handler as ReadImageHandler:
     
     if let data = characteristic.value {
     
     let image = MicrobitImage.init(data)
     handler(image, nil)
     } else {
     handler(nil, error)
     }
     
     default:
     print("No handler type for \(handler)")
     }
     
     }
     }
     
     */
    
    // MARK: - Event Functions
    
    public func addEvent(_ event: BTMicrobit.Event,
                         handler: @escaping ReadCharacteristicHandler) {
        
        if requiredEvents.insert(event).inserted  {
            let eventsData = requiredEvents.reduce(into: Data(), {data, event in
                data.append(event.microbitData)
            })
            self.messageLogger?.logMessage("requiredEvents: \(eventsData as NSData)")
            self.writeValue(eventsData,
                            forCharacteristicUUID: .eventClientRequirementsUUID,
                            handler: handler)
        }
    }
    
    // Removing Events does not work - the micro:bit continues to send events even when they are not written to the characteristic
    /*
     public func removeEvent(_ event: BTMicrobit.Event,
     handler: ReadCharacteristicHandler? = nil) {
     
     if requiredEvents.remove(event) != nil {
     let eventsData = requiredEvents.reduce(into: Data(), {data, event in
     data.append(event.microbitData)
     })
     self.writeValue(eventsData,
     serviceUUID: .eventUUID,
     characteristicUUID: .eventClientRequirementsUUID,
     handler: handler)
     }
     }*/
    
    public func setNotifyValueForMicrobitEvent(_ enabled: Bool, handler: ReadCharacteristicHandler? = nil) {
        
        self.setNotifyValue(enabled,
                            forCharacteristicUUID: .eventMicrobitEventUUID,
                            handler: handler)
    }
}
