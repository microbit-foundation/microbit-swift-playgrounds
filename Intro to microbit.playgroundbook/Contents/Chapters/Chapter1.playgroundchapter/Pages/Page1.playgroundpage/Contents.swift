//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 Welcome to the Swift Playground for exploring the micro:bit.
 
 Let's start by sending a short text message to the micro:bit to be displayed on the LED panel.
 
 1. steps:  Run the code below to see the text being displayed.
 2. In the code, tap the `Hello World` box to change the text that will be displayed.
 3. Re-run the code to see your own message.
 */
//#-hidden-code
import PlaygroundSupport

//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, displayText(_:))

//#-end-hidden-code
let textToDisplay = /*#-editable-code text to display*/"Hello World!"/*#-end-editable-code*/
showString(textToDisplay)
