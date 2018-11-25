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

extension BTMicrobit {
    
    // MARK:- Service UUIDs
    
    public enum ServiceUUID: String, CustomStringConvertible {
        
        case genericAccessUUID = "00001800-0000-1000-8000-00805F9B34FB"
        case deviceInformationUUID = "0000180A-0000-1000-8000-00805F9B34FB"
        
        case dfuControlUUID = "E95D93B0-251D-470A-A062-FA1922DFA9A8"
        
        case ledUUID = "E95DD91D-251D-470A-A062-FA1922DFA9A8"
        case buttonUUID = "E95D9882-251D-470A-A062-FA1922DFA9A8"
        case accelerometerUUID = "E95D0753-251D-470A-A062-FA1922DFA9A8"
        case magnetometerUUID = "E95DF2D8-251D-470A-A062-FA1922DFA9A8"
        case temperatureUUID = "E95D6100-251D-470A-A062-FA1922DFA9A8"
        case ioPinUUID = "E95D127B-251D-470A-A062-FA1922DFA9A8"
        case uartUUID = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
        
        case eventUUID = "E95D93AF-251D-470A-A062-FA1922DFA9A8"
        
        public var description: String {
            switch self {
            case .genericAccessUUID:
                return "Generic Access Service"
            case .deviceInformationUUID:
                return "Device Information Service"
            case .dfuControlUUID:
                return "DFU Control Service"
            case .ledUUID:
                return "LED Display Service"
            case .buttonUUID:
                return "Button Service"
            case .accelerometerUUID:
                return "Accelerometer Service"
            case .magnetometerUUID:
                return "Magnetometer Service"
            case .temperatureUUID:
                return "Temperature Service"
            case .ioPinUUID:
                return "IO Pin Service"
            case .uartUUID:
                return "UART Service"
            case .eventUUID:
                return "Event Service"
            }
        }
    }
    
    // MARK:- Characterisitic UUIDs
    
    public enum CharacteristicUUID: String {
        
        case dfuControlUUID = "E95D93B1-251D-470A-A062-FA1922DFA9A8"
        
        case ledStateUUID = "E95D7B77-251D-470A-A062-FA1922DFA9A8"
        case ledTextUUID = "E95D93EE-251D-470A-A062-FA1922DFA9A8"
        case ledScrollingDelayUUID = "E95D0D2D-251D-470A-A062-FA1922DFA9A8"
        
        case buttonStateAUUID = "E95DDA90-251D-470A-A062-FA1922DFA9A8"
        case buttonStateBUUID = "E95DDA91-251D-470A-A062-FA1922DFA9A8"
        
        case accelerometerPeriodUUID = "E95DFB24-251D-470A-A062-FA1922DFA9A8"
        case accelerometerDataUUID = "E95DCA4B-251D-470A-A062-FA1922DFA9A8"
        
        case magnetometerPeriodUUID = "E95D386C-251D-470A-A062-FA1922DFA9A8"
        case magnetometerDataUUID = "E95DFB11-251D-470A-A062-FA1922DFA9A8"
        case magnetometerBearingUUID = "E95D9715-251D-470A-A062-FA1922DFA9A8"
        
        case temperaturePeriodUUID = "E95D1B25-251D-470A-A062-FA1922DFA9A8"
        case temperatureDataUUID = "E95D9250-251D-470A-A062-FA1922DFA9A8"
        
        case pinDataUUID = "E95D8D00-251D-470A-A062-FA1922DFA9A8"
        case pinADConfigurationUUID = "E95D5899-251D-470A-A062-FA1922DFA9A8"
        case pinIOConfigurationUUID = "E95DB9FE-251D-470A-A062-FA1922DFA9A8"
        case pinPWMControlUUID = "E95DD822-251D-470A-A062-FA1922DFA9A8"
        
        case uartTX = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
        case uartRX = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"
        
        case eventMicrobitRequirementsUUID = "E95DB84C-251D-470A-A062-FA1922DFA9A8"
        case eventMicrobitEventUUID = "E95D9775-251D-470A-A062-FA1922DFA9A8"
        case eventClientRequirementsUUID = "E95D23C4-251D-470A-A062-FA1922DFA9A8"
        case eventClientEventUUID = "E95D5404-251D-470A-A062-FA1922DFA9A8"
        
        public var serviceUUID: ServiceUUID {
            get {
                switch self {
                case .dfuControlUUID:
                    return .dfuControlUUID
                    
                case .ledStateUUID, .ledTextUUID, .ledScrollingDelayUUID:
                    return .ledUUID
                    
                case .buttonStateAUUID, .buttonStateBUUID:
                    return .buttonUUID
                    
                case .accelerometerPeriodUUID, .accelerometerDataUUID:
                    return .accelerometerUUID
                    
                case .magnetometerPeriodUUID, .magnetometerDataUUID, .magnetometerBearingUUID:
                    return .magnetometerUUID
                    
                case .temperaturePeriodUUID, .temperatureDataUUID:
                    return .temperatureUUID
                    
                case .pinDataUUID, .pinADConfigurationUUID, .pinIOConfigurationUUID, .pinPWMControlUUID:
                    return .ioPinUUID
                    
                case .eventMicrobitRequirementsUUID, .eventMicrobitEventUUID, .eventClientRequirementsUUID, .eventClientEventUUID:
                    return .eventUUID
                    
                case .uartTX, .uartRX:
                    return .uartUUID
                }
            }
        }
    }
}
