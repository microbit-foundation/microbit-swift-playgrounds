//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "DataStoreNarative")
 
 This page demonstrates the 'DataStore' API for storing and then sharing data collected from the micro:bit.
 All the code is fully editable and documentation on each call is available by selecting the function and tapping 'Help'.
 */
import Foundation
let store = DataStore()
store.columnLabels = ["x", "y"]
for index in -20...20 {
    store.addRow([index, index * index])
}
let csv = store.csvString
store.shareData()
