//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "Page8Narrative")
 You may have noticed that running across the bottom of the BBC micro:bit there are numbers 0, 1 and 2 and the letters ‘GND’.  These are called ‘pins’ and they provide yet another way for us to interact with the micro:bit. They are ANALOGUE pins. There are other smaller ‘pins’ between each of these analogue ‘pins’ which are DIGITAL ‘pins’ which we will ignore for now and will look at in the final lesson of this book.
 
 They are designed to accommodate crocodile clipped wires, and if you have any handy then they make this exercise slightly easier to do, but they are not necessary.
 
 Unlike the rest of the front of the micro:bit these ‘pins’ are not coated in paint, they are left as ‘bare metal’.  This means that when they are touched by our fingers they create a current and so they can be programmed to react accordingly.
 
 As you may have learned in Science, to create a circuit a complete loop has to be created, and so that is where the ‘GND’ comes in. So to use the pins you need to touch ‘GND’ with one hand, and tap the numbered ‘pin’ of your choice with your other hand.
 
 Let’s try it.
 
 1. Look at the code below.
 
 2. Run the code and watch what happens.
 
 3. The micro:bit should not have done anything because we have not told it which pin to react to.
 
 4. Now, where you see ‘onPinPressed’ click on the box and select the ‘pin’ of your choice.
 
 5. Repeat this for every box you see in the code – be sure to choose the same ‘pin’ number.
 
 6. Run your code.
 
 7. ‘Pinch’ the ‘GND’ pin between your thumb on top) and forefinger (underneath) and with the same fingers of your left hand pinch the ‘pin’ you chose to activate within your code.
 
 8. Notice what happens. You should see a shape displayed on the 5 x 5 display.
 
9. Pinch and unpinch either of the pins and watch what happens. The shape should appear and disappear from the 5 x 5 LED in response to your pinching and unpinching.
*/
//#-hidden-code
import PlaygroundSupport

//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, pin0, pin1, pin2)

//#-end-hidden-code

clearScreen()
onPinPressed(./*#-editable-code*/<#T##pin##BTMicrobit.Pin#>/*#-end-editable-code*/, handler: {
    //#-editable-code
    iconImage(.target).showImage()
    //#-end-editable-code
})
onPinPressed(./*#-editable-code*/<#T##pin##BTMicrobit.Pin#>/*#-end-editable-code*/, handler: {
    //#-editable-code
    iconImage(.chessboard).showImage()
    //#-end-editable-code
})
