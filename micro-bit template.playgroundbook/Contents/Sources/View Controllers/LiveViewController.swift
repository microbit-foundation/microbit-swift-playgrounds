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
import CoreGraphics
import CoreBluetooth
import PlaygroundSupport
import PlaygroundBluetooth

@objc(LiveViewController)
public class LiveViewController: UIViewController, BTManagerDelegate, LoggingProtocol, ValuesTableViewDataSourceProtocol {
    
    public weak var containerViewController: LiveViewContainerController!
    
    var bluetoothController: BluetoothConnectionViewController!
    var valuesTableViewController: ValuesTableViewController!
    
    @IBOutlet weak var pairButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var microbitMimic: MicrobitMimic!
    @IBOutlet weak var logTextView: UITextView!
    
    public var btManager: BTManager! {
        didSet {
            btManager.delegate = self
            btManager.messageLogger = self
        }
    }
    
    public var dataActivityItem: DataActivityItemSource? {
        didSet {
            self.shareButton.isHidden = dataActivityItem == nil
        }
    }
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        // Hide the logView when released
        self.logTextView.isHidden = true
        self.shareButton.isHidden = true
        self.btManager = BTManager()
        self.microbitMimic.messageLogger = self
        self.setupValuesTable()
        //self.logMessage("viewDidLoad: \(UIDevice.current.identifierForVendor)")
        if let navigationBar = self.navigationController?.navigationBar {
            //navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
            navigationBar.shadowImage = UIImage()
        }
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if !isMovingToParentViewController {
            if let devicesMappingDict = self.btManager.pairedDeviceMappings {
                bluetoothController?.view.isHidden = devicesMappingDict.count == 0
                if self.btManager.microbit == nil {
                    _ = self.btManager.bluetoothCentralManager.connectToLastConnectedPeripheral(timeout: 7.0,
                                                                                                callback: {(peripheral: CBPeripheral?, error: Error?) in
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
        self.microbitMimic.orientation = self.traitCollection.horizontalSizeClass == .regular ? .landscapeLeft : .portrait
    }
    
    override public func didMove(toParentViewController parent: UIViewController?) {
        //self.logMessage("Did move to parent.parent controller: \(parent?.parent)")
        //containerViewController = parent?.parent as? LiveViewContainerController
        super.didMove(toParentViewController: parent)
    }
    
    public var cachedMicrobitImage: MicrobitImage {
        get {
            return self.microbitMimic.microbitImage
        }
        set {
            self.microbitMimic.microbitImage = newValue
        }
    }
    
    //MARK: - Setup notifications for values table
    
    func setupValuesTable() {
        
        // Setup notifications for values in the table.
        //self.logMessage("setupValuesTable")
        
        var hasAcceleration = false
        var hasPinData = false
        for microbitMeasurement in self.containerViewController.microbitMeasurements {
            
            var characteristicUUID: BTMicrobit.CharacteristicUUID? = nil
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
                
            case .pin0, .pin1, .pin2:
                if !hasPinData {
                    characteristicUUID = .pinDataUUID
                    hasPinData = true
                }
            }
            
            if let characteristicUUID = characteristicUUID {
                
                if let microbit = self.btManager.microbit {
                    microbit.setNotifyValue(true,
                                            forCharacteristicUUID: characteristicUUID,
                                            handler: {(characteristic: CBCharacteristic, error: Error?) in
                                                
                                                if let characteristicUUID = BTMicrobit.CharacteristicUUID(rawValue: characteristic.uuid.uuidString),
                                                    let data = characteristic.value {
                                                    
                                                    switch characteristicUUID {
                                                        
                                                    case .accelerometerDataUUID:
                                                        if let accelerometerValues = AccelerometerValues(data: data) {
                                                            
                                                            self.microbitMimic.accelerometerValues = accelerometerValues
                                                            //self.logMessage("\(accelerometerValues)")
                                                            
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
                                                        
                                                    case .pinDataUUID:
                                                        let pinStore = data.pinStore
                                                        if let pinValue = pinStore[.pin0] {
                                                            self.valuesTableViewController.setMicrobitValue(Double(pinValue),
                                                                                                            forMicrobitMeasurement: .pin0(.raw))
                                                        }
                                                        if let pinValue = pinStore[.pin1] {
                                                            self.valuesTableViewController.setMicrobitValue(Double(pinValue),
                                                                                                            forMicrobitMeasurement: .pin1(.raw))
                                                        }
                                                        if let pinValue = pinStore[.pin2] {
                                                            self.valuesTableViewController.setMicrobitValue(Double(pinValue),
                                                                                                            forMicrobitMeasurement: .pin2(.raw))
                                                        }
                                                        
                                                    default:
                                                        break
                                                    }
                                                    return .continueNotifications
                                                }
                                                return .stopNotifications
                    })
                }
                
                if self.microbitMimic.isActive {
                    switch characteristicUUID {
                        
                    case .accelerometerDataUUID:
                        self.microbitMimic.addAccelerometerHandler({accelerometerValues in
                            
                            self.valuesTableViewController.setMicrobitValue(accelerometerValues.x,
                                                                            forMicrobitMeasurement: .accelerationX(.microbitGravity))
                            self.valuesTableViewController.setMicrobitValue(accelerometerValues.y,
                                                                            forMicrobitMeasurement: .accelerationY(.microbitGravity))
                            self.valuesTableViewController.setMicrobitValue(accelerometerValues.z,
                                                                            forMicrobitMeasurement: .accelerationZ(.microbitGravity))
                            
                            return .continueNotifications
                        })
                        
                    default:
                        break
                    }
                }
            }
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
                    connectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12.0),
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
        
        let message = PlaygroundValue.fromActionType(.connectionChanged)
        self.containerViewController.send(message)
        
        self.pairButton.isHidden = true
        self.bluetoothController.view.isHidden = false
        
        self.microbitMimic.isActive = false
        
        var characteristicUUID: BTMicrobit.CharacteristicUUID?
        // Get the microbit image and cache it.
        characteristicUUID = .ledStateUUID
        microbit.readValueForCharacteristic(characteristicUUID!,
                                            handler: {(characteristic: CBCharacteristic, error: Error?) in
                                                
                                                if let data = characteristic.value {
                                                    //self.logMessage("I got image: \(data as! NSData)")
                                                    self.microbitMimic.microbitImage = MicrobitImage(data)
                                                }
        })
        
        characteristicUUID = .ledScrollingDelayUUID
        microbit.readValueForCharacteristic(characteristicUUID!,
                                            handler: {(characteristic: CBCharacteristic, error: Error?) in
                                                
                                                if let data = characteristic.value {
                                                    if let scrollingDelay = data.integerFromLittleUInt16 {
                                                        //self.logMessage("Default scrolling delay: \(scrollingDelay)")
                                                        self.microbitMimic.scrollingDelay = scrollingDelay
                                                    }
                                                }
        })
        
        characteristicUUID = .buttonStateAUUID
        microbit.setNotifyValue(true,
                                forCharacteristicUUID: characteristicUUID!,
                                handler: {(characteristic: CBCharacteristic, error: Error?) in
                                    if let data = characteristic.value {
                                        let buttonState = BTMicrobit.ButtonState(data) ?? BTMicrobit.ButtonState.notPressed
                                        self.microbitMimic.showButtonAPressed(buttonState != .notPressed)
                                        return .continueNotifications
                                    }
                                    return .stopNotifications
        })
        
        characteristicUUID = .buttonStateBUUID
        microbit.setNotifyValue(true,
                                forCharacteristicUUID: characteristicUUID!,
                                handler: {(characteristic: CBCharacteristic, error: Error?) in
                                    if let data = characteristic.value {
                                        let buttonState = BTMicrobit.ButtonState(data) ?? BTMicrobit.ButtonState.notPressed
                                        self.microbitMimic.showButtonBPressed(buttonState != .notPressed)
                                        return .continueNotifications
                                    }
                                    return .stopNotifications
        })
        
        self.setupValuesTable()
    }
    
    public func btManager(_ manager: BTManager,
                          didDisconnectMicrobit microbit: BTMicrobit?,
                          error: Error?) {
        
        let message = PlaygroundValue.fromActionType(.connectionChanged)
        self.containerViewController.send(message)
        
        self.pairButton.isHidden = false
        self.microbitMimic.resetInterface()
        self.microbitMimic.isActive = true
        self.setupValuesTable()
    }
    
    public func btManager(_ manager: BTManager,
                          didFailToConnectToPeripheral peripheral: CBPeripheral,
                          error: Error?) {
        
        // If we fail to connect to a micro:bit then should we remove its UUID from the list of paired devices.
        // This maybe because the pairing information was deleted from the iOS device's Settings
        // However, sometimes we fail to connect for other reasons, then we lose the micro:bit's name.
        // Commenting this code temporarily.
        /*if error != nil {
            if var devicesMappingDict = manager.pairedDeviceMappings {
                devicesMappingDict[String(describing: peripheral.identifier)] = nil
                manager.pairedDeviceMappings = devicesMappingDict
            }
        }*/
        
        self.pairButton.isHidden = false
        self.microbitMimic.isActive = true
    }
    
    // This delegate is not called if the array is empty - there is at least one missing service.
    public func btManager(_ manager: BTManager,
                          didTimeoutReadingServices services: Array<BTMicrobit.ServiceUUID>) {
        
        //self.logMessage("Did timeout reading services: \(services)")
        
        // Don't display this message if we are not the root view controller
        // Might be pairing and not all services appear
        
        // Commenting this as sometimes it is called incorrectly and will confuse users.
        // Requires further testing. It may not even be possible to accurately determine when services are missing.
        
        /*
         if self.navigationController?.viewControllers.count == 1 {
         var message = "The following Bluetooth services cannot be discovered:\n"
         for serviceUUID in services {
         message += String(describing: serviceUUID) + "\n"
         }
         message += "You will need to flash your micro:bit with a hex file that enables the required services."
         let alertController = UIAlertController(title: "Bluetooth Services",
         message: message,
         preferredStyle: .alert
         )
         let action = UIAlertAction(title: "OK", style: .default, handler: {(action) in
         self.dismiss(animated: true)
         })
         alertController.addAction(action)
         self.present(alertController, animated: true)
         }*/
    }
    
    public func btManager(_ manager: BTManager,
                          didPairToMicrobit microbit: BTMicrobit?,
                          error: BTManager.PairingError?) {
        
        if let peripheral = microbit?.peripheral, let microbitName = self.btManager.microbitNameForPeripheral(peripheral) {
            
            // Ensure peripheral is renamed after pairing
            if let btConnectionView = bluetoothController.view as? PlaygroundBluetoothConnectionView {
                btConnectionView.setName(microbitName, forPeripheral: peripheral)
            }
        }
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
    
    @IBAction public func shareData(_ sender: UIButton) {
        
        var activityItems = [Any]()
        
        /*if let activityItem = self.dataActivityItem {
         activityItems.append(activityItem)
         }*/
        
        let fileManager = FileManager()
        let fileURL = fileManager.temporaryDirectory.appendingPathComponent("DataStore.csv")
        do {
            try self.dataActivityItem?.data.write(to: fileURL)
            activityItems.append(fileURL)
        } catch {
            // Handle the write error?
        }
        
        if activityItems.count > 0 {
            let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: [])
            if let popoverController = activityController.popoverPresentationController {
                popoverController.sourceView = sender.superview
                popoverController.sourceRect = sender.frame
            }
            self.present(activityController, animated: true, completion: nil)
        }
    }
}

public protocol LoggingProtocol: AnyObject {
    
    func logMessage(_ message: String)
}
