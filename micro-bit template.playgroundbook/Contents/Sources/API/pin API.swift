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
 A function that sets which pins are used for input or output on the micro:bit.
 - parameters:
    - _ An array of type BTMicrobit.Pin. This sets the pins to be used for input. Pins not specified are not changed.
    - outputPins: An optional array of type BTMicrobit.Pin. This sets the pins to be used for output. Pins not specified are not changed.
 ````
 setInputPins([pin0, pin1], outputPins: [pin2, pin3])
 ````
 */
public func setInputPins(_ inputPins: [BTMicrobit.Pin], outputPins: [BTMicrobit.Pin]? = nil) {
    
    ContentMessenger.messenger.sendMessageOfType(.readData,
                                                 forCharacteristicUUID: .pinIOConfigurationUUID,
                                                 handler: {(bitMask: PinConfigurationMask?) in
                                                    
                                                    var newBitMask = bitMask ?? 0
                                                    for pin in inputPins {
                                                        newBitMask |= (1 << pin.rawValue)
                                                    }
                                                    
                                                    if let outputPins = outputPins {
                                                        for pin in outputPins {
                                                            newBitMask &= ~(1 << pin.rawValue)
                                                        }
                                                    }
                                                    
                                                    let data = Data.littleEndianUInt32FromInt(newBitMask)
                                                    ContentMessenger.messenger.sendMessageOfType(.writeData,
                                                                                                 forCharacteristicUUID: .pinIOConfigurationUUID,
                                                                                                 withData: data)
    })
}

/**
 A function that sets which pins are used for analogue or digital on the micro:bit.
 - parameters:
    - _ An array of type BTMicrobit.Pin. This sets the pins to be used for analogue signal. Pins not specified are not changed.
    - digitalPins: An optional array of type BTMicrobit.Pin. This sets the pins to be used for a digital signal. Pins not specified are not changed.
 ````
 setAnaloguePins([pin0, pin1], digitalPins: [pin2, pin3])
 ````
 */
public func setAnaloguePins(_ analoguePins: [BTMicrobit.Pin], digitalPins: [BTMicrobit.Pin]? = nil) {
    
    ContentMessenger.messenger.sendMessageOfType(.readData,
                                                 forCharacteristicUUID: .pinADConfigurationUUID,
                                                 handler: {(bitMask: PinConfigurationMask?) in
                                                    
                                                    var newBitMask = bitMask ?? 0
                                                    for pin in analoguePins {
                                                        newBitMask |= (1 << pin.rawValue)
                                                    }
                                                    
                                                    if let digitalPins = digitalPins {
                                                        for pin in digitalPins {
                                                            newBitMask &= ~(1 << pin.rawValue)
                                                        }
                                                    }
                                                    
                                                    let data = Data.littleEndianUInt32FromInt(newBitMask)
                                                    ContentMessenger.messenger.sendMessageOfType(.writeData,
                                                                                                 forCharacteristicUUID: .pinADConfigurationUUID,
                                                                                                 withData: data)
    })
}

/**
 A function that calls a handler when any of the input pins have changed value on the micro:bit. The returned type is a PinStore, this is a dictionary of type [BTMicrobit.Pin: Int]. Note that pins that have not changed value will not be included in the store even if they are set to input. You must therefore always check there is an entry for the pin whose value you wish to read. The pin value is an Int between 0 and 1020.
 - parameters:
    - _ A handler that returns a PinStore. This closure is called whenever an input pin changes its value.
 ````
 onPins({pinStore in
    if let pin0Value = pinStore[.pin0] {
        // Do something with the value stored in pin0Value.
    }
 })
 ````
 */
public func onPins(_ handler: @escaping ReadPinIOHandler) {
    
    ContentMessenger.messenger.sendMessageOfType(.startNotifications,
                                                 forCharacteristicUUID: .pinDataUUID,
                                                 handler: handler)
}

/**
 A function that writes a value to specified output pins on the micro:bit. This is done by passing a PinStore which is a dictionary of type [BTMicrobit.Pin: Int]. The pin value is an Int between 0 and 1020.
 - parameters:
    - _ A PinStore that specifies which pins you wish to write to.
 ````
 writePins([pin2: 300, pin3: 400])
 ````
 */
public func writePins(_ pinStore: PinStore) {
    
    ContentMessenger.messenger.sendMessageOfType(.writeData,
                                                 forCharacteristicUUID: .pinDataUUID,
                                                 withData: Data.fromPinStore(pinStore))
}
