//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "Page6Narrative")
 In the previous exercise you saw how the BBC micro:bit’s built-in accelerometer can be used to make it run a piece of code: each discrete shake made the code run again.
 
 However, this is not the only way that the micro:bit’s accelerometer can be used.  It can respond in real-time rather than reacting to each discrete movement.
 
 As the accelerometer determines the position of the micro:bit in three dimensions (x, y and z), we can use this feature to determine whether it has been tilted or not.
 
 One practical application of this is a ‘spirit level’ which is used by builders to determine if walls are evenly constructed. A spirit level is a piece of wood with a tube of coloured liquid and an air bubble in it. The spirit level is laid across a wall and if it is even the bubble will sit in the middle of the tube, otherwise it will tilt to one side or another.
 
 The micro:bit can be used to display the same information by having one LED turned on. When the micro:bit is perfectly even, the centre LED will be turned on, but as the device is tilted it will react and one LED either side will turn on and so it will indicate that the micro:bit is not perfectly horizontal.
 
 1. Look at display beside the on-screen micro:bit. As you tilt your micro:bit you will see the co-ordinates change, these indicate the co-ordinates of the device in 3 dimensions.
 
 2. Run the code shown below.
 
 3. Tilt your micro:bit from one side to another and watch how the co-ordinates change.
 
 4. Try to get the lit LED to sit in the very centre of the 5 x 5 display.
 
 5. Look at the code below.
 
 6. The code is currently reacting to the position of the device on the x axis
 
 7. Change every occurrence of ‘x’ that you see in the code to ‘y’ and change every ‘y’ to ‘x’
 
 8. Run the code again.
 
 9. Do you notice what has changed?  The micro:bit is now displaying how its position on the y axis.
 
 As your display is only two dimensional it is not really possible to show the position of the micro:bit on the z-axis too, but as you can see this activity is a really useful demonstration of the way that the accelerometer can be used within programs. For example, it could be used to create a game in which the micro:bit is used for a driving simulation.
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
    let xToPlot = -max(min(Int(x / 150), 2), -2) + 2
    if xToPlot != lastX {
        image.unplot(x: lastX, y: 2)
        image.plot(x: xToPlot, y: 2)
        image.showImage()
        lastX = xToPlot
    }
})
//#-end-editable-code
