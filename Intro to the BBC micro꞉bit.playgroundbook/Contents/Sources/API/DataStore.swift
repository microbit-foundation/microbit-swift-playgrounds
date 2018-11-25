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
import PlaygroundSupport

public typealias DataRow = Array<Any>

/**
 General purpose object for storing data and sharing it to other apps.
 */
public class DataStore {
    
    var data: Array<DataRow>
    var hasColumnLabels = false
    
    public init() {
        self.data = Array<DataRow>()
    }
    
    /**
     Initialiser for the DataStore class.
     - parameters:
        - columnLabels: The DataRow is an array of numbers or strings. You can insert any type that conforms to CustomStringConvertible.
     */
    public convenience init(columnLabels: DataRow) {
        self.init()
        self.columnLabels = columnLabels
    }
    
    /**
     A variable for getting and setting the first row of the data store as a set of labels. This is an optional type of DataRow?
     */
    public var columnLabels: DataRow? {
        get {
            return self.hasColumnLabels ? self.data[0] : nil
        }
        set {
            if newValue != nil {
                if hasColumnLabels {
                    self.data.replaceSubrange(0...0, with: [newValue!])
                } else {
                    self.data.insert(newValue!, at: 0)
                }
            } else {
                if hasColumnLabels {
                    self.data.remove(at: 0)
                }
            }
            self.hasColumnLabels = newValue != nil
        }
    }
    
    /**
     A function for adding a new data row to the store.
     - parameters:
        - _ The DataRow is an array of numbers or strings. You can insert any type that conforms to CustomStringConvertible.
     */
    public func addRow(_ dataRow: DataRow) {
        self.data.append(dataRow)
    }
    
    /**
     A variable for getting the data store as a CSV string. This can be used for debugging. Generally you will want to share the data using the shareData() function.
     - returns: A string formatted as CSV.
     */
    public var csvString: String {
        get {
            return self.data.reduce("", {(Result, Element) in
                Result + Element.csvString + "\n"
            })
        }
    }
    
    /**
     A function that shares the data store to export. On calling this function the share button will appear in the Live View.
     */
    public func shareData() {
        let message = PlaygroundValue.fromActionType(.shareData,
                                                     data: Data(self.csvString.utf8),
                                                     uti: "public.comma-separated-values-text")
        let proxy = PlaygroundPage.current.liveView as! PlaygroundRemoteLiveViewProxy
        proxy.send(message)
    }
}

extension Array {
    
    public var csvString: String {
        get {
            let quotedComponents = self.map({ (value: Any) -> String in
                let string = String(describing:value)
                if let _ = Double(string) {
                    return string
                } else {
                    return "\"" + string + "\""
                }
            })
            return quotedComponents.joined(separator: ",")
        }
    }
}
