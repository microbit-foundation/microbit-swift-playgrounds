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
public typealias ReadScrollingDelayHandler = (Int?) -> Void
public typealias ReadButtonStateHandler = (BTMicrobit.ButtonState?) -> Void
public typealias NotifyButtonStateHandler = (BTMicrobit.ButtonState?) -> BTPeripheral.NotificationAction
public typealias ReadImageHandler = (MicrobitImage?) -> Void
public typealias ReadAccelerometerPeriodHandler = (BTMicrobit.AccelerometerPeriod?) -> Void
public typealias NotifyAccelerometerHandler = (AccelerometerValues?) -> BTPeripheral.NotificationAction
public typealias ReadTemperaturePeriodHandler = (Int?) -> Void
public typealias NotifyTemperatureHandler = (Double?) -> BTPeripheral.NotificationAction
public typealias ReadMagnetometerPeriodHandler = (BTMicrobit.MagnetometerPeriod?) -> Void
public typealias NotifyCompassHeadingHandler = (Double?) -> BTPeripheral.NotificationAction
public typealias ReadMagnetometerHandler = (MagnetometerValues?) -> Void
public typealias ReadPinConfigurationHandler = (PinConfigurationMask?) -> Void

public typealias PinStore = [BTMicrobit.Pin: Int]
public typealias PinConfigurationMask = Int
public typealias NotifyPinIOHandler = (PinStore) -> BTPeripheral.NotificationAction

/**
 The object that represents a micro:bit over Bluetooth. This class contains encapsulated enums for Button, ButtonState, Pin, AccelerometerPeriod and MagnetometerPeriod.
 */
public class BTMicrobit: BTPeripheral {
    
    var requiredEvents: Set<BTMicrobit.Event> = []
    
    // MARK: - Microbit Types
    /**
     An enum for representing the micro:bit's buttons. The cases are .A, .B and .AB
     */
    public enum Button: UInt16 {
        case A = 1
        case B = 2
        case AB = 26
    }
    
    /**
     An enum for representing the micro:bit's button states. The cases are .notPressed, .pressed and .longPress
     */
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
    
    /**
     An enum for representing the micro:bit's pins. The cases are .pin0, .pin1 upto .pin19
     */
    public enum Pin: Int {
        case pin0
        case pin1
        case pin2
        case pin3
        case pin4
        case pin5
        case pin6
        case pin7
        case pin8
        case pin9
        case pin10
        case pin11
        case pin12
        case pin13
        case pin14
        case pin15
        case pin16
        case pin17
        case pin18
        case pin19
        case pinGND = 1000
    }
    
    /**
     An enum for representing the micro:bit's accelerometer period values in milli-seconds. The cases are .ms1, .ms2, .ms5, .ms10, .ms20, .ms80, .ms160 and .ms640
     */
    public enum AccelerometerPeriod : Int {
        case ms1 = 1
        case ms2 = 2
        case ms5 = 5
        case ms10 = 10
        case ms20 = 20
        case ms80 = 80
        case ms160 = 160
        case ms640 = 640
    }
    
    /**
     An enum for representing the micro:bit's magnetometer period values in milli-seconds. The cases are .ms1, .ms2, .ms5, .ms10, .ms20, .ms80, .ms160 and .ms640
     */
    public enum MagnetometerPeriod : Int {
        case ms1 = 1
        case ms2 = 2
        case ms5 = 5
        case ms10 = 10
        case ms20 = 20
        case ms80 = 80
        case ms160 = 160
        case ms640 = 640
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
                               handler: NotifyCharacteristicHandler? = nil) {
        
        self.setNotifyValue(enabled,
                            serviceUUIDString: characteristicUUID.serviceUUID.rawValue,
                            characteristicUUIDString: characteristicUUID.rawValue,
                            handler: handler)
    }
    
    // MARK: - LED Functions
    public func displayText(_ text: String) {
        
        self.writeValue(text.microbitData,
                        forCharacteristicUUID: .ledTextUUID,
                        handler: {(characteristic: CBCharacteristic, error: Error?) in
                            // Is this handler ever called?
        })
    }
    
    public func readImage(handler: @escaping ReadImageHandler) {
        self.readValueForCharacteristic(.ledStateUUID,
                                        handler: {(characteristic: CBCharacteristic, error: Error?) in
                                            if let data = characteristic.value, data.count == 5 {
                                                handler(MicrobitImage(data))
                                            } else {
                                                handler(nil)
                                            }
        })
    }
    
    public func showImage(_ image: MicrobitImage, handler: ReadImageHandler? = nil) {
        
        self.writeValue(image.imageData,
                        forCharacteristicUUID: .ledStateUUID,
                        handler: {(characteristic: CBCharacteristic, error: Error?) in
                            if let handler = handler {
                                if let data = characteristic.value, data.count == 5 {
                                    handler(MicrobitImage(data))
                                } else {
                                    handler(nil)
                                }
                            }
        })
    }
    
    public func readScrollingDelay(handler: @escaping ReadScrollingDelayHandler) {
        self.readValueForCharacteristic(.ledScrollingDelayUUID,
                                        handler: {(characteristic: CBCharacteristic, error: Error?) in
                                            let delay = characteristic.value?.integerFromLittleUInt16
                                            handler(delay)
        })
    }
    
    public func setScrollingDelay(_ delay: Int, handler: ReadScrollingDelayHandler? = nil) {
        
        let data = Data.littleEndianUInt16FromInt(delay)
        self.writeValue(data,
                        forCharacteristicUUID: .ledScrollingDelayUUID,
                        handler: {(characteristic: CBCharacteristic, error: Error?) in
                            if let handler = handler {
                                let delay = characteristic.value?.integerFromLittleUInt16
                                handler(delay)
                            }
        })
    }
    
    // MARK: - Button Functions
    
    public func readButtonState(button: Button, handler: @escaping ReadButtonStateHandler) {
        
        let characteristicUUID: BTMicrobit.CharacteristicUUID = button == .A ? .buttonStateAUUID : .buttonStateBUUID
        self.readValueForCharacteristic(characteristicUUID,
                                        handler: {
                                            (characteristic: CBCharacteristic, error: Error?) in
                                            if let data = characteristic.value, data.count > 0 {
                                                let buttonState = BTMicrobit.ButtonState(rawValue: data[0])
                                                handler(buttonState)
                                            } else {
                                                handler(nil)
                                            }
        })
    }
    
    public func onButtonState(forButton button: Button, handler: @escaping NotifyButtonStateHandler) {
        
        let characteristicUUID: BTMicrobit.CharacteristicUUID = button == .A ? .buttonStateAUUID : .buttonStateBUUID
        self.setNotifyValue(true,
                            forCharacteristicUUID: characteristicUUID,
                            handler: {
                                (characteristic: CBCharacteristic, error: Error?) in
                                if let data = characteristic.value, data.count > 0 {
                                    let buttonState = BTMicrobit.ButtonState(rawValue: data[0])
                                    return handler(buttonState)
                                } else {
                                    return handler(nil)
                                }
        })
    }
    
    // MARK: - Accelerometer Functions
    
    public func readAccelerometerPeriod(handler: @escaping ReadAccelerometerPeriodHandler) {
        
        self.readValueForCharacteristic(.accelerometerPeriodUUID,
                                        handler: {(characteristic: CBCharacteristic, error: Error?) in
                                            if let intPeriod = characteristic.value?.integerFromLittleUInt16,
                                                let period = BTMicrobit.AccelerometerPeriod(rawValue: intPeriod) {
                                                handler(period)
                                            } else {
                                                handler(nil)
                                            }
        })
    }
    
    public func setAccelerometerPeriod(_ period: AccelerometerPeriod, handler: ReadAccelerometerPeriodHandler? = nil) {
        
        let data = Data.littleEndianUInt16FromInt(period.rawValue)
        self.writeValue(data,
                        forCharacteristicUUID: .accelerometerPeriodUUID,
                        handler: {(characteristic: CBCharacteristic, error: Error?) in
                            if let handler = handler {
                                if let intPeriod = characteristic.value?.integerFromLittleUInt16,
                                    let period = BTMicrobit.AccelerometerPeriod(rawValue: intPeriod) {
                                    handler(period)
                                } else {
                                    handler(nil)
                                }
                            }
        })
    }
    
    public func onAccelerometer(handler: @escaping NotifyAccelerometerHandler) {
        
        self.setNotifyValue(true,
                            forCharacteristicUUID: .accelerometerDataUUID,
                            handler: {(characteristic: CBCharacteristic, error: Error?) in
                                
                                if let data = characteristic.value, data.count > 5,
                                    let accelerationValues = AccelerometerValues(data: data) {
                                    return handler(accelerationValues)
                                } else {
                                    return handler(nil)
                                }
        })
    }
    
    // MARK: - Temperature Functions
    
    public func readTemperaturePeriod(handler: @escaping ReadTemperaturePeriodHandler) {
        
        self.readValueForCharacteristic(.temperaturePeriodUUID,
                                        handler: {(characteristic: CBCharacteristic, error: Error?) in
                                            
                                            let intPeriod = characteristic.value?.integerFromLittleUInt16
                                            handler(intPeriod)
        })
    }
    
    public func setTemperaturePeriod(_ period: Int, handler: ReadTemperaturePeriodHandler? = nil) {
        
        let data = Data.littleEndianUInt16FromInt(period)
        self.writeValue(data,
                        forCharacteristicUUID: .temperaturePeriodUUID,
                        handler: {(characteristic: CBCharacteristic, error: Error?) in
                            
                            if let handler = handler {
                                let intPeriod = characteristic.value?.integerFromLittleUInt16
                                handler(intPeriod)
                            }
        })
    }
    
    public func onTemperature(handler: @escaping NotifyTemperatureHandler) {
        
        self.setNotifyValue(true,
                            forCharacteristicUUID: .temperatureDataUUID,
                            handler: {(characteristic: CBCharacteristic, error: Error?) in
                                
                                if let data = characteristic.value, data.count > 0,
                                    let temperature = data.integerFromLittleInt8 {
                                    return handler(Double(temperature))
                                } else {
                                    return handler(nil)
                                }
        })
    }
    
    // MARK: - Magnetometer Functions
    
    public func readMagnetometerPeriod(handler: @escaping ReadMagnetometerPeriodHandler) {
        
        self.readValueForCharacteristic(.magnetometerPeriodUUID,
                                        handler: {(characteristic: CBCharacteristic, error: Error?) in
                                            if let intPeriod = characteristic.value?.integerFromLittleUInt16,
                                                let period = BTMicrobit.MagnetometerPeriod(rawValue: intPeriod) {
                                                handler(period)
                                            } else {
                                                handler(nil)
                                            }
        })
    }
    
    public func setMagnetometerPeriod(_ period: MagnetometerPeriod, handler: ReadMagnetometerPeriodHandler? = nil) {
        
        let data = Data.littleEndianUInt16FromInt(period.rawValue)
        self.writeValue(data,
                        forCharacteristicUUID: .magnetometerPeriodUUID,
                        handler: {(characteristic: CBCharacteristic, error: Error?) in
                            if let handler = handler {
                                if let intPeriod = characteristic.value?.integerFromLittleUInt16,
                                    let period = BTMicrobit.MagnetometerPeriod(rawValue: intPeriod) {
                                    handler(period)
                                } else {
                                    handler(nil)
                                }
                            }
        })
    }
    
    public func onMagnetometerBearing(handler: @escaping NotifyCompassHeadingHandler) {
        
        self.setNotifyValue(true,
                            forCharacteristicUUID: .magnetometerBearingUUID,
                            handler: {(characteristic: CBCharacteristic, error: Error?) in
                                
                                if let data = characteristic.value, data.count > 1,
                                    let heading = data.integerFromLittleUInt16 {
                                    return handler(Double(heading))
                                } else {
                                    return handler(nil)
                                }
        })
    }
    
    // MARK: - Pin IO Functions
    
    public func readPinADConfiguration(handler: @escaping ReadPinConfigurationHandler) {
        
        self.readValueForCharacteristic(.pinADConfigurationUUID,
                                        handler: {
                                            (characteristic: CBCharacteristic, error: Error?) in
                                            let bitMask = characteristic.value?.integerFromLittleUInt32
                                            handler(bitMask)
        })
    }
    
    public func setPinADConfiguration(_ pinConfiguration: PinConfigurationMask, handler: ReadPinConfigurationHandler? = nil) {
        
        let data = Data.littleEndianUInt16FromInt(pinConfiguration)
        self.writeValue(data,
                        forCharacteristicUUID: .pinADConfigurationUUID,
                        handler: {(characteristic: CBCharacteristic, error: Error?) in
                            if let handler = handler {
                                let bitMask = characteristic.value?.integerFromLittleUInt32
                                handler(bitMask)
                            }
        })
    }
    
    public func readPinIOConfiguration(handler: @escaping ReadPinConfigurationHandler) {
        
        self.readValueForCharacteristic(.pinIOConfigurationUUID,
                                        handler: {(characteristic: CBCharacteristic, error: Error?) in
                                            let bitMask = characteristic.value?.integerFromLittleUInt32
                                            handler(bitMask)
        })
    }
    
    public func setPinIOConfiguration(_ pinConfiguration: PinConfigurationMask, handler: ReadPinConfigurationHandler? = nil) {
        
        let data = Data.littleEndianUInt16FromInt(pinConfiguration)
        self.writeValue(data,
                        forCharacteristicUUID: .pinIOConfigurationUUID,
                        handler: {(characteristic: CBCharacteristic, error: Error?) in
                            if let handler = handler {
                                let bitMask = characteristic.value?.integerFromLittleUInt32
                                handler(bitMask)
                            }
        })
    }
    
    public func onPinIO(handler: @escaping NotifyPinIOHandler) {
        
        self.setNotifyValue(true,
                            forCharacteristicUUID: .pinDataUUID,
                            handler: {(characteristic: CBCharacteristic, error: Error?) in
                                
                                if let data = characteristic.value {
                                    return handler(data.pinStore)
                                } else {
                                    return .stopNotifications
                                }
        })
    }
    
    // MARK: - Event Functions
    
    public func addEvent(_ event: BTMicrobit.Event,
                         handler: @escaping ReadCharacteristicHandler) {
        
        if requiredEvents.insert(event).inserted  {
            /*let eventsData = requiredEvents.reduce(into: Data(), {data, event in
             data.append(event.microbitData)
             })*/
            //self.messageLogger?.logMessage("requiredEvents: \(eventsData as NSData)")
            self.writeValue(event.microbitData,
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
    
    public func setNotifyValueForMicrobitEvent(_ enabled: Bool, handler: NotifyCharacteristicHandler? = nil) {
        
        self.setNotifyValue(enabled,
                            forCharacteristicUUID: .eventMicrobitEventUUID,
                            handler: handler)
    }
}
