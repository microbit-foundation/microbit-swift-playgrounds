//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "TemperatureAPINarrative")
 
 This page demonstrates the _temperature_ API for configuring the Temperature readings from the micro:bit.
 All the code is fully editable and documentation on each call is available by selecting the function and tapping 'Help'.
 */
import Foundation
clearScreen()
//: Configure the rate at which we receive temperature values from the micro:bit. The first parameter is a number of type Int, which represents the number of milli-seconds between readings. The handler is optional and is called after setting the period with a parameter of the same type. You do not need to set the temperature period but just allow the micro:bit to use the default rate. In practise you probably will not receive temperature readings faster than 30ms, so use a value that is at least 30.
setTemperaturePeriod(6000, handler: {(period: Int?) in
    if let actualPeriod = period {
        // Do something with the returned value
        print("\(actualPeriod)")
    }
})
//: The temperature API has a sinlge read function `readTemperature()` that only calls its handler function once, the handler returns a double that represents the temperature in Celsius.
readTemperature({(temperature: Double) in
    let celsius = temperature
})
//: Call `onTemperature()` with a handler which is called according to the temperature period. The handler returns a double that represents the temperature in Celsius. In the example below we utilise Apple's Measurement class to perform a conversion to Fahrenheit.
onTemperature({(temperature: Double) in
    let celsius = temperature
    let celsiusMeasurement = Measurement(value: celsius, unit: UnitTemperature.celsius)
    let fahrenheitMeasurement = celsiusMeasurement.converted(to: .fahrenheit)
    showNumber(Int(fahrenheitMeasurement.value))
})
