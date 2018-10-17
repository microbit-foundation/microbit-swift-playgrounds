//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "Page4Narrative")
 It is really fun to write games on the BBC micro:bit, and one of the most simple is ‘Rock, Paper, Scissors’ which is a super game for two players.
 
 This game is as easy to code as it is to play.
 
 To write this program we will use a random function which will choose a random number and display the shape we have chosen to associate with that number.  In this case:
 
 1 = Rock,
 2 = Paper,
 3 = Scissors,
 
 So for this program we will need our range of random numbers to be from 1 to 3.
 
 1. In the code below click next to the word ‘random’ there are 2 boxes each of which has a range of numbers displayed.
 
 2. In the first box select ‘1’ and in the second one select ‘3’.  You have now selected a random number range of 1 to 3.
 
 3. Just as you did in the previous lesson you are going to choose which button will activate your game.  Look for ‘onButtonPressed =’ and choose either ‘A’ or ‘B’.  Now when your game is finished and you press this button your game will run.
 
 4. Look for the line that says ‘if randomNumber == 1’ and in the box beside it choose ‘Rock’ from the options you are given.
 
 5. Look for the line that says ‘if randomNumber == 2’ and in the box beside it choose ‘Paper’ from the options you are given.
 
 6. Look for the line that says ‘if randomNumber == 3’ and in the box beside it choose ‘Scissors’ from the options you are given.
 
 7. Run your code and press the button that you chose in step 3.
 
 8. Repeat step 7 several times and notice that the shape displayed on your micro:bit should change randomly between the rock, paper and scissors shape.
 
 Now you are able to play Rock, Paper Scissors with someone else if they have completed this exercise too.  Or if you are on your own, why not use your micro:bit to compete against the computer code that you currently see on this screen?
 
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
