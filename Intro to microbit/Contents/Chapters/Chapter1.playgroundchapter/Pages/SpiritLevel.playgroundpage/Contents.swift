//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "Page6Narrative")
 In the previous exercise you saw how the BBC micro:bit’s built-in accelerometer can be used to detect a shake gesture. This is not the only way that the micro:bit’s accelerometer can be used.
 
 The accelerometer measures the orientation of the micro:bit in three dimensions: **x**, **y** and **z**. We can use this to determine whether the micro:bit is *tilted* or *flat*.
 
 One practical application of this is a *spirit level.* When the micro:bit is flat, the centre LED will be turned on, but as the device is tilted it will show an LED further towards the edge; like the bubble in a spirit level.
 
 1. Look at the display opposite. As you tilt your micro:bit, (or iPad if you do not have a connected micro:bit), you will see the acceleration values change. These represent how far the micro:bit is tilted in each direction.
 
 2. Run the code below.
 
 3. Tilt your micro:bit from one side to another and watch how the values change. For each axis the values change between -1000 and +1000. This measurement is in *milli-gravities.* A value of 1000 (1 gravity) represents the full force of gravity acting along that axis of the micro:bit. If you are tilting the iPad you might find it useful to turn on the orientation lock first.
 
 4. Try to get the lit LED to sit in the very centre of the 5 x 5 display.
 
 5. Look at the code below.
 
 6. The code is reacting to the orientation of the device along the x axis. We read the value of `x` from the `accelerationValues` and then determine which of the horizontal LEDs in the centre of the display should be lit. The centre line is where y is 2.
 
 7. All the code below is fully editable.
 
 8. Change the code so that the micro:bit is more sensitive to being tilted.
 
 9. You need to re-run the code everytime you edit it.
 
 10. Try to change the code so that it reads the `y` from `accelerationValues` and then change the LED along the y axis too. You can select blocks of code to copy and paste.
 
 Now that you've mastered the accelerometer you can use it for other things. For example, it could be used to create a game in which the micro:bit is used for a driving simulation.
 */
//#-hidden-code
import PlaygroundSupport

//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)

setAccelerometerPeriod(.ms160)

//#-end-hidden-code
//#-editable-code
let image = MicrobitImage()
var lastX = 2
image.plot(x: lastX, y: 2)
image.showImage()
onAcceleration({(accelerationValues) in
    let x = accelerationValues.x
    var xToPlot = 2
    if x < -300 { xToPlot = xToPlot + 1}
    if x < -700 { xToPlot = xToPlot + 1}
    if x > 300 { xToPlot = xToPlot - 1}
    if x > 700 { xToPlot = xToPlot - 1}

    if xToPlot != lastX {
        image.unplot(x: lastX, y: 2)
        image.plot(x: xToPlot, y: 2)
        image.showImage()
        lastX = xToPlot
    }
})
//#-end-editable-code
