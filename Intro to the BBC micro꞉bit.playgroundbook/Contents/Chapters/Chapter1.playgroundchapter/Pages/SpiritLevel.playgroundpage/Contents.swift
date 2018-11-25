//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "Page6Narrative")
 In the previous exercise you saw how the BBC micro:bit’s built-in accelerometer can be used to make it run a piece of code: each discrete shake made the code run again.
 
 However, this is not the only way that the micro:bit’s accelerometer can be used.  It can respond in real-time too.
 
 As the accelerometer measures the orientation of the micro:bit in three dimensions (x, y and z), we can use this feature to determine whether it has been tilted or not.
 
 One practical application of this is a ‘spirit level’: when the micro:bit is perfectly even, the centre LED will be turned on, but as the device is tilted it will show an LED further towards the edge.
 
 1. Look at the display beside the on-screen micro:bit. As you tilt your micro:bit you will see the acceleration values change, representing how tilted the micro:bit is in each direction. 
 
 2. Run the code shown below.
 
 3. Tilt your micro:bit from one side to another and watch how the values change. See how, for each axis, -1024 is a strong tilt one way and +1024 a strong tilt the other?
 
 4. Try to get the lit LED to sit in the very centre of the 5 x 5 display.
 
 5. Look at the code below.
 
 6. The code is currently reacting to the position of the device on the x axis. We start with x=2, which is the middle of the display, and reduce it if the number is negative, or increase it if the number is positive. This selects which LED to light.
 
 7. Change every occurrence of ‘x’ that you see in the code to ‘y’ and change every ‘y’ to ‘x’
 
 8. Run the code again.
 
 9. Do you notice what has changed?  The micro:bit is now displaying how its position on the y axis.
 
 As your display is only two dimensional it is not really possible to show the position of the micro:bit on the z-axis too, but can you add some code to your solution below so that it shows both x and y position together? You can select a block of code and copy it.
 
 Now you've mastered the accelerometer you can use it for other things: for example, it could be used to create a game in which the micro:bit is used for a driving simulation.
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
