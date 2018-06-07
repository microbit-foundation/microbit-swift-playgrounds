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
import PlaygroundBluetooth
import PlaygroundSupport

let BTMicrobitPairedDevices = "org.microbit.PlaygroundBluetooth.PairedDevices"

public typealias MicrobitPairingHandler = (BTMicrobit?, BTManager.PairingError?) -> Void

public class BTManager : NSObject, PlaygroundBluetoothCentralManagerDelegate {
        
    public var bluetoothCentralManager: PlaygroundBluetoothCentralManager!
    public var microbit: BTMicrobit?
    public weak var delegate: BTManagerDelegate?
    
    var microbitPairingName: String?
    var microbitPairingHandler: MicrobitPairingHandler?
    var microbitPairingTimer: Timer?
    
    override public init() {
        
        super.init()
        bluetoothCentralManager = PlaygroundBluetoothCentralManager(services: nil, queue: .main)
        bluetoothCentralManager.delegate = self
    }
    
    public func beginPairingWithMicrobitName(_ microbitName: String, handler: @escaping MicrobitPairingHandler) {
        
        microbitPairingName = microbitName
        microbitPairingHandler = handler
        
        for peripheral in bluetoothCentralManager!.connectedPeripherals {
            if peripheral.name == microbitPairingName {
                // We're already connected to this device - call the handler
                callPairingHandlerWithError(.alreadyConnectedToMicrobit)
                return
            }
        }
        
        microbitPairingTimer = Timer.scheduledTimer(withTimeInterval: 10.0,
                                                    repeats: false,
                                                    block: { timer in
                                                        // Could not find named micro:bit
                                                        self.bluetoothCentralManager!.scanning = false
                                                        self.microbitPairingTimer = nil
                                                        self.callPairingHandlerWithError(.timeoutSearchingForMicrobit)
        })
        bluetoothCentralManager!.scanning = true
    }
    
    public var pairedDeviceMappings: [String: PlaygroundValue]? {
        
        get {
            let store = PlaygroundKeyValueStore.current
            if let keyValue = store[BTMicrobitPairedDevices], case .dictionary(let pairedDeviceMappings) = keyValue {
                return pairedDeviceMappings
            }
            return nil
        }
        set(newPairedDeviceMappings) {
            let store = PlaygroundKeyValueStore.current
            if newPairedDeviceMappings != nil {
                store[BTMicrobitPairedDevices] = .dictionary(newPairedDeviceMappings!)
            } else {
                store[BTMicrobitPairedDevices] = nil
            }
        }
    }
    
    //MARK: - Internal Functions
    
    func callPairingHandlerWithError(_ error: PairingError? = nil) {
        
        if let handler = self.microbitPairingHandler {
            handler(self.microbit, error)
            self.microbitPairingHandler = nil
            self.microbitPairingName = nil
        }
    }
    
    //MARK: - PlaygroundBluetoothCentralManagerDelegate Functions
    
    public func centralManagerStateDidChange(_ centralManager: PlaygroundBluetoothCentralManager) {
        
        if centralManager.state == .poweredOn {
            
            if !centralManager.connectToLastConnectedPeripheral(timeout: 7.0,
                                                                callback: {(peripheral: CBPeripheral?, error: Error?) in
                                                                    
                                                                    self.delegate?.logMessage("connectToLastConnectedPeripheral callback")
                                                                    
                                                                    if error != nil {
                                                                        self.delegate?.logMessage("Error connecting to micro:bit \(error!)")
                                                                        // TODO: - Remove the lasted connected key and possibly paired info too
                                                                    }
                                                                    if peripheral != nil {
                                                                        self.delegate?.logMessage("Connected to last known peripheral \(peripheral!)")
                                                                    }
                                                                    
            }) {
                // There was no previously connected micro:bit - pairing required
                self.delegate?.logMessage("No previously connected micro:bit")
            }
        }
        self.delegate?.btManagerStateDidChange(self)
    }
    
    public func centralManager(_ centralManager: PlaygroundBluetoothCentralManager,
                               didConnectTo peripheral: CBPeripheral) {
        
        delegate?.logMessage("Connected to micro:bit")
        self.microbit = BTMicrobit.init(peripheral: peripheral)
        self.microbit?.messageLogger = delegate
        if let microbit = self.microbit {
            delegate?.btManager(self, didConnectMicrobit: microbit)
        }
    }
    
    public func centralManager(_ centralManager: PlaygroundBluetoothCentralManager,
                               didFailToConnectTo peripheral: CBPeripheral,
                               error: Error?) {
        
        if (error != nil) {
            // TODO: What to do on a failure to connect callback - possibly because it has lost pairing info - advise to pair again.
            delegate?.logMessage("Failed to connect to micro:bit with error: \(error!)")
        }
        
        self.microbit = BTMicrobit(peripheral: peripheral)
        if let microbit = self.microbit {
            delegate?.btManager(self, didFailToConnectToMicrobit: microbit)
        }
    }
    
    public func centralManager(_ centralManager: PlaygroundBluetoothCentralManager,
                               didDisconnectFrom peripheral: CBPeripheral,
                               error: Error?) {
        
        delegate?.logMessage("Disconnected from micro:bit")
        self.microbit = BTMicrobit(peripheral: peripheral)
        if let microbit = self.microbit {
            delegate?.btManager(self, didFailToConnectToMicrobit: microbit)
        }
    }
    
    public func centralManager(_ centralManager: PlaygroundBluetoothCentralManager,
                               didDiscover peripheral: CBPeripheral,
                               withAdvertisementData advertisementData: [String: Any]?,
                               rssi: Double) {
        
        //self.delegate?.logMessage("Found peripheral: \(peripheral) + \(advertisementData)")
        
        if let peripheralName = advertisementData?[CBAdvertisementDataLocalNameKey] as? String {
            if peripheralName == self.microbitPairingName {
                //self.delegate?.logMessage("Found micro:bit")
                centralManager.scanning = false
                self.microbitPairingTimer?.invalidate()
                self.microbitPairingTimer = nil
                
                centralManager.connect(toPeripheralWithUUID: peripheral.identifier,
                                       timeout: 7,
                                       callback: {peripheral, error in
                                        
                                        //self.delegate?.logMessage("Call back with: \(peripheral) and error \(error)")
                                        
                                        if error != nil {
                                            // Handle connection error
                                            self.callPairingHandlerWithError(.failedToConnectToMicrobit)
                                            
                                        } else if peripheral != nil {
                                            // Connection successful
                                            self.microbit = BTMicrobit(peripheral: peripheral!)
                                            //self.delegate?.logMessage("Reading value for \(self.microbit!)")
                                            self.microbit!.readValueForCharacteristic(.dfuControlUUID,
                                                                                      handler: {(characteristic: CBCharacteristic, handlerType, error: Error?) in
                                                                                        
                                                                                        //self.delegate?.logMessage("Got called back")
                                                                                        if let characteristicData = characteristic.value {
                                                                                            _ = Int(characteristicData[0])
                                                                                            //self.delegate?.logMessage("[DEBUG] pairing read control value: \(intValue)")
                                                                                            self.callPairingHandlerWithError()
                                                                                        } else {
                                                                                            self.delegate?.logMessage("[DEBUG] cannot retreive pairing control value")
                                                                                            // If the code is entered incorrectly - we get error code 15, "Encryption is insufficient"
                                                                                            self.callPairingHandlerWithError(.failedToRetrieveCharacteristicValue)
                                                                                        }
                                            })
                                        }
                })
            }
        }
    }
    
    public enum PairingError : Error {
        
        case alreadyConnectedToMicrobit
        case timeoutSearchingForMicrobit
        case failedToConnectToMicrobit
        case failedToRetrieveCharacteristicValue
    }
}

//MARK: - BTManagerDelegate

public protocol BTManagerDelegate: class {
    
    func logMessage(_ message: String)
    
    
    func btManagerStateDidChange(_ manager: BTManager)
    
    func btManager(_ manager: BTManager,
                   didConnectMicrobit microbit: BTMicrobit)
    
    func btManager(_ manager: BTManager,
                   didDisconnectMicrobit microbit: BTMicrobit)
    
    func btManager(_ manager: BTManager,
                   didFailToConnectToMicrobit microbit: BTMicrobit)
}
