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

public class BTManager : NSObject, PlaygroundBluetoothCentralManagerDelegate, BTPeripheralDelegate {
    
    public var bluetoothCentralManager: PlaygroundBluetoothCentralManager!
    public var microbit: BTMicrobit?
    public weak var delegate: BTManagerDelegate?
    public weak var messageLogger: LoggingProtocol?
    
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
    
    public func microbitNameForPeripheral(_ peripheral: CBPeripheral) -> String? {
        if let devicesMappingDict = self.pairedDeviceMappings,
        let microbitNameValue = devicesMappingDict[String(describing: peripheral.identifier)] {
            if case .string(let microbitName) = microbitNameValue {
                return microbitName
            }
        }
        return nil
    }
    
    //MARK: - Internal Functions
    
    func callPairingHandlerWithError(_ error: PairingError? = nil) {
        
        if let handler = self.microbitPairingHandler {
            handler(self.microbit, error)
            self.microbitPairingHandler = nil
        }
        self.microbitPairingName = nil
        self.delegate?.btManager(self,
                                 didPairToMicrobit: self.microbit,
                                 error: error)
    }
    
    var isPairing: Bool {
        get {
            // The name is set until pairing has finished.
            return self.microbitPairingName != nil
        }
    }
    
    //MARK: - PlaygroundBluetoothCentralManagerDelegate Functions
    
    public func centralManagerStateDidChange(_ centralManager: PlaygroundBluetoothCentralManager) {
        
        if centralManager.state == .poweredOn {
            
            if !centralManager.connectToLastConnectedPeripheral(timeout: 7.0,
                                                                callback: {(peripheral: CBPeripheral?, error: Error?) in
                                                                    
                                                                    //self.messageLogger?.logMessage("connectToLastConnectedPeripheral callback")
                                                                    
                                                                    if error != nil {
                                                                        self.messageLogger?.logMessage("Error connecting to last connected micro:bit \(error!)")
                                                                        // TODO: - Remove the lasted connected key and possibly paired info too
                                                                        let store = PlaygroundKeyValueStore.current
                                                                        store["com.apple.PlaygroundBluetooth.LastConnectedPeripheral"] = nil
                                                                    }
                                                                    if peripheral != nil {
                                                                        //self.messageLogger?.logMessage("Connected to last known peripheral \(peripheral!)")
                                                                    }
                                                                    
            }) {
                // There was no previously connected micro:bit - pairing required
                self.messageLogger?.logMessage("No previously connected micro:bit")
            }
        }
        self.delegate?.btManagerStateDidChange(self)
    }
    
    public func centralManager(_ centralManager: PlaygroundBluetoothCentralManager,
                               didConnectTo peripheral: CBPeripheral) {
        
        messageLogger?.logMessage("Connected to micro:bit")
        self.microbit = BTMicrobit.init(peripheral: peripheral)
        self.microbit?.delegate = self
        self.microbit?.messageLogger = messageLogger
        if let microbit = self.microbit, !self.isPairing {
            delegate?.btManager(self, didConnectMicrobit: microbit)
        }
    }
    
    public func centralManager(_ centralManager: PlaygroundBluetoothCentralManager,
                               didFailToConnectTo peripheral: CBPeripheral,
                               error: Error?) {
        
        messageLogger?.logMessage("Failed to connect to micro:bit")
        if let error = error as? PlaygroundBluetoothCentralManager.ConnectionError {
            // TODO: What to do on a failure to connect callback - possibly because it has lost pairing info - advise to pair again.
            messageLogger?.logMessage("Failed to connect with error: \(error)")
            switch error {
                
            case .excessiveConnections: // This occurs when switching micro:bits - try again but 1/2 second later on the main thread
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                    centralManager.connect(to: peripheral, timeout: 7.0, callback: nil)
                }
                
            default:
                break
            }
        }
        
        delegate?.btManager(self, didFailToConnectToPeripheral: peripheral,
                            error: error)
    }
    
    public func centralManager(_ centralManager: PlaygroundBluetoothCentralManager,
                               didDisconnectFrom peripheral: CBPeripheral,
                               error: Error?) {
        
        messageLogger?.logMessage("Disconnected from micro:bit")
        if (error != nil) {
            messageLogger?.logMessage("Disconnected with error: \(error!)")
        }
        delegate?.btManager(self, didDisconnectMicrobit: microbit,
                            error: error)
        self.microbit = nil
    }
    
    public func centralManager(_ centralManager: PlaygroundBluetoothCentralManager,
                               didDiscover peripheral: CBPeripheral,
                               withAdvertisementData advertisementData: [String: Any]?,
                               rssi: Double) {
        
        //self.messageLogger?.logMessage("Found peripheral: \(peripheral) + \(advertisementData)")
        
        if let peripheralName = advertisementData?[CBAdvertisementDataLocalNameKey] as? String {
            if peripheralName == self.microbitPairingName {
                //self.messageLogger?.logMessage("Found micro:bit")
                centralManager.scanning = false
                self.microbitPairingTimer?.invalidate()
                self.microbitPairingTimer = nil
                
                centralManager.connect(toPeripheralWithUUID: peripheral.identifier,
                                       timeout: 7,
                                       callback: {peripheral, error in
                                        
                                        //self.messageLogger?.logMessage("Call back with: \(peripheral ?? nil) and error \(error ?? nil)")
                                        
                                        if error != nil {
                                            // Handle connection error
                                            self.callPairingHandlerWithError(.failedToConnectToMicrobit)
                                            
                                        } else if peripheral != nil {
                                            // Connection successful
                                            self.microbit = BTMicrobit(peripheral: peripheral!)
                                            self.microbit?.delegate = self
                                            //self.messageLogger?.logMessage("Reading value for \(self.microbit!)")
                                            // If this method is called after the micro:bit is flashed but the iPad still think it is paired then the handler is never called.
                                            // For this situation we need our own timeout Timer.
                                            self.microbitPairingTimer = Timer.scheduledTimer(withTimeInterval: 10.0,
                                                                                             repeats: false,
                                                                                             block: { timer in
                                                                                                // Got no response attempting a pairing operation - probably micro:bit re-flashed without forgeting peripheral in iOS device
                                                                                                
                                                                                                self.microbitPairingTimer = nil
                                                                                                self.callPairingHandlerWithError(.microbitFlashed)
                                            })
                                            self.microbit!.readValueForCharacteristic(.dfuControlUUID,
                                                                                      handler: {(characteristic: CBCharacteristic, error: Error?) in
                                                                                        
                                                                                        self.microbitPairingTimer?.invalidate()
                                                                                        self.microbitPairingTimer = nil
                                                                                        self.microbitPairingName = nil
                                                                                        
                                                                                        if let characteristicData = characteristic.value {
                                                                                            let _ = Int(characteristicData[0])
                                                                                            //self.messageLogger?.logMessage("[DEBUG] pairing read control value: \(intValue)")
                                                                                            self.callPairingHandlerWithError()
                                                                                        } else {
                                                                                            //self.messageLogger?.logMessage("[DEBUG] cannot retreive pairing control value")
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
        case microbitFlashed
        
        var localizedDescription: String {
            get {
                switch self {
                    
                case .timeoutSearchingForMicrobit:
                    return "Could not find the micro:bit with the pairing name selected. Check the LEDs were entered correctly and tap Pair Again."
                    
                case .microbitFlashed:
                    return "The micro:bit may have been flashed since it was last paired with this device. Go into Settings > Bluetooth, locate the micro:bit, tap the 'i' button and tap 'Forget This Device'. Then attempt pairing again."
                default:
                    return ""
                }
            }
        }
    }
    
    //MARK: - BTPeripheralDelegate
    
    public func peripheral(_ peripheral: BTPeripheral,
                           timeoutDiscoveringServices services: Array<String>) {
        //self.messageLogger?.logMessage("timeout reading services: \(services)")
        var serviceUUIDs = Array<BTMicrobit.ServiceUUID>()
        for uuid in services {
            if let serviceUUID = BTMicrobit.ServiceUUID(rawValue: uuid) {
                serviceUUIDs.append(serviceUUID)
            }
        }
        if serviceUUIDs.count > 0 {
            self.delegate?.btManager(self, didTimeoutReadingServices: serviceUUIDs)
        }
    }
}

//MARK: - BTManagerDelegate

public protocol BTManagerDelegate: AnyObject {
    
    func btManagerStateDidChange(_ manager: BTManager)
    
    func btManager(_ manager: BTManager,
                   didConnectMicrobit microbit: BTMicrobit)
    
    func btManager(_ manager: BTManager,
                   didDisconnectMicrobit microbit: BTMicrobit?,
                   error: Error?)
    
    func btManager(_ manager: BTManager,
                   didFailToConnectToPeripheral peripheral: CBPeripheral,
                   error: Error?)
    
    func btManager(_ manager: BTManager,
                   didTimeoutReadingServices services: Array<BTMicrobit.ServiceUUID>)
    
    func btManager(_ manager: BTManager,
                   didPairToMicrobit microbit: BTMicrobit?,
                   error: BTManager.PairingError?)
}
