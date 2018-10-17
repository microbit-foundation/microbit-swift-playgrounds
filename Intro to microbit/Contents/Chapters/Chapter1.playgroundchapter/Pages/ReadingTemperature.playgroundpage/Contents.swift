//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "Page7Narrative")
 Reading Temperature
 
 As you have discovered, despite its small size, the micro:bit is packed full of useful features and there are still more to learn about.
 
 The micro:bit is able to detect the temperature of its surroundings.  It is important to realise that the micro:bit does not have a temperature sensor built in, but it can recognise the temperature of part of its CPU.  We can therefore use this to create a simple thermometer.
 
 1. Look at the display on the screen – you can see the temperature of the micro:bit being displayed.
 
 2. Look at the code below.
 
 3. The code has already been written to detect the temperature in degrees Centigrade.
 
 4. There is one clickable box in the code. Click on it.
 
 5. Select the option to ‘show’ the current temperature on the micro:bit.
 
 6. Run the code again.
 
 7. Look at the display on your micro:bit. You should see a number being displayed. This is the current temperature of the CPU. It can be slow to react and you may not see the number change.
 
 8. Place the micro:bit in the palm of one hand and cup your other hand over the top of it. Hold it like this for 2-3 minutes. Alternatively hold it near a heat source like a radiator.
 
 9. Uncup your hands and look at the display, you should see that the number being displayed has changed as the temperature has risen.
 
 10.  If the temperature has risen, keep watching the display and you should see the number drop to its original value.
 */
//#-hidden-code
import PlaygroundSupport

//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, ., showImage(), .duck, .sword, .chessboard, .target)

//#-end-hidden-code
//#-editable-code
clearScreen()

setTemperaturePeriod(5000, handler: {(period: Int?) in
    let periodinMS = period
})

onTemperature({(temperature: Double) in
    let celsius = temperature
    showNumber(Int(celsius))
})

//#-end-editable-code
