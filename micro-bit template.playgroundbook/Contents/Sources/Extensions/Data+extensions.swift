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

extension Data {
    
    static func littleEndianUInt16FromInt(_ value: Int) -> Data {
        
        var integerFromValue = UInt16(value).littleEndian
        let data = Data(buffer: UnsafeBufferPointer(start: &integerFromValue, count: 1))
        return data
    }
    
    var integerFromLittleUInt16: Int? {
        
        let number: Int? = self.withUnsafeBytes {
            (pointer: UnsafePointer<UInt16>) -> Int? in
            if MemoryLayout<UInt16>.size != self.count { return nil }
            return Int(UInt16.init(littleEndian: pointer.pointee))
        }
        return number
    }
    
    var integerFromLittleInt16: Int? {
        
        let number: Int? = self.withUnsafeBytes {
            (pointer: UnsafePointer<Int16>) -> Int? in
            if MemoryLayout<Int16>.size != self.count { return nil }
            return Int(Int16.init(littleEndian: pointer.pointee))
        }
        return number
    }
    
    init<T>(fromArray values: [T]) {
        var values = values
        self.init(buffer: UnsafeBufferPointer(start: &values, count: values.count))
    }
    
    func toArray<T>(type: T.Type) -> [T] {
        return self.withUnsafeBytes {
            [T](UnsafeBufferPointer(start: $0, count: self.count/MemoryLayout<T>.stride))
        }
    }
}
