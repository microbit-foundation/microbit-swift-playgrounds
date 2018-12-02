//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "MicrobitAPINarative")
 
 This page demonstrates the 'MicrobitImage' API.
 All the code is fully editable and documentation on each call is available by selecting the function and tapping 'Help'.
 
 ---
 
 Images are displayed on the micro:bit display via an object called a MicrobitImage. The micro:bit playground SDK has some powerful functions for handling these images and there is much you can do with them. When you run this page only the final array of images is scrolled. Use the debug icons to view the effect the functions have on the images.
 */
import Foundation
//: * Create an image from a multi-line string, which can just be expressed as a string literal.
let chessboardImage: MicrobitImage = """
X.X.X
.X.X.
X.X.X
.X.X.
X.X.X
"""
//: * Read and set an individual LED.
let image = MicrobitImage()
image.plot(x: 2, y: 2)
let ledState = image.ledState(x: 2, y: 2)
//: * Make a copy of an image
let imageCopy = image.copy()
//: * Perform logical operations such as ~ for NOT, | for OR and & for AND.
let invertedImage = ~imageCopy
let anotherImage = chessboardImage & ~image
//: * Create a new image by offseting an image in both an X and Y direction.
let offsetImage = anotherImage.imageOffsetBy(dx: 2, dy: 2)
//: Create an image from a single character.
let characterImage = MicrobitFont.defaultFont.microbitImageForCharacter(Character("A"))
//: * You can construct images from text strings to form an array of images.
let textImages = "Hello".microbitImages
//: * Access a range of pre-defined _icon_ and _arrow_ images.
let images = [iconImage(.heart), iconImage(.diamond), iconImage(.duck)]
/*:
* They can be _added_ and _subtracted_ from each other.
* Arrays of images can be scrolled.
 */
(textImages + images).scrollImages(delay: 200, withSpacing: 2)
