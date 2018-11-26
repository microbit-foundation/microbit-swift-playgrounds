//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "DataStoreNarative")
 
 This page demonstrates the _DataStore_ API for storing and then sharing data collected from the micro:bit.
 All the code is fully editable and documentation on each call is available by selecting the function and tapping 'Help'.
 
 This example doesn't actually read and store any data from the micro:bit, instead it simply constructs a table of (x, y) values that describe a parabola.
 */
import Foundation
//: Create a DataStore object.
let store = DataStore()
//: You can optionally set column labels for the data. This is not required but these values will always be the first row of data when exported.
store.columnLabels = ["x", "y"]
//: Use the `addRow()` function to add a row of data to the store. It will always be added to the end of the store. You pass an array of values, these can in theory be any sort of values that have a _description_ but in practice they are likely to be text strings and numbers.
for index in -20...20 {
    store.addRow([index, index * index])
}
//: The `csvString` property returns your data as a CSV string. Calling this is optional but it might be useful for debugging or checking that the data collected is in the format you expected it to be.
let csv = store.csvString
//: Finally, call the `shareData()` function when you are ready to export your data. Notice that at this point a _share_ button has appeared at the top of the Live View. Tap on the share button to choose a destination app for the data.
store.shareData()
