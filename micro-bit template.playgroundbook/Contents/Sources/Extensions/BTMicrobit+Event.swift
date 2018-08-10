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
    
    public enum Event : Hashable {
        
        case buttonA(EventType, ButtonEvent)
        case buttonB(EventType, ButtonEvent)
        case buttonAB(EventType, ButtonEvent)
        case gesture(EventType, Gesture)
        
        public enum EventType : UInt16 {
            case buttonA = 1
            case buttonB = 2
            case buttonAB = 26
            case gesture = 27
        }
        
        public enum Gesture : UInt16 {
            case none = 0
            case tiltUp = 1
            case tiltDown = 2
            case tiltLeft = 3
            case tiltRight = 4
            case faceUp = 5
            case faceDown = 6
            case freeFall = 7
            case threeG = 8
            case sixG = 9
            case eightG = 10
            case shake = 11
        }
        
        public enum ButtonEvent: UInt16 {
            case down = 1
            case up = 2
            case click = 3
            case longClick = 4
            case hold = 5
            case doubleClick = 6
        }
        
        public init(button: BTMicrobit.Button, buttonEvent: ButtonEvent) {
            
            let eventType = EventType(rawValue: button.rawValue)
            switch button {
                
            case .A:
                self = .buttonA(eventType!, buttonEvent)
                
            case .B:
                self = .buttonB(eventType!, buttonEvent)
                
            case .AB:
                self = .buttonAB(eventType!, buttonEvent)
            }
        }
        
        public init(_ value: Gesture) {
            self = .gesture(.gesture, value)
        }
        
        public init?(_ data: Data) {
            
            let valuesArray = data.toArray(type: UInt16.self)
            guard valuesArray.count >= 1 else {return nil}
            guard let eventType = EventType(rawValue: UInt16(littleEndian: valuesArray[0])) else { return nil }
            switch eventType {
                
            case .buttonA, .buttonB, .buttonAB:
                guard let buttonEvent = ButtonEvent(rawValue: UInt16(littleEndian: valuesArray[1])) else { return nil }
                self = Event(button: BTMicrobit.Button(rawValue: eventType.rawValue)!, buttonEvent: buttonEvent)
                
            case .gesture:
                guard let value = Gesture(rawValue: UInt16(littleEndian: valuesArray[1])) else { return nil }
                self = .gesture(eventType, value)
                
            }
        }
        
        public var microbitData: Data! {
            get {
                switch self {
                    
                case let .gesture(type, value):
                    return Data(fromArray: [type.rawValue.littleEndian, value.rawValue.littleEndian])
                    
                case let .buttonA(type, value):
                    return Data(fromArray: [type.rawValue.littleEndian, value.rawValue.littleEndian])
                    
                case let .buttonB(type, value):
                    return Data(fromArray: [type.rawValue.littleEndian, value.rawValue.littleEndian])
                    
                case let .buttonAB(type, value):
                    return Data(fromArray: [type.rawValue.littleEndian, value.rawValue.littleEndian])
                    
                //default:
                  //  return nil
                }
            }
        }
    }
}
