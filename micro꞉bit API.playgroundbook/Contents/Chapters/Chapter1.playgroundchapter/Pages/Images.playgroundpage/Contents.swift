//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "MicrobitAPINarative")
 
 This page demonstrates the 'MicrobitImage' API.
 All the code is fully editable and documentation on each call is available by selecting the function and tapping 'Help'.
 */
import Foundation

MicrobitFont.defaultFont.microbitImageForCharacter(Character("A"))
let image = MicrobitImage()
let anotherImage = MicrobitImage("X.X.X")
let image3 = anotherImage.copy()
let invertedImage = ~anotherImage

let textImages = "Hello World".microbitImages
let images = [iconImage(.heart), iconImage(.diamond), iconImage(.duck)]
images.scrollImages(delay: 200, withSpacing: 3)
