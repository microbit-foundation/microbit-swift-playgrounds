//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "Page3Narrative")
 Either side of the 5 x 5 LED display, the BBC micro:bit has two buttons, one is labelled ‘A’, the other ‘B’.
 
 We can use these buttons to carry out different functions.
 
 Let’s use what we have learned in the previous two lessons to see how the buttons work.
 
 For this exercise you are going to display a text message when button ‘A’ is pressed and display a shape when button ‘B’ is pressed.
 
 1. In the code below look for the box next to the first appearance of ‘button’ and enter ‘A’.
 
 2. In the line below this, click in the box that says ‘Hello World’ and write your own short message.  What do you think this will do?
 
 3. Run the code and see if you are right.
 
 4. Now look for the next appearance of the word ‘button’ and enter ‘B’ from the options given to you.
 
 5. In the line below this, click in the box that gives a list of shapes and write your own short message.  What do you think this will do?
 
 6. Run the code and see if you are right.
 
 7. Now return to your code and change your program to display text when button ‘B’ is pressed and a shape when button ‘A’  is pressed.
 
 8. Run your code to see what happens.

 */
//#-hidden-code
import PlaygroundSupport

//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, A, B)
//#-code-completion(identifier, show, duck, happy, target, chessboard, rabbit, giraffe)

//#-end-hidden-code

clearScreen()
onButtonPressed(./*#-editable-code*/<#T##button##BTMicrobit.Button#>/*#-end-editable-code*/, handler: {
    let textToDisplay = /*#-editable-code text to display*/"Hello World"/*#-end-editable-code*/
    showString(textToDisplay)
})
onButtonPressed(./*#-editable-code*/<#T##button##BTMicrobit.Button#>/*#-end-editable-code*/, handler: {
    let imageToDisplay = iconImage(./*#-editable-code*/heart/*#-end-editable-code*/)
    imageToDisplay.showImage()
})
