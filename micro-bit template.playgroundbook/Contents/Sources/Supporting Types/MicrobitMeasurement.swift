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

public enum MicrobitMeasurement : Equatable {
    case accelerationX(UnitAcceleration)
    case accelerationY(UnitAcceleration)
    case accelerationZ(UnitAcceleration)
    case bearing(UnitAngle)
    case temperature(UnitTemperature)
    case pin0(UnitMicrobitGPIO)
    case pin1(UnitMicrobitGPIO)
    case pin2(UnitMicrobitGPIO)
    
    public var name: String {
        get {
            switch self {
            case .accelerationX:
                return "Accelerometer: X"
            case .accelerationY:
                return "Accelerometer: Y"
            case .accelerationZ:
                return "Accelerometer: Z"
            case .bearing:
                return "Compass Heading"
            case .temperature:
                return "Temperature"
            case .pin0:
                return "Pin 0"
            case .pin1:
                return "Pin 1"
            case .pin2:
                return "Pin 2"
            }
        }
    }
    
    public func displayMeasurementFromMicrobitValue(_ value: Double) -> Measurement<Unit> {
        
        switch self {
        case let .accelerationX(displayUnitType):
            let convertedMeasurement = Measurement(value: value, unit: UnitAcceleration.microbitGravity).converted(to: displayUnitType)
            return Measurement(value: convertedMeasurement.value, unit: convertedMeasurement.unit as Unit)
            
        case let .accelerationY(displayUnitType):
            let convertedMeasurement = Measurement(value: value, unit: UnitAcceleration.microbitGravity).converted(to: displayUnitType)
            return Measurement(value: convertedMeasurement.value, unit: convertedMeasurement.unit as Unit)
            
        case let .accelerationZ(displayUnitType):
            let convertedMeasurement = Measurement(value: value, unit: UnitAcceleration.microbitGravity).converted(to: displayUnitType)
            return Measurement(value: convertedMeasurement.value, unit: convertedMeasurement.unit as Unit)
            
        case let .bearing(displayUnitType):
            let convertedMeasurement = Measurement(value: value, unit: UnitAngle.degrees).converted(to: displayUnitType)
            return Measurement(value: convertedMeasurement.value, unit: convertedMeasurement.unit as Unit)
            
        case let .temperature(displayUnitType):
            let convertedMeasurement = Measurement(value: value, unit: UnitTemperature.celsius).converted(to: displayUnitType)
            return Measurement(value: convertedMeasurement.value, unit: convertedMeasurement.unit as Unit)
        
        case let .pin0(displayUnitType):
            let convertedMeasurement = Measurement(value: value, unit: UnitMicrobitGPIO.raw).converted(to: displayUnitType)
            return Measurement(value: convertedMeasurement.value, unit: convertedMeasurement.unit as Unit)
            
        case let .pin1(displayUnitType):
            let convertedMeasurement = Measurement(value: value, unit: UnitMicrobitGPIO.raw).converted(to: displayUnitType)
            return Measurement(value: convertedMeasurement.value, unit: convertedMeasurement.unit as Unit)
            
        case let .pin2(displayUnitType):
            let convertedMeasurement = Measurement(value: value, unit: UnitMicrobitGPIO.raw).converted(to: displayUnitType)
            return Measurement(value: convertedMeasurement.value, unit: convertedMeasurement.unit as Unit)
        }
    }
    
    public static func == (lhs: MicrobitMeasurement, rhs: MicrobitMeasurement) -> Bool {
        
        switch (lhs, rhs) {
            
        case (.accelerationX, .accelerationX):
            return true
            
        case (.accelerationY, .accelerationY):
            return true
            
        case (.accelerationZ, .accelerationZ):
            return true
            
        case (.bearing, .bearing):
            return true
            
        case (.temperature, .temperature):
            return true
        
        case (.pin0, .pin0):
            return true
            
        case (.pin1, .pin1):
            return true

        case (.pin2, .pin2):
            return true
            
        default:
            return false
        }
    }
}
