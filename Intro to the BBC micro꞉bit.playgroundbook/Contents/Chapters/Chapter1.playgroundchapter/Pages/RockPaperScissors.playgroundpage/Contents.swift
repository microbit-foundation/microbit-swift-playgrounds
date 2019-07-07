//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "Page4Narrative")
 It is really fun to write games on the BBC micro:bit, and one of the most simple is **Rock, Paper, Scissors** which is a super game for two players.
 
 This program will use a *random* function which will choose a random number and display the shape we have chosen to associate with that number. In this case:
 1 = Rock,
 2 = Paper,
 3 = Scissors.
 So we will need our range of random numbers to be from 1 to 3.
 
 1. Just as you did in the previous activity, you need to choose a button that will activate the game. Look for the `onButtonPressed` function and choose to use either button **A** or **B**. When your game is finished everytime you press this button the code will animate a fist before randomly displaying either rock, paper or scissors.
 
 2. In the code within the `random` function there are 2 boxes to specify the range of random numbers generated.
 
 3. In the first box labeled `lower bound` choose `1` and for the `upper bound` choose `3`. The `random` function will then selected a random number in range of 1 to 3.
 
 4. In the line that says `if randomNumber == 1` tap `image` and choose **rock** from the completion bar.
 
 5. In the line that says `if randomNumber == 2` tap `image` and choose **paper** from the completion bar.
 
 6. In the line that says `if randomNumber == 3` tap `image` and choose **scissors** from the completion bar.
 
 7. Run your code.

 8. Press the button that you chose in step 1.
 
 9. Repeat step 8 several times and notice that the shape displayed on your micro:bit should change randomly between rock, paper and scissors.
 
 Now you are able to play Rock, Paper, Scissors with someone else if they have completed this exercise too.  Or if you are on your own, why not use your micro:bit to compete against yourself?
 
 Best of five wins!
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

let fist = createImage("""
...#.
.###.
.####
.###.
.##..
""")

func animateFist() {
    for _ in 1...3 {
        for loop in 1...11 {
            let yOffset = loop < 6 ? 6 - loop : loop - 6
            let imageToDisplay = fist.imageOffsetBy(dy: yOffset)
            imageToDisplay.showImage()
            usleep(75_000)
        }
    }
}

//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, A, B)
//#-code-completion(identifier, show, rock, paper, scissors)
//#-code-completion(identifier, hide, randomNumber, random(in:))

//#-end-hidden-code
clearScreen()
onButtonPressed(./*#-editable-code*/<#T##button##BTMicrobit.Button#>/*#-end-editable-code*/, handler: {
    animateFist()
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
