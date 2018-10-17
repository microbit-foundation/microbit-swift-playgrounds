//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "PageLEDNarrative")
 So far we've had fun with the built in images on the micro:bit, and scrolled some text.
 
 Let's try creating our own shapes! To do this, we need to tell the micro:bit which LEDs will be on, and which will be off.
 
 If you run the code below, you'll see it still shows the shape of a heart, but this time rather than using the named 'heart' image, we use 'X' and '.' characters to represent the 'On' and 'Off' LEDs
 
 This is your chance to get creative - what can you draw on the micro:bit's screen? Change the code below to change which LEDs are on or off
 
 If you have some paper handy why not draw a 5 x 5 grid and see what other shapes you can make in such a small space.
 
 And here's a challenge: can you add some frames and make this into a small animation?
 */
//#-hidden-code
import PlaygroundSupport

//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)

//#-end-hidden-code
//#-editable-code
let frameOne = MicrobitImage("""
. X . X .
X X X X X
X X X X X
. X X X .
. . X . .
""")
//#-end-editable-code
frameOne.showImage()
