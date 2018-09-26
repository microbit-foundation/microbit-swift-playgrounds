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

let ActionTypeKey = "ActionType"
let CharacteristicUUIDKey = "CharacteristicUUID"
let DataKey = "Data"
let UTIKey = "UTI"

extension PlaygroundValue {
    
    static func fromActionType(_ actionType: ContentMessenger.ActionType,
                               characteristicUUID: BTMicrobit.CharacteristicUUID? = nil,
                               data: Data? = nil,
                               uti: String? = nil) -> PlaygroundValue {
        
        var actionDictionary = [ActionTypeKey: PlaygroundValue.integer(actionType.rawValue)]
        
        if (characteristicUUID != nil) {
            actionDictionary[CharacteristicUUIDKey] = PlaygroundValue.string(characteristicUUID!.rawValue)
        }
        
        if let data = data {
            actionDictionary[DataKey] = PlaygroundValue.data(data)
        }
        
        if let uti = uti {
            actionDictionary[UTIKey] = PlaygroundValue.string(uti)
        }
        return .dictionary(actionDictionary)
    }
    
    var actionType: ContentMessenger.ActionType? {
        get {
            guard case let .dictionary(messageDictionary) = self else { return nil }
            if let actionTypeValue = messageDictionary[ActionTypeKey] {
                guard case let .integer(actionTypeInt) = actionTypeValue else { return nil }
                return ContentMessenger.ActionType(rawValue: actionTypeInt)
            }
            return nil
        }
    }
    
    var characteristicUUID: BTMicrobit.CharacteristicUUID? {
        get {
            guard case let .dictionary(messageDictionary) = self else { return nil }
            if let characteristicUUIDValue = messageDictionary[CharacteristicUUIDKey] {
                guard case let .string(characteristicUUIDString) = characteristicUUIDValue else { return nil }
                return BTMicrobit.CharacteristicUUID(rawValue: characteristicUUIDString)
            }
            return nil
        }
    }
    
    var data: Data? {
        get {
            guard case let .dictionary(messageDictionary) = self else { return nil }
            if let dataValue = messageDictionary[DataKey] {
                guard case let .data(data) = dataValue else { return nil }
                return data
            }
            return nil
        }
    }
    
    var uti: String? {
        get {
            guard case let .dictionary(messageDictionary) = self else { return nil }
            if let dataValue = messageDictionary[UTIKey] {
                guard case let .string(uti) = dataValue else { return nil }
                return uti
            }
            return nil
        }
    }
}
