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

public typealias Temperature = Measurement<UnitTemperature>
public typealias Acceleration = Measurement<UnitAcceleration>

public enum MicrobitMeasurement : Equatable {
    case accelerationX(UnitAcceleration)
    case accelerationY(UnitAcceleration)
    case accelerationZ(UnitAcceleration)
    case bearing(UnitAngle)
    case temperature(UnitTemperature)
    
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
            }
        }
    }
    
    var microbitUnit: Unit {
        get {
            switch self {
            case .accelerationX, .accelerationY, .accelerationZ:
                return UnitAcceleration.microbitGravity
            case .bearing:
                return UnitAngle.degrees
            case .temperature:
                return UnitTemperature.celsius
            }
        }
    }
    
    public var unit: Unit {
        get {
            switch self {
            case let .accelerationX(associatedUnitType):
                return associatedUnitType
            case let .accelerationY(associatedUnitType):
                return associatedUnitType
            case let .accelerationZ(associatedUnitType):
                return associatedUnitType
            case let .bearing(associatedUnitType):
                return associatedUnitType
            case let .temperature(associatedUnitType):
                return associatedUnitType
            }
        }
    }
    
    public func measurementFromMicrobitValue(_ value: Double) -> Measurement<Unit> {
        return Measurement(value: value, unit: self.microbitUnit)
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
            
        default:
            return false
        }
    }
}
