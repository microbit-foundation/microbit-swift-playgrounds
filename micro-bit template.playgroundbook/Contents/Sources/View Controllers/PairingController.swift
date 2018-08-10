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

@objc(PairingController)
public class PairingController: UIViewController {
    
    var friendlyNameCode = [0, 0, 0, 0, 0]
    public var btManager: BTManager?
    
    @IBOutlet weak var cancelButton: UIButton?
    @IBOutlet weak var mainActionButton: UIButton?
    @IBOutlet weak var ledStackView: UIStackView?
    @IBOutlet weak var microbitNameLabel: UILabel?
    @IBOutlet weak var pairingStatusLabel: UILabel?
    @IBOutlet weak var pairingStatusImageView: UIImageView?
    
    @IBAction public func dismissController(_ sender: UIButton) {
        
        self.navigationController?.popToRootViewController(animated:true)
    }
    
    @IBAction public func nextController(_ sender: UIButton) {
        
        let controllerID = String(format: "PairingControllerID%d", sender.tag)
        if let pairingController = self.storyboard?.instantiateViewController(withIdentifier: controllerID) as? PairingController {
            pairingController.friendlyNameCode = self.friendlyNameCode
            pairingController.btManager = self.btManager
            self.navigationController?.pushViewController(pairingController, animated:true)
        }
    }
    
    @IBAction public func ledTapped(_ sender: UIButton) {
        
        let column = sender.tag / 5
        for tag in column * 5...column * 5 + 4 {
            if let ledButton = self.ledStackView?.viewWithTag(tag) {
                ledButton.layer.backgroundColor = tag <= sender.tag ? UIColor.red.cgColor : UIColor.clear.cgColor
            }
        }
        
        friendlyNameCode[column] = sender.tag % 5
        microbitNameLabel?.text = self.microbitPeripheralName
    }
    
    @IBAction public func startPairing(_ sender: UIButton) {
        
        mainActionButton?.isEnabled = false
        pairingStatusLabel?.text = "Searching for:\n" + self.microbitPeripheralName + "…"
        pairingStatusImageView?.image = UIImage(named: "thinking-emoji")
        
        self.btManager?.beginPairingWithMicrobitName(self.microbitPeripheralName,
                                                     handler: {microbit, error in
                                                        
                                                        if error == nil {
                                                            if let microbit = microbit {
                                                                
                                                                var devicesMappingDict = self.btManager?.pairedDeviceMappings
                                                                if devicesMappingDict == nil {
                                                                    devicesMappingDict = [String: PlaygroundValue]()
                                                                }
                                                                devicesMappingDict![String(describing: microbit.peripheral.identifier)] = .string(self.microbitPeripheralName)
                                                                self.btManager?.pairedDeviceMappings = devicesMappingDict
                                                                
                                                                self.pairingStatusLabel?.text = "Pairing successful!\nPress the RESET button on the micro:bit and tap Finish."
                                                                self.pairingStatusImageView?.image = UIImage(named: "well-done-emoji")
                                                                self.mainActionButton?.isEnabled = true
                                                                self.mainActionButton?.setTitle("Finished", for: .normal)
                                                                self.mainActionButton?.removeTarget(self, action: #selector(self.startPairing(_:)), for: .touchUpInside)
                                                                self.mainActionButton?.addTarget(self, action: #selector(self.dismissController(_:)), for: .touchUpInside)
                                                                self.cancelButton?.removeFromSuperview()
                                                            }
                                                        } else {
                                                            self.pairingStatusLabel?.text = error!.localizedDescription
                                                            self.pairingStatusImageView?.image = UIImage(named: "fail-emoji")
                                                            self.mainActionButton?.setTitle("Pair Again", for: .normal)
                                                            self.mainActionButton?.isEnabled = true
                                                        }
                                                        
        })
    }
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        
        pairingStatusLabel?.text = nil
        pairingStatusImageView?.image = nil
        ledStackView?.layer.backgroundColor = UIColor.black.cgColor
        
        for tag in 0...24 {
            if let ledButton = self.ledStackView?.viewWithTag(tag) as? UIButton{
                ledButton.backgroundColor = UIColor.clear
                ledButton.layer.borderWidth = 2.0
                ledButton.layer.borderColor = UIColor.yellow.cgColor
                ledButton.layer.cornerRadius = 2.0
                ledButton.layer.backgroundColor = tag % 5 == 0 ? UIColor.red.cgColor : UIColor.clear.cgColor
                ledButton.addTarget(self, action: #selector(ledTapped(_:)), for: .touchDown)
            }
        }
        
        microbitNameLabel?.text = self.microbitPeripheralName
    }
    
    var microbitPeripheralName: String {
        get {
            return "BBC micro:bit [" + BTMicrobit.friendlyNameFromCode(friendlyNameCode) + "]"
        }
    }
    
    //MARK: - External Functions
}

extension BTMicrobit {
    
    static func friendlyNameFromCode(_ code: Array<Int>) -> String {
        
        let codebook = [["z", "v", "g", "p", "t"],
                        ["u", "o", "i", "e", "a"],
                        ["z", "v", "g", "p", "t"],
                        ["u", "o", "i", "e", "a"],
                        ["z", "v", "g", "p", "t"]]
        
        var column = 0
        return code.reduce(into: String(), {friendlyName, index in
            friendlyName += codebook[column][index]
            column += 1
        })
    }
}


/*@objc(PairingLabel)
 public class PairingLabel: UILabel {
 
 override public func awakeFromNib() {
 super.awakeFromNib()
 self.layer.cornerRadius = 21.0
 self.clipsToBounds = true
 self.backgroundColor = UIColor(white: 1.0, alpha: 0.75)
 }
 
 override public func drawText(in rect: CGRect) {
 let insets = UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)
 super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
 }
 
 override open var intrinsicContentSize: CGSize {
 get {
 let size = super.intrinsicContentSize
 return CGSize(width: size.width + 26.0, height: size.height + 24.0)
 }
 }
 }
 */
