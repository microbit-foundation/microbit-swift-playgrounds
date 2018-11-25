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

/**
 A function that calls a handler when a given button is pressed on the micro:bit.
 - parameters:
    - _ The button to listen for. Values are either .A, .B or .AB
    - handler: An event handler with no parameters. This closure is called when the specified button is pressed.
 ````
 onButtonPressed(.A, handler: {
    let image = arrowImage(.west)
    image.showImage()
 })
 ````
 */
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

/**
 A function that calls a handler when a given gesture is detected on the micro:bit.
 - parameters:
    - _ The gesture to listen for. Gestures can be .shake, .tiltUp, .tiltDown plus others.
    - handler: An event handler with no parameters. This closure is called when the specified gesture is detected.
 ````
 onGesture(.shake, handler: {
    let image = iconImage(.confused)
    image.showImage()
 })
 ````
 */
public func onGesture(_ gesture: BTMicrobit.Event.Gesture, handler: @escaping EventHandler) {
    
    let gestureEvent = BTMicrobit.Event(gesture)
    ContentMessenger.messenger.sendMessageOfType(.requestEvent,
                                                 withData: gestureEvent.microbitData,
                                                 handler: handler)
}

/**
 A function that set the interval between accelerometer readings returned through the onAcceleration() function.
 - parameters:
    - _ The period interval between receiving accelerometer readings. This is an enum value of type BTMicrobit.AccelerometerPeriod.
    - handler: An optional handler with one parameter that returns an optional BTMicrobit.AccelerometerPeriod? as the actual period that was set on the micro:bit. If the period is nil then there was an error setting the period.
 ````
 setAccelerometerPeriod(.ms80, handler: (period: BTMicrobit.AccelerometerPeriod?) in {
    if let actualPeriod = period {
        // Do something with the returned value
    }
 })
 ````
 */
public func setAccelerometerPeriod(_ period: BTMicrobit.AccelerometerPeriod, handler: ReadAccelerometerPeriodHandler? = nil) {
    
    ContentMessenger.messenger.sendMessageOfType(.writeData,
                                                 forCharacteristicUUID: .accelerometerPeriodUUID,
                                                 withData: Data.littleEndianUInt16FromInt(period.rawValue),
                                                 handler: handler)
}

/**
 A function that calls a handler when the accelerometer values are updated on the micro:bit. The interval between readings can be set using setAccelerometerPeriod().
 - parameters:
    - _ An event handler with one parameter of AccelerometerValues. This closure is called when the accelerometer values are updated.
 ````
 onAcceleration({(accelerationValues) in
    let x = accelerationValues.x
    let xToPlot = -max(min(Int(x / 150), 2), -2) + 2
    image.plot(x: xToPlot, y: 2)
    image.showImage()
 })
 ````
 */
public func onAcceleration(_ handler: @escaping ReadAccelerometerHandler) {
    
    ContentMessenger.messenger.sendMessageOfType(.startNotifications,
                                                 forCharacteristicUUID: .accelerometerDataUUID,
                                                 handler: handler)
}

/**
 A function that calls a handler for reading the temperature on the micro:bit.
 - parameters:
    - _ An event handler with one parameter of Double. This closure is only called once unlike the onTemperature() function.
 ````
 readTemperature({(temperature) in
    // Do something with temperature reading
 })
 ````
 */
public func readTemperature(_ handler: @escaping ReadTemperatureHandler) {
    
    ContentMessenger.messenger.sendMessageOfType(.readData,
                                                 forCharacteristicUUID: .temperatureDataUUID,
                                                 handler: handler)
}

/**
 A function that sets the interval between temperature readings returned through the onTemperature function.
 - parameters:
    - _ The period interval between receiving temperature readings. This is an Int in milli-seconds.
    - handler: An optional handler with one parameter that returns an optional Int as the actual period that was set on the micro:bit. If the period is nil then there was an error setting the period.
 ````
 setTemperaturePeriod(5000, handler: (period: Int?) in {
    if let actualPeriod = period {
        // Do something with the returned value
        showNumber(temperature)
    }
 })
 ````
 */
public func setTemperaturePeriod(_ period: Int, handler: ReadTemperaturePeriodHandler? = nil) {
    
    ContentMessenger.messenger.sendMessageOfType(.writeData,
                                                 forCharacteristicUUID: .temperaturePeriodUUID,
                                                 withData: Data.littleEndianUInt16FromInt(period),
                                                 handler: handler)
}

/**
 A function that calls a handler when the temperature period has elapsed. The interval between readings can be set using setTemperaturePeriod().
 - parameters:
    - _ An event handler with one parameter of Double. This closure is called when the temperature period has elapsed.
 ````
 onTemperature({(temperature) in
    showNumber(temperature)
 })
 ````
 */
public func onTemperature(_ handler: @escaping ReadTemperatureHandler) {
    
    ContentMessenger.messenger.sendMessageOfType(.startNotifications,
                                                 forCharacteristicUUID: .temperatureDataUUID,
                                                 handler: handler)
}

/**
 A function that set the interval between magnetic readings returned through the onMagneticForce and onCompassHeading function.
 - parameters:
    - _ The period interval between receiving magnetometer readings. This is an enum value of type BTMicrobit.MagnetometerPeriod.
    - handler: An optional handler with one parameter that returns an optional BTMicrobit.MagnetometerPeriod? as the actual period that was set on the micro:bit. If the period is nil then there was an error setting the period.
 ````
 setMagentometerPeriod(.ms80, handler: (period: BTMicrobit.MagnetometerPeriod?) in {
    if let actualPeriod = period {
        // Do something with the returned value
    }
 })
 ````
 */
public func setMagnetometerPeriod(_ period: BTMicrobit.MagnetometerPeriod, handler: ReadMagnetometerPeriodHandler? = nil) {
    
    ContentMessenger.messenger.sendMessageOfType(.writeData,
                                                 forCharacteristicUUID: .magnetometerPeriodUUID,
                                                 withData: Data.littleEndianUInt16FromInt(period.rawValue),
                                                 handler: handler)
}

/**
 A function that calls a handler when the compass (bearing) value is updated on the micro:bit. The interval between readings can be set using setMagnetometerPeriod().
 - parameters:
    - _ An event handler with one parameter of Double. This closure is called when the compass (bearing) value is updated.
 ````
 onCompassHeading({(bearing) in
    // Do something with the bearing value such as displaying an arrow in an appropriate direction.
 })
 ````
 */
public func onCompassHeading(_ handler: @escaping ReadCompassHeadingHandler) {
    
    ContentMessenger.messenger.sendMessageOfType(.startNotifications,
                                                 forCharacteristicUUID: .magnetometerBearingUUID,
                                                 handler: handler)
}

/**
 A function that calls a handler when the magnetometer values are updated on the micro:bit. The interval between readings can be set using setMagnetometerPeriod().
 - parameters:
    - _ An event handler with one parameter of MagnetometerValues. This closure is called when the magnetometer values are updated.
 ````
 onMagneticForce({(magnetometerValues) in
 
 })
 ````
 */
public func onMagneticForce(_ handler: @escaping ReadMagnetometerHandler) {
    
    ContentMessenger.messenger.sendMessageOfType(.startNotifications,
                                                 forCharacteristicUUID: .magnetometerDataUUID,
                                                 handler: handler)
}

/**
 A function that calls a handler when a given pin is touched on the micro:bit. Note that you must also be touching the GND pin.
 - parameters:
    - _ The pin to listen for. Values are either .pin0, .pin1, .pin2
    - handler: An event handler with no parameters. This closure is called when the specified pin is touched.
 ````
 onPinPressed(.pin0, handler: {
    Character("0").microbitImage.showImage()
 })
 ````
 */
public func onPinPressed(_ pin: BTMicrobit.Pin, handler: @escaping EventHandler) {
    
    setInputPins([pin])
    setAnaloguePins([pin])
    onPins({(pinStore: PinStore) in
        
        struct staticState {
            static var pinIsPressed = false
        }
        
        if let pinValue = pinStore[pin] {
            if pinValue >= 20 && !staticState.pinIsPressed {
                staticState.pinIsPressed = true
                handler()
            } else {
                staticState.pinIsPressed = false
            }
        }
    })
}

