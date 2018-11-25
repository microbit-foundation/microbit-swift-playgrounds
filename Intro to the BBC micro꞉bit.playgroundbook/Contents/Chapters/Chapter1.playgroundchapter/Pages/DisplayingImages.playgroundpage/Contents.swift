//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "Page2Narrative")
 As you have seen, the LEDs on the BBC micro:bit can be turned on to display text.
 
 In the previous exercise we displayed letters on the screen. But what if we want to display shapes other than letters?
 
 The micro:bit can also show 'images', where each of the LEDs is on or off to make a picture.
 
 Let's try this out.
 
 1. Run the code below.
 
 2. Notice that the micro:bit displays a ‘heart’ shape.
 
 3. For this exercise some images have been created for you. So click on the word ‘heart’ and you will see a list of 6 other images that can be displayed.
 
 4. Select an image from the list.
 
 5. Run your code again.
 
 6. Repeat steps 4 and 5 until you have tried each different shape.
 
 Was it obvious to you what each shape was supposed to represent?
 
 Once you get the hang of using the small space, you can make lots of different shapes and stories with just the micro:bit's display. For example, once you learn more about the micro:bit, it would be possible to write a program to display a heart every time you took a step, or tell an interactive story.
 */
//#-hidden-code
import PlaygroundSupport

//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, duck, happy, target, chessboard, rabbit, giraffe)

//#-end-hidden-code
let imageToDisplay = iconImage(./*#-editable-code icon name*/heart/*#-end-editable-code*/)
imageToDisplay.showImage()
