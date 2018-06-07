//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 Welcome to the Swift Playground for exploring the micro:bit.
 
 Let's now send an image to the micro:bit to be displayed on the LED panel.
 
 1. steps:  Run the code below then click the A button on the micro:bit to see the heart image scrolled onto the screen.
 2. In the code, tap `.heart` to change the predefined image. Use the code completions to change the type of image.
 3. Re-run the code to see a different image.
 */
//#-hidden-code
import PlaygroundSupport

//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, ., showImage(), .duck, .sword, .chessboard, .target)

//#-end-hidden-code
//#-editable-code
clearScreen()

onButtonPressed(.A, handler: {
    let imageToDisplay = iconImage(.heart)
    imageToDisplay.scrollImage(offset: 1, delay: 200)
    
    toggle(x: 2, y: 2)
})

//#-end-editable-code
