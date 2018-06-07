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

extension LiveViewContainerController: PlaygroundLiveViewMessageHandler {
    
    public func liveViewMessageConnectionOpened() {
        
        //liveViewNavigationController.logMessage("liveViewMessageConnectionOpened")
        
        // When the connection opens register for event notifications
        if let microbit = self.liveViewController.btManager.microbit {
            microbit.setNotifyValueForMicrobitEvent(true, handler: {
                (characteristic: CBCharacteristic, handlerType, error: Error?) in
                
                if let eventData = characteristic.value {
                    if eventData.count % MemoryLayout<BTMicrobit.Event>.stride == 0 {
                        //let eventArray = eventData.toArray(type: BTMicrobit.Event.self)
                        self.liveViewController.logMessage("micro:bit event array: + \(eventData as NSData)")
                        let message = PlaygroundValue.fromActionType(ContentMessenger.ActionType.requestEvent,
                                                                     data: eventData)
                        self.send(message)
                    }
                }
            })
        }
    }
    
    public func liveViewMessageConnectionClosed() {
        
        //liveViewController.logMessage("liveViewMessageConnectionClosed")
        // We need to clear the micro:bit's handlers when the connection closes.
        if let microbit = self.liveViewController.btManager.microbit {
            microbit.clearHandlers()
            microbit.setNotifyValueForMicrobitEvent(false)
        }
    }
    
    public func receive(_ message: PlaygroundValue) {
        
        let liveViewController = self.liveViewController
        liveViewController.logMessage("Received message: \(message)")
        
        if let actionType = message.actionType {
            
            guard let microbit = liveViewController.btManager.microbit else { return }
            
            switch actionType {
                
            case .readData:
                guard let characteristicUUID = message.characteristicUUID else { return }
                if characteristicUUID == .ledStateUUID {
                    let returnedMessage = PlaygroundValue.fromActionType(.readData,
                                                                         characteristicUUID: characteristicUUID,
                                                                         data: self.liveViewController.cachedMicrobitImage.imageData)
                    self.send(returnedMessage)
                } else {
                }
                
            case .writeData:
                guard let characteristicUUID = message.characteristicUUID else { return }
                if let data = message.data {
                    if characteristicUUID == .ledStateUUID {
                        self.liveViewController.cachedMicrobitImage = MicrobitImage(data)
                    }
                    microbit.writeValue(data,
                                        forCharacteristicUUID: characteristicUUID,
                                        handler: {(characteristic, handlerType, error) in})
                }
                
            case .requestEvent:
                if let data = message.data, let event = BTMicrobit.Event(data) {
                    
                    liveViewController.logMessage("Data: + \(data as! NSData)")
                    microbit.addEvent(event, handler: {(characteristic, handlerType, error) in
                        liveViewController.logMessage("added event: + \(event)")
                    })
                }
                
            default:
                break
            }
        }
    }
}
