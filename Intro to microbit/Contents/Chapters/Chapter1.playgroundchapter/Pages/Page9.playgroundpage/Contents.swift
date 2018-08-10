//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 Welcome to the Swift Playground for exploring the micro:bit.
 
 Let's explore some general purpose I/O (input / output) on the micro:bit
 
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

setInputPins([.pin0, .pin1])
setAnaloguePins([.pin0, .pin1])
onPins({(pinStore: PinStore) in
    let count = pinStore.count
    if let p0 = pinStore[.pin0] {
        let plot0 = p0
    }
    if let p1 = pinStore[.pin1] {
        let plot1 = p1
    }
})
//#-end-editable-code
