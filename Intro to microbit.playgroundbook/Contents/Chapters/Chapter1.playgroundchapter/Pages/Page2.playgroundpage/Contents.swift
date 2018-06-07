//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 Welcome to the Swift Playground for exploring the micro:bit.
 
 Let's now send an image to the micro:bit to be displayed on the LED panel.
 
 1. steps:  Run the code below to see the heart image displayed.
 2. In the code, tap the `.heart` box to change the predefined image. Use the code completions to change the type of image.
 3. Re-run the code to see a different image.
 */
//#-hidden-code
import PlaygroundSupport

//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(module, show, MicrobitImage.IconName)

//#-end-hidden-code
let imageToDisplay = iconImage(/*#-editable-code*/.heart/*#-end-editable-code*/)
imageToDisplay.showImage()
