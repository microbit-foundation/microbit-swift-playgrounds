//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "Page5Narrative")
 One of the many cool features of the BBC micro:bit is the many ways that you can interact with it to make it do things.
 
 We have already seen how pressing buttons can make the micro:bit work, but there are other ways too.
 
 Just like smartphones and tablet devices, the micro:bit has a built in ‘accelerometer’ which determines the tilting motion and orientation of the device. This means it can tell which way up it is in space.
 
 So the accelerometer can be used to get the micro:bit to detect when it is moved, or in this case, shaken.
 
 To do this let us revisit the ‘Rock, Paper, Scissors’ game you developed in the previous lesson. In that program you had to press a button to get the code to run, but it would be much more fun (and realistic) if you could get the micro:bit to react each time you SHAKE it.
 
 1. Look at the slightly modified version of your previous ‘Rock, Paper, Scissors’ program shown below.
 
 2. Click in the box where you see ‘when button A pressed’ and select ‘on shake’ from the options you are given.
 
 3. Now run your code.
 
 4. Shake your micro:bit and notice how it reacts.
 
 5. Repeat step 4 several times and notice that the shape displayed on your micro:bit should change randomly between the rock, paper and scissors shape.
 
 There are many ways in which the accelerometer can be used on a micro:bit and in the next exercise we will see a different application for this useful feature.
 */
//#-hidden-code
import PlaygroundSupport
import Foundation
 
 func random(in range: ClosedRange<Int>) -> Int {
 return range.lowerBound + Int(arc4random_uniform(UInt32(range.count)))
 }
 
 let rock = createImage("""
 .###.
 ####.
 .####
 .###.
 ####.
 """)
 
 let paper = createImage("""
 ####.
 #####
 #####
 #####
 #####
 """)
 
 let scissors = iconImage(.scissors)

//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, shake)
//#-code-completion(identifier, show, rock, paper, scissors)
//#-code-completion(identifier, show, onGesture)
//#-code-completion(identifier, hide, randomNumber, random(in:))

//#-end-hidden-code
clearScreen()
/*#-editable-code*/onButtonPressed/*#-end-editable-code*/(./*#-editable-code*/<#T##gesture##BTMicrobit.Event.Gesture#>/*#-end-editable-code*/, handler: {
    let randomNumber = random(in: /*#-editable-code*/<#T##lower bound##Int#>/*#-end-editable-code*/.../*#-editable-code*/<#T##upper bound##Int#>/*#-end-editable-code*/)
    if randomNumber == 1 {
        /*#-editable-code*/<#T##image##MicrobitImage#>/*#-end-editable-code*/.showImage()
    }
    if randomNumber == 2 {
        /*#-editable-code*/<#T##image##MicrobitImage#>/*#-end-editable-code*/.showImage()
    }
    if randomNumber == 3 {
        /*#-editable-code*/<#T##image##MicrobitImage#>/*#-end-editable-code*/.showImage()
    }
})
