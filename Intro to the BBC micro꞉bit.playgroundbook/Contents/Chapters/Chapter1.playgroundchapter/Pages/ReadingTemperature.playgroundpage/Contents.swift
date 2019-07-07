//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "Page7Narrative")
As you have discovered, despite its small size, the micro:bit is packed full of features and sensors and there are still more to learn about.
 
 The micro:bit is able to read the temperature of its surroundings. The temperature provided is actually the temperature of the CPU. As the processor generally runs cold the temperature is a good approximation of the ambient temperature. We can use this to create a simple thermometer. This activity cannot be performed just using the mimic on the iPad.
 
 On the screen opposite – you can see the temperature of the micro:bit being displayed.
 
 Look at the code below. The code has already been written to detect the temperature in degrees centigrade. The first function sets how often the temperature will be read, in this instance the value of 5000 means 5 seconds.
 
 The second function is a *handler* that is called every 5 seconds with an update of the temperature. The temperature is returned in Celsius / ºC. The temperature is then converted to an `Int` and shown on the LED display.
 
 1. Run the code.
 
 2. Look at the display on your micro:bit. You should see a number being scrolled that is the temperature in ºC of the CPU.
 
 3. Place the micro:bit in the palm of your hand and cup your other hand over it. Hold it like this for 2-3 minutes. Alternatively hold it near a heat source like a radiator.
 
 4. Uncup your hands and look at the display, you should see that the number being displayed has changed as the temperature has risen.
 
 5. If the temperature has risen, keep watching the display and you should see the number drop down to its original value.
 
 6. All the code below can be edited. Edit the code to convert the temperature in ºC to Fahrenheit and display that instead.
 
 The conversion is F = C * 9 / 5 + 32
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
