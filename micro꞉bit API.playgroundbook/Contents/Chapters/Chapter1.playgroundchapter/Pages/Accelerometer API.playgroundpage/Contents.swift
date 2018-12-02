//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "AccelerometerAPINarrative")
 
 This page demonstrates the _accelerometer_ API for configuring the Accelerometer on the micro:bit.
 All the code is fully editable and documentation on each call is available by selecting the function and tapping 'Help'.
 */
import Foundation
clearScreen()
//: Configure the rate at which we receive accelerometer values from the micro:bit. The first parameter is of type BTMicrobit.AccelerometerPeriod. Tap on this type below for further values. The handler is optional and is called after setting the period with a parameter of the same type. You do not need to even set the accelerometer period but just allow the micro:bit to use the default rate. In practise you probably will not receive accelerometer data faster than 30ms, so the only values that have a practial application are: .ms80, .ms160 and .ms640
setAccelerometerPeriod(.ms80, handler: {(period: BTMicrobit.AccelerometerPeriod?) in
    if let actualPeriod = period {
        // Do something with the returned value
        print("\(actualPeriod)")
    }
})
/*: Call `onAcceleration()` with a handler which is called according to the accelerometer period. The handler returns a struct of type AccelerometerValues.
 
 # AccelerometerValues – A Generic Struct
 
 At first glance the type **AccelerometerValues** is a straightforward struct with three variables: x, y and z. Indeed you can use it in this way and the values returned by these accessors will be in the same measurements as those familiar with MakeCode, that being where 1024 represents 1 Gravity (or G). When the micro:bit is lying exactly flat you should find x and y are both 0 and z is 1024 (or -1024). So far all is familiar, but what’s with all the _generic struct_ stuff?
 
 If you request Help on the AccelerometerValues type you’ll see that it is just\
 `typealias AccelerometerValues = ThreeAxisValues<UnitAcceleration>`
 
 A typealias is Swift’s way of defining a type but based on another type. It’s just giving a type another new name, an alias if you like. But in this case we’re not just making AccelerometerValues a typealias of the struct ThreeAxisValues but we’re defining this _generic_ struct to be of type of UnitAcceleration.
 
 Let’s look at the ThreeAxisValues struct. This struct is what you might imagine it would be, a type that contains three variables: x, y and z. But if you delve a bit further you’ll see that this struct also has a read only `strength` variable, and you can also request a tuple of x, y and z measurements as well as the struct’s unit. It also allows you to add and subtract structs from each other. This is one of the great features of Swift; a simple x, y and z struct can also contain functions; leading to some very powerful features.
 
 ## So what’s with the UnitType?
 When software passes numbers around that represent some form of measurement such as; temperature, length or acceleration, the question is what units are these numbers representing. Is the temperature in Celsius or Fahrenheit? Is the length in meters, millimetres or light years? Apple have an answer for this in the form of Measurement. A Measurement is also a _generic struct_ which represents a _number value_ but also with a _unit_. For example, a length of 5cm would have a value of 5 with a unit of type: UnitLength.centimeters  Apple have defined a host of unit types and in UnitLength alone you will find: centimetres, meters, millimetres and indeed furlongs, lightyears and just about anything you’d need. And the best bit about Swift is that if Apple hasn’t provided the unit length you need, through an extension you can add your own - as indeed we have!
 
 ## Unit Conversions
 When units are defined they have a number of properties of their own. They define a text string of their unit, eg. ‘cm’ for centimetres as well as a conversion formula from the _base unit_. So this means you can apply conversions and equalities on Measurements. A Measurement of 5cm would be equal to a Measurement of 0.05m. Also, you can convert a Measurement of one unit to another, e.g. convert 0°C to 32°F, so long as they are of the same UnitType!
 
 So the struct has both a number value and a unit. What makes it a generic struct then? It’s generic in that in can represent a number of ANY type of unit but the UnitType forms part of the Measurement type, and remember, Swift is very type safe. In practice this means you can’t compare a Measurement of 5°C with a Measurement of 5cm. Yes they’re both Measurements, but their generic unit TYPES are different, one is UnitTemperature the other is UnitLength. This makes these Measurements of a different type, not only can you not compare them, you can’t convert temperature to length, or add them together.
 
 Apple have defined two acceleration units: gravity and metersPerSecondSquared. We have extended these measurements to include: milliGravity and microbitGravity. There are 1000 milli-gravities in 1 Gravity and 1024 microbit-gravities in 1 Gravity. This means we can perform a conversion from the raw values from the micro:bit to both Gravity and m/s².
 
 Conversion of Measurements are used in the display of the values that can be added to the Live View.
 */
onAcceleration({(accelerometerValues: AccelerometerValues) in
    let x = accelerometerValues.x
    let y = accelerometerValues.y
    let z = accelerometerValues.z
    let strength = accelerometerValues.strength
    let measurements = accelerometerValues.measurements
    let zGravity = measurements.x.converted(to: UnitAcceleration.gravity)
})
