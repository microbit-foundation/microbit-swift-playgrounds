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

public func onButtonPressed(_ button: BTMicrobit.Button, handler: @escaping EventHandler) {
    
    let buttonEvent = BTMicrobit.Event(button: button, buttonEvent: .click)
    ContentMessenger.messenger.sendMessageOfType(.requestEvent,
                                                 withData: buttonEvent.microbitData,
                                                 handler: handler)
}

/*
 // This could be useful as a teaching aid - will not bloat API
public func onShake(handler: @escaping EventHandler) {
    onGesture(.shake, handler: handler)
}*/

public func onGesture(_ gesture: BTMicrobit.Event.Gesture, handler: @escaping EventHandler) {
    
    let gestureEvent = BTMicrobit.Event(gesture)
    ContentMessenger.messenger.sendMessageOfType(.requestEvent,
                                                 withData: gestureEvent.microbitData,
                                                 handler: handler)
}

public func setAccelerometerPeriod(_ period: BTMicrobit.AccelerometerPeriod, handler: ReadAccelerometerPeriodHandler? = nil) {
    
    ContentMessenger.messenger.sendMessageOfType(.writeData,
                                                 forCharacteristicUUID: .accelerometerPeriodUUID,
                                                 withData: Data.littleEndianUInt16FromInt(period.rawValue),
                                                 handler: handler)
}

public func onAcceleration(_ handler: @escaping ReadAccelerometerHandler) {
    
    ContentMessenger.messenger.sendMessageOfType(.startNotifications,
                                                 forCharacteristicUUID: .accelerometerDataUUID,
                                                 handler: handler)
}

public func readTemperature(_ handler: @escaping ReadTemperatureHandler) {
    
    ContentMessenger.messenger.sendMessageOfType(.readData,
                                                 forCharacteristicUUID: .temperatureDataUUID,
                                                 handler: handler)
}

public func setTemperaturePeriod(_ period: Int, handler: ReadTemperaturePeriodHandler? = nil) {
    
    ContentMessenger.messenger.sendMessageOfType(.writeData,
                                                 forCharacteristicUUID: .temperaturePeriodUUID,
                                                 withData: Data.littleEndianUInt16FromInt(period),
                                                 handler: handler)
}

public func onTemperature(_ handler: @escaping ReadTemperatureHandler) {
    
    ContentMessenger.messenger.sendMessageOfType(.startNotifications,
                                                 forCharacteristicUUID: .temperatureDataUUID,
                                                 handler: handler)
}

public func setMagentometerPeriod(_ period: BTMicrobit.MagnetometerPeriod, handler: ReadMagnetometerPeriodHandler? = nil) {
    
    ContentMessenger.messenger.sendMessageOfType(.writeData,
                                                 forCharacteristicUUID: .magnetometerPeriodUUID,
                                                 withData: Data.littleEndianUInt16FromInt(period.rawValue),
                                                 handler: handler)
}

public func onCompassHeading(_ handler: @escaping ReadCompassHeadingHandler) {
    
    ContentMessenger.messenger.sendMessageOfType(.startNotifications,
                                                 forCharacteristicUUID: .magnetometerBearingUUID,
                                                 handler: handler)
}

public func onMagneticForce(_ handler: @escaping ReadMagnetometerHandler) {
    
    ContentMessenger.messenger.sendMessageOfType(.startNotifications,
                                                 forCharacteristicUUID: .magnetometerDataUUID,
                                                 handler: handler)
}

public func onPinPressed(_ pin: BTMicrobit.Pin, handler: @escaping EventHandler) {
    
    setInputPins([pin])
    setAnaloguePins([pin])
    onPins({(pinStore: PinStore) in
        
        struct staticState {
            static var pinIsPressed = false
        }
        
        if let pinValue = pinStore[pin] {
            if pinValue > 16 && !staticState.pinIsPressed {
                staticState.pinIsPressed = true
                handler()
            } else {
                staticState.pinIsPressed = false
            }
        }
    })
}

