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
import PlaygroundBluetooth
import PlaygroundSupport

@objc(BluetoothConnectionViewController)
public class BluetoothConnectionViewController: UIViewController, PlaygroundBluetoothConnectionViewDelegate, PlaygroundBluetoothConnectionViewDataSource {
    
    var btManager: BTManager!
    public weak var messageLogger: LoggingProtocol?
    
    public init(bluetoothManager: BTManager) {
        
        super.init(nibName: nil, bundle: nil)
        self.btManager = bluetoothManager
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func loadView() {
        
        let connectionView = PlaygroundBluetoothConnectionView(centralManager: self.btManager.bluetoothCentralManager,
                                                               delegate: self)
        connectionView.dataSource = self
        self.view = connectionView
    }
    
    //MARK: - PlaygroundBluetoothConnectionViewDelegate Functions
    
    public func connectionView(_ connectionView: PlaygroundBluetoothConnectionView,
                               titleFor state: PlaygroundBluetoothConnectionView.State) -> String {
        
        // Pick a name that matches the types of peripheral your playground
        // supports, such as "Robot", "Speaker", or "Light".
        let name = "micro:bit"
        switch state {
        case .noConnection:
            return "Connect \(name)"
        case .connecting:
            return "Connecting \(name)"
        case .searchingForPeripherals:
            return "Searching for paired \(name)s"
        case .selectingPeripherals:
            return "Select a \(name)"
        case .connectedPeripheralFirmwareOutOfDate:
            return "Connect to a different \(name)"
        }
    }
    
    public func connectionView(_ connectionView: PlaygroundBluetoothConnectionView,
                               shouldDisplayDiscovered peripheral: CBPeripheral,
                               withAdvertisementData advertisementData: [String : Any]?,
                               rssi: Double) -> Bool {
        
        //self.messageLogger?.logMessage("Peripheral: \(peripheral)")
        return self.btManager.microbitNameForPeripheral(peripheral) != nil // Only display 'known' microbit peripherals
    }
    
    public func connectionView(_ connectionView: PlaygroundBluetoothConnectionView,
                               firmwareUpdateInstructionsFor peripheral: CBPeripheral) -> String {
        return ""
    }
    
    //MARK: - PlaygroundBluetoothConnectionViewDataSource Functions
    
    public func connectionView(_ connectionView: PlaygroundBluetoothConnectionView,
                               itemForPeripheral peripheral: CBPeripheral,
                               withAdvertisementData advertisementData: [String: Any]?) -> PlaygroundBluetoothConnectionView.Item {
        
        let icon = UIImage(named: "microbit-bt-icon")!
        let issueIcon = UIImage(named: "microbit-bt-icon")!
        
        var name = self.btManager.microbitNameForPeripheral(peripheral)
        if name == nil {
            if let advertisedName = advertisementData?[CBAdvertisementDataLocalNameKey] as? String {
                name = advertisedName
            } else {
                name = "BBC micro:bit"
            }
        }
        
        return .init(name: name!, icon: icon, issueIcon: issueIcon, firmwareStatus: .upToDate)
    }
}
