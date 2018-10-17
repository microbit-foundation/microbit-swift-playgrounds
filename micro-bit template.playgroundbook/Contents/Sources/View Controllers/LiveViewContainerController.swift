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

@objc(LiveViewContainerController)
public class LiveViewContainerController: UIViewController, PlaygroundLiveViewSafeAreaContainer {
    
    public var microbitMeasurements: Array<MicrobitMeasurement> = []
    
    var liveViewNavigationController: LiveViewNavigationController!
    var proxyConnectionIsOpen = false
    var receivingEvents = false
    var lastDisplayUpdate = Date()
    var displayUpdateTimer: Timer? = nil
    
    @IBOutlet weak var containerView: UIView!
    
    public static func controllerFromStoryboard(_ storyboardName: String) -> LiveViewContainerController {
        
        let bundle = Bundle(for: LiveViewContainerController.self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! LiveViewContainerController
        
        return controller
    }
    
    override public func prepare(for seque: UIStoryboardSegue, sender: Any?) {
        
        if seque.identifier == "embedNavigationControllerSegue" {
            liveViewNavigationController = seque.destination as! LiveViewNavigationController
            self.addChildViewController(liveViewNavigationController)
            self.liveViewController.containerViewController = self
        }
    }
    
    override public func viewDidLoad() {
        if let containerView = self.containerView {
            //self.liveViewController.logMessage("view did load safe area: \(self.liveViewSafeAreaGuide)")
            containerView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                containerView.topAnchor.constraint(equalTo: self.liveViewSafeAreaGuide.topAnchor, constant: 0.0),
                containerView.leadingAnchor.constraint(equalTo: self.liveViewSafeAreaGuide.leadingAnchor, constant: 0.0),
                containerView.trailingAnchor.constraint(equalTo: self.liveViewSafeAreaGuide.trailingAnchor, constant: 0.0),
                containerView.bottomAnchor.constraint(equalTo: self.liveViewSafeAreaGuide.bottomAnchor, constant: 0.0)
                ])
        }
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setChildsConstraintsFromSize(self.view.frame.size)
    }
    
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        self.setChildsConstraintsFromSize(size)
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func setChildsConstraintsFromSize(_ size: CGSize) {
        
        let ratio = size.width / size.height
        let horizontalSizeClass = UITraitCollection(horizontalSizeClass: ratio > 1 ? .regular : .compact)
        let verticalSizeClass = UITraitCollection(verticalSizeClass: ratio > 1 ? .compact : .regular)
        let newTraitsCollection = UITraitCollection(traitsFrom: [horizontalSizeClass, verticalSizeClass])
        
        //self.liveViewController.logMessage("I got called \(newTraitsCollection)")
        for childViewController in self.childViewControllers {
            self.setOverrideTraitCollection(newTraitsCollection, forChildViewController: childViewController)
        }
    }
    
    public var liveViewController: LiveViewController {
        get {
            return self.liveViewNavigationController!.viewControllers.first as! LiveViewController
        }
    }
    
    //MARK: - ValuesTableViewDataSourceProtocol
    
    public func addMicrobitMeasurement(_ microbitMeasurement: MicrobitMeasurement) {
        //self.liveViewController.logMessage("adding value description")
        microbitMeasurements.append(microbitMeasurement)
    }
}

extension LiveViewContainerController: PlaygroundLiveViewMessageHandler, MicrobitMimicDelegate {
    
    public func liveViewMessageConnectionOpened() {
        
        self.proxyConnectionIsOpen = true
        self.liveViewController.dataActivityItem = nil
        //liveViewController.logMessage("liveViewMessageConnectionOpened")
        
        // When the connection opens register for event notifications
        if let microbit = self.liveViewController.btManager.microbit {
            if !receivingEvents {
                microbit.setNotifyValueForMicrobitEvent(true, handler: {
                    (characteristic: CBCharacteristic, error: Error?) in
                    
                    if let eventData = characteristic.value {
                        if eventData.count % MemoryLayout<BTMicrobit.Event>.stride == 0 {
                            //let eventArray = eventData.toArray(type: BTMicrobit.Event.self)
                            //self.liveViewController.logMessage("micro:bit event array: + \(eventData as NSData)")
                            let message = PlaygroundValue.fromActionType(.requestEvent,
                                                                         data: eventData)
                            self.send(message)
                        }
                    }
                    return self.proxyConnectionIsOpen ? .continueNotifications : .stopNotifications
                })
                receivingEvents = true
            }
        } else {
            self.liveViewController.microbitMimic.isActive = true
            self.liveViewController.microbitMimic.delegate = self
        }
        
        // The connection is open and the ContentMessenger needs to have it's cached image set.
        let returnedMessage = PlaygroundValue.fromActionType(.readData,
                                                             characteristicUUID: .ledStateUUID,
                                                             data: self.liveViewController.cachedMicrobitImage.imageData)
        self.send(returnedMessage)
    }
    
    public func liveViewMessageConnectionClosed() {
        
        self.proxyConnectionIsOpen = false
        self.liveViewController.microbitMimic.delegate = nil
        //self.liveViewController.logMessage("liveViewMessageConnectionClosed")
        // We need to stop receiving events otherwise they appear more than once when re-running content code.
        // We do not however clear the micro:bit's handlers when the connection closes as
        // this stops the values table from updating - instead we need to just clear the handlers from the content code.
        if let microbit = self.liveViewController.btManager.microbit {
            microbit.setNotifyValueForMicrobitEvent(false)
            receivingEvents = false
        }
    }
    
    public func receive(_ message: PlaygroundValue) {
        
        let liveViewController = self.liveViewController
        //liveViewController.logMessage("Received message: \(message)")
        
        if let actionType = message.actionType {
            
            let microbit = liveViewController.btManager.microbit
            
            switch actionType {
                
            case .readData:
                guard let characteristicUUID = message.characteristicUUID else { return }
                switch characteristicUUID {
                    
                case .ledStateUUID:
                    let returnedMessage = PlaygroundValue.fromActionType(actionType,
                                                                         characteristicUUID: characteristicUUID,
                                                                         data: self.liveViewController.cachedMicrobitImage.imageData)
                    self.send(returnedMessage)
                    
                default:
                    microbit?.readValueForCharacteristic(characteristicUUID,
                                                         handler: {(characteristic, error) in
                                                            let returnedMessage = PlaygroundValue.fromActionType(actionType,
                                                                                                                 characteristicUUID: characteristicUUID,
                                                                                                                 data: characteristic.value)
                                                            //liveViewController.logMessage("Received data: \(characteristic.value as! NSData)")
                                                            self.send(returnedMessage)
                    })
                    break;
                }
                
            case .writeData:
                guard let characteristicUUID = message.characteristicUUID else { return }
                if let data = message.data {
                    
                    var doWriteData = true
                    switch characteristicUUID {
                        
                    case .ledStateUUID:
                        
                        if self.liveViewController.cachedMicrobitImage.imageData != data { // If the image hasn't changed, do nothing
                            
                            self.displayUpdateTimer?.invalidate() // Invalidate any update timers
                            self.displayUpdateTimer = nil
                            
                            self.liveViewController.cachedMicrobitImage = MicrobitImage(data) // Update the cached image anyway
                            
                            if self.lastDisplayUpdate.timeIntervalSinceNow > -0.1 { // Allow 100ms between updates to the micro:bit because of Bluetooth latency
                                doWriteData = false
                                //self.liveViewController.logMessage("Setting timer for \(0.1 + self.lastDisplayUpdate.timeIntervalSinceNow)")
                                self.displayUpdateTimer = Timer.scheduledTimer(withTimeInterval: max(0.1 + self.lastDisplayUpdate.timeIntervalSinceNow, 0.001),
                                                                               repeats: false,
                                                                               block: {(timer) in
                                                                                //self.liveViewController.logMessage("timer called \(timer))")
                                                                                microbit?.writeValue(data,
                                                                                                     forCharacteristicUUID: characteristicUUID,
                                                                                                     handler: {(characteristic, error) in
                                                                                                        let returnedMessage = PlaygroundValue.fromActionType(actionType,
                                                                                                                                                             characteristicUUID: characteristicUUID,
                                                                                                                                                             data: characteristic.value)
                                                                                                        self.send(returnedMessage)
                                                                                })
                                                                                self.lastDisplayUpdate = Date()
                                })
                            } else {
                                self.lastDisplayUpdate = Date()
                            }
                        } else {
                            doWriteData = false
                        }
                        
                    case .ledTextUUID:
                        if let text = String(data: data, encoding: .utf8) {
                            self.liveViewController.microbitMimic.scrollText(text)
                        }
                        
                    case .ledScrollingDelayUUID:
                        if let scrollingDelay = data.integerFromLittleUInt16 {
                            self.liveViewController.microbitMimic.scrollingDelay = scrollingDelay
                        }
                        
                    case .accelerometerPeriodUUID:
                        if let accelerometerPeriod = data.integerFromLittleUInt16,
                            let period = BTMicrobit.AccelerometerPeriod(rawValue: accelerometerPeriod) {
                            self.liveViewController.microbitMimic.accelerometerPeriod = period
                        }
                        
                    default:
                        break
                    }
                    if doWriteData {
                        microbit?.writeValue(data,
                                             forCharacteristicUUID: characteristicUUID,
                                             handler: {(characteristic, error) in
                                                let returnedMessage = PlaygroundValue.fromActionType(actionType,
                                                                                                     characteristicUUID: characteristicUUID,
                                                                                                     data: characteristic.value)
                                                self.send(returnedMessage)
                        })
                    }
                }
                
            case .startNotifications:
                guard let characteristicUUID = message.characteristicUUID else { return }
                microbit?.setNotifyValue(true,
                                         forCharacteristicUUID: characteristicUUID,
                                         handler: notificationsHandler)
                
                switch characteristicUUID {
                    
                case .accelerometerDataUUID:
                    self.liveViewController.microbitMimic.addAccelerometerHandler({ accelerometerValues in
                        
                        let returnedMessage = PlaygroundValue.fromActionType(.startNotifications,
                                                                             characteristicUUID: .accelerometerDataUUID,
                                                                             data: accelerometerValues.microbitData)
                        self.send(returnedMessage)
                        return self.proxyConnectionIsOpen ? .continueNotifications : .stopNotifications
                    })
                    
                default:
                    break
                }
                break
                
            case .stopNotifications:
                break
                
            case .requestEvent:
                if let data = message.data, let event = BTMicrobit.Event(data) {
                    
                    //liveViewController.logMessage("Data: + \(data as! NSData)")
                    // Start the mimic's accelerometer for non-shake gestures to enable events to be sent.
                    if case let .gesture(_, gesture) = event {
                        if gesture != .shake {
                            self.liveViewController.microbitMimic.addAccelerometerHandler({ accelerometerValues in
                                return self.proxyConnectionIsOpen ? .continueNotifications : .stopNotifications
                            })
                        }
                    }
                    
                    microbit?.addEvent(event, handler: {(characteristic, error) in
                        //liveViewController.logMessage("Added event: + \(event)")
                    })
                }
                
            case .removeEvent:
                break
                
            case .connectionChanged:
                break
                
            case .shareData:
                if let data = message.data, let uti = message.uti {
                    liveViewController.dataActivityItem = DataActivityItemSource(data: data, uti: uti)
                } else {
                    liveViewController.dataActivityItem = nil
                }
                break
                
            case .logMessage:
                if let data = message.data, let stringMessage = String(data: data, encoding: .utf8) {
                    liveViewController.logMessage(stringMessage)
                }
            }
        }
    }
    
    //MARK: - Private Functions
    
    func notificationsHandler(characteristic: CBCharacteristic, error: Error?) -> BTPeripheral.NotificationAction {
        
        //liveViewController.logMessage("Notification Handler Data: + \(characteristic.value as! NSData)")
        guard let characteristicUUID = BTMicrobit.CharacteristicUUID(rawValue: characteristic.uuid.uuidString) else { return .stopNotifications}
        let returnedMessage = PlaygroundValue.fromActionType(.startNotifications,
                                                             characteristicUUID: characteristicUUID,
                                                             data: characteristic.value)
        self.send(returnedMessage)
        return self.proxyConnectionIsOpen ? .continueNotifications : .stopNotifications
    }
    
    //MARK: - MicrobitMimicDelegate
    
    public func microbitMimic(_ microbitMimic: MicrobitMimic, didGenerateEvent event: BTMicrobit.Event) {
        let message = PlaygroundValue.fromActionType(.requestEvent,
                                                     data: event.microbitData)
        self.send(message)
    }
    
    public func microbitMimic(_ microbitMimic: MicrobitMimic, didGenerateData data: Data,
                              forCharacteristicUUID characteristicUUID: BTMicrobit.CharacteristicUUID) {
        
        let returnedMessage = PlaygroundValue.fromActionType(.startNotifications,
                                                             characteristicUUID: characteristicUUID,
                                                             data: data)
        self.send(returnedMessage)
    }
}
