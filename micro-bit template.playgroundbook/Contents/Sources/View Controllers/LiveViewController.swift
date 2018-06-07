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

import UIKit
import CoreBluetooth
import PlaygroundSupport
import PlaygroundBluetooth

@objc(LiveViewController)
public class LiveViewController: UIViewController, BTManagerDelegate, ValuesTableViewDataSourceProtocol {
    
    public weak var containerViewController: LiveViewContainerController!
    
    var _btManager: BTManager!
    var bluetoothController: BluetoothConnectionViewController!
    var valuesTableViewController: ValuesTableViewController!
    var _cachedMicrobitImage: MicrobitImage?
    
    @IBOutlet weak var pairButton: UIButton!
    @IBOutlet weak var microbitMimic: MicrobitMimic!
    @IBOutlet weak var logTextView: UITextView!
    
    public var btManager: BTManager {
        get {
            return _btManager
        }
        set {
            _btManager = newValue
            _btManager.delegate = self
        }
    }
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        // Hide the logView when released
        self.logTextView.isHidden = true
        self.btManager = BTManager()
        
        //self.logMessage("viewDidLoad: \(UIDevice.current.identifierForVendor)")
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if !isMovingToParentViewController {
            // Ensure peripheral is renamed after pairing
            
            if let devicesMappingDict = self.btManager.pairedDeviceMappings {
                
                bluetoothController?.view.isHidden = devicesMappingDict.count == 0
                if let peripheral = self.btManager.microbit?.peripheral {
                    
                    let peripheralUUID = peripheral.identifier.description
                    if let microbitNameValue = devicesMappingDict[peripheralUUID], case .string(let microbitName) = microbitNameValue {
                        if let btConnectionView = bluetoothController.view as? PlaygroundBluetoothConnectionView {
                            btConnectionView.setName(microbitName, forPeripheral: peripheral)
                        }
                    }
                    self.btManager.bluetoothCentralManager.connect(toPeripheralWithUUID: peripheral.identifier,
                                                                   timeout: 7.0,
                                                                   callback:{peripheral, error in
                                                                    // TODO: - Handle the error here - although unlikely
                    })
                }
            } else {
                bluetoothController?.view.isHidden = true
            }
        }
    }
    
    override public func prepare(for seque: UIStoryboardSegue, sender: Any?) {
        
        if seque.identifier == "embedValueTableControllerSegue" {
            
            //self.logMessage("\(seque.destination)")
            valuesTableViewController = seque.destination as! ValuesTableViewController
            valuesTableViewController.dataSource = self
        }
    }
    
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        super.traitCollectionDidChange(previousTraitCollection)
        
        //self.logMessage("horizontal size class: \(self.traitCollection.horizontalSizeClass.rawValue) vertical size class: \(self.traitCollection.verticalSizeClass.rawValue)")
        //self.logMessage("and my bluetoothController is: \(self.bluetoothController.view!)")
    }
    
    override public func didMove(toParentViewController parent: UIViewController?) {
        //self.logMessage("Did move to parent.parent controller: \(parent?.parent)")
        //containerViewController = parent?.parent as? LiveViewContainerController
        super.didMove(toParentViewController: parent)
    }
    
    public var cachedMicrobitImage: MicrobitImage {
        get {
            return _cachedMicrobitImage ?? MicrobitImage()
        }
        set {
            _cachedMicrobitImage = newValue
            self.microbitMimic.microbitImage = self.cachedMicrobitImage
        }
    }
    
    //MARK: - BTManagerDelegate
    
    public func logMessage(_ message: String) {
        
        let string = self.logTextView.text + "\n" + message
        self.logTextView.text = string
    }
    
    public func btManagerStateDidChange(_ manager: BTManager) {
        
        if (manager.bluetoothCentralManager.state == .poweredOn) {
            self.logMessage("Central manager changed state to 'poweredOn'")
            
            self.bluetoothController = BluetoothConnectionViewController(bluetoothManager: self.btManager)
            self.bluetoothController.messageLogger = self
            if let connectionView = bluetoothController.view {
                self.view.addSubview(connectionView)
                connectionView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    connectionView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 0.0),
                    connectionView.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor, constant: 0.0),
                    connectionView.widthAnchor.constraint(greaterThanOrEqualToConstant: 270.0)
                    ])
                
                /*let testButton = UIButton()
                 testButton.setTitle("Test Button", for:.normal)
                 self.view.addSubview(testButton)
                 testButton.translatesAutoresizingMaskIntoConstraints = false
                 NSLayoutConstraint.activate([
                 testButton.topAnchor.constraint(equalTo: connectionView.topAnchor, constant: 0.0),
                 testButton.trailingAnchor.constraint(equalTo: connectionView.leadingAnchor, constant: 0.0)
                 ])*/
            }
        }
    }
    
    public func btManager(_ manager: BTManager,
                          didConnectMicrobit microbit: BTMicrobit) {
        
        // Tell the code view the microbit is available?
        
        self.pairButton.isHidden = true
        self.bluetoothController.view.isHidden = false
        
        self.microbitMimic.isActive = false
        
        var characteristicUUID: BTMicrobit.CharacteristicUUID?
        // Get the microbit image and cache it.
        characteristicUUID = .ledStateUUID
        microbit.readValueFor(serviceUUIDString: characteristicUUID!.serviceUUID.rawValue,
                              characteristicUUIDString: characteristicUUID!.rawValue,
                              handler: {(characteristic: CBCharacteristic, handlerType, error: Error?) in
                                
                                if let data = characteristic.value {
                                    //self.logMessage("I got image: \(data as! NSData)")
                                    self.cachedMicrobitImage = MicrobitImage(data)
                                }
        })
        
        characteristicUUID = .buttonStateAUUID
        microbit.setNotifyValue(true,
                                serviceUUIDString: characteristicUUID!.serviceUUID.rawValue,
                                characteristicUUIDString:characteristicUUID!.rawValue,
                                handler: {(characteristic: CBCharacteristic, handlerType, error: Error?) in
                                    if let data = characteristic.value {
                                        let buttonState = BTMicrobit.ButtonState(data) ?? BTMicrobit.ButtonState.notPressed
                                        self.microbitMimic.showButtonAPressed(buttonState != .notPressed)
                                    }
        })
        
        characteristicUUID = .buttonStateBUUID
        microbit.setNotifyValue(true,
                                serviceUUIDString: characteristicUUID!.serviceUUID.rawValue,
                                characteristicUUIDString:characteristicUUID!.rawValue,
                                handler: {(characteristic: CBCharacteristic, handlerType, error: Error?) in
                                    if let data = characteristic.value {
                                        let buttonState = BTMicrobit.ButtonState(data) ?? BTMicrobit.ButtonState.notPressed
                                        self.microbitMimic.showButtonBPressed(buttonState != .notPressed)
                                    }
        })
        
        // Setup notifications for values in the table.
        var hasAcceleration = false
        for microbitMeasurement in self.containerViewController.microbitMeasurements {
            
            switch microbitMeasurement {
                
            case .accelerationX, .accelerationY, .accelerationZ:
                if !hasAcceleration {
                    characteristicUUID = .accelerometerDataUUID
                    hasAcceleration = true
                }
                
            case .bearing:
                characteristicUUID = .magnetometerBearingUUID
                
            case .temperature:
                characteristicUUID = .temperatureDataUUID
            }
            
            if let characteristicUUID = characteristicUUID {
                microbit.setNotifyValue(true,
                                        serviceUUIDString: characteristicUUID.serviceUUID.rawValue,
                                        characteristicUUIDString:characteristicUUID.rawValue,
                                        handler: {(characteristic: CBCharacteristic, handlerType, error: Error?) in
                                            
                                            if let characteristicUUID = BTMicrobit.CharacteristicUUID(rawValue: characteristic.uuid.uuidString),
                                                let data = characteristic.value {
                                                
                                                switch characteristicUUID {
                                                    
                                                case .accelerometerDataUUID:
                                                    if let accelerometerValues = AccelerometerValues(data: data) {
                                                        self.valuesTableViewController.setMicrobitValue(accelerometerValues.x,
                                                                                                        forMicrobitMeasurement: .accelerationX(.microbitGravity))
                                                        self.valuesTableViewController.setMicrobitValue(accelerometerValues.y,
                                                                                                        forMicrobitMeasurement: .accelerationY(.microbitGravity))
                                                        self.valuesTableViewController.setMicrobitValue(accelerometerValues.z,
                                                                                                        forMicrobitMeasurement: .accelerationZ(.microbitGravity))
                                                    }
                                                    
                                                case .magnetometerBearingUUID:
                                                    let bearing = Double(data.integerFromLittleUInt16!)
                                                    self.valuesTableViewController.setMicrobitValue(bearing,
                                                                                                    forMicrobitMeasurement: .bearing(.degrees))
                                                    
                                                case .temperatureDataUUID:
                                                    let temperatureValue = Double(data[0])
                                                    self.valuesTableViewController.setMicrobitValue(temperatureValue,
                                                                                                    forMicrobitMeasurement: .temperature(.celsius))
                                                    
                                                default:
                                                    break
                                                }
                                            }
                })
            }
        }
    }
    
    public func btManager(_ manager: BTManager,
                          didDisconnectMicrobit microbit: BTMicrobit) {
        
        self.pairButton.isHidden = false
        self.microbitMimic.isActive = true
    }
    
    public func btManager(_ manager: BTManager,
                          didFailToConnectToMicrobit microbit: BTMicrobit) {
        
        self.pairButton.isHidden = false
        self.microbitMimic.isActive = true
    }
    
    //MARK: - ValuesTableViewDataSourceProtocol
    
    public func numberOfMicrobitMeasurements() -> Int {
        return self.containerViewController.microbitMeasurements.count
    }
    
    public func microbitMeasurementAtIndex(_ index: Int) -> MicrobitMeasurement {
        return self.containerViewController.microbitMeasurements[index]
    }
    
    //MARK: - IBActions
    
    @IBAction public func pairMicrobitFromSender(_ sender: UIButton) {
        
        if let pairingController = self.storyboard?.instantiateViewController(withIdentifier: "PairingControllerID1") as? PairingController {
            pairingController.btManager = self.btManager
            self.navigationController?.pushViewController(pairingController, animated:true)
        }
    }
}
