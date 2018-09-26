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
import CoreMotion

/**
 A Swift struct that holds the x, y and z values for Accelerometer data
 */
public typealias AccelerometerValues = ThreeAxisValues<UnitAcceleration>

/**
 A Swift struct that holds the x, y and z values for Magnetometer data
 */
public typealias MagnetometerValues = ThreeAxisValues<UnitMagneticFluxDensity>

public struct ThreeAxisValues<UnitType>: Equatable, CustomStringConvertible where UnitType: Unit {
    
    var _x, _y, _z: Measurement<UnitType>
    
    public init(x: Double, y: Double, z: Double, unit: UnitType) {
        self._x = Measurement(value: x, unit: unit)
        self._y = Measurement(value: y, unit: unit)
        self._z = Measurement(value: z, unit: unit)
    }
    
    public init?(data: Data, unit: UnitType) {
        
        if let intX = data[0...1].integerFromLittleInt16,
            let intY = data[2...3].integerFromLittleInt16,
            let intZ = data[4...5].integerFromLittleInt16 {
            
            self.init(x: Double(intX), y: Double(intY), z: Double(intZ), unit: unit)
        } else {
            return nil
        }
    }
    
    /**
     A Variable that returns the x value as a double.
     */
    public var x: Double {
        get {
            return _x.value
        }
        set {
            _x.value = newValue
        }
    }
    
    /**
     A variable that returns the y value as a double.
     */
    public var y: Double {
        get {
            return _y.value
        }
        set {
            _y.value = newValue
        }
    }
    
    /**
     A variable that returns the y value as a double.
     */
    public var z: Double {
        get {
            return _z.value
        }
        set {
            _z.value = newValue
        }
    }
    
    /**
     A variable that returns the 'magnitude' of the x, y and z components as a double.
     */
    public var strength: Double {
        get {
            return sqrt((_x.value * _x.value) + (_y.value * _y.value) + (_z.value * _z.value))
        }
    }
    
    /**
     A variable that returns the unit of the structure.
     */
    public var unit: UnitType {
        get {
            return _x.unit
        }
    }
    
    /**
     An overloaded operator that performs an addition of two ThreeAxisValues of the same unit type.
     - returns: A ThreeAxisValues with the same unit type as the operands.
     */
    public static func + (values1: ThreeAxisValues<UnitType>, values2: ThreeAxisValues<UnitType>) -> ThreeAxisValues<UnitType> {
        return ThreeAxisValues(x: values1.x + values2.x,
                               y: values1.y + values2.y,
                               z: values1.z + values2.z,
                               unit: values1.unit)
    }
    
    /**
     An overloaded operator that performs an subtraction of two ThreeAxisValues of the same unit type. This may be useful for looking at changes in accelerometer values.
     - returns: A ThreeAxisValues with the same unit type as the operands.
     */
    public static func - (values1: ThreeAxisValues<UnitType>, values2: ThreeAxisValues<UnitType>) -> ThreeAxisValues<UnitType> {
        return ThreeAxisValues(x: values1.x - values2.x,
                               y: values1.y - values2.y,
                               z: values1.z - values2.z,
                               unit: values1.unit)
    }
    
    /**
     A variable that returns a tuple of each x, y and z components as a Measurement with the struct's unit type.
     - returns: A tuple of the form (x, y, z)
     */
    public var measurements: (Measurement<UnitType>, Measurement<UnitType>, Measurement<UnitType>) {
        get {
            return (x: _x, y: _y, z: _z)
        }
    }
    
    public var microbitData: Data {
        get {
            return Data(fromArray: [Int16(self.x).littleEndian, Int16(self.y).littleEndian, Int16(self.z).littleEndian])
        }
    }
    
    public var description: String {
        return "(x:\(_x), y:\(_y), z:\(_z))"
    }
}

extension ThreeAxisValues where UnitType == UnitAcceleration {
    
    public init(_ acceleration: CMAcceleration) {
        self._x = Measurement(value: acceleration.x, unit: UnitAcceleration.gravity).converted(to: .microbitGravity)
        self._y = Measurement(value: acceleration.y, unit: UnitAcceleration.gravity).converted(to: .microbitGravity)
        self._z = Measurement(value: acceleration.z, unit: UnitAcceleration.gravity).converted(to: .microbitGravity)
    }
    
    public init?(data: Data) {
        self.init(data: data, unit: UnitAcceleration.microbitGravity)
    }
}

extension ThreeAxisValues where UnitType == UnitMagneticFluxDensity {
    
    public init?(data: Data) {
        self.init(data: data, unit: UnitMagneticFluxDensity.microTesla)
    }
}
