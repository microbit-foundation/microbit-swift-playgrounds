//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "Page8Narrative")
 You will notice that running across the bottom of the BBC micro:bit there are numbers **0**, **1**, **2**, **3V** and **GND**. These are called *pins* and they provide another way for us to interact with the micro:bit.
 
 They are designed to accommodate *crocodile clips* and *banana plugs*. If you have any handy then they make this exercise slightly easier, but they are not necessary.
 
 Unlike the rest of the micro:bit these pins are not coated in paint, they are left as bare metal. This means that when they are touched by our fingers a small current will flow which can be detected by the micro:bit.
 
 As you may have learned in science; to create a circuit a complete loop has to be created and this is where the **GND** comes in. To connect the pins you need to *pinch* **GND** with one hand and *pinch* one of the numbered pins with your other hand.
 
 1. Look at the code below. Before we can run it we need to specify which pins we wish to use.
 
 2. In the `onPinPressed` fucntion tap on the box labelled **pin** and choose one of the pins from the completion bar.
 
 3. Repeat this for the next `onPinPressed` handler, but ensure you use a different pin to that above.
 
 4. Run the code.
 
 5. Pinch the **GND** pin between your thumb and forefinger and with the other hand pinch one of the pins you chose above.
 
 6. What happens? You should see one of the shapes displayed on the LED display.
 
 7. Pinch the other pin you chose and observe what happens.
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
