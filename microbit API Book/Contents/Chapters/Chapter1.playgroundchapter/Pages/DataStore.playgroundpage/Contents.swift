//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "InputAPINarative")
 
 This page demonstrates the 'input' API for reading data from the micro:bit.
 All the code is fully editable and documentation on each call is available by selecting the function and tapping 'Help'.
 */
import Foundation
let store = DataStore()
store.columnLabels = ["Time", "Value"]
store.addRow(["12:32", 2])
let csv = store.csvString
store.shareData()
