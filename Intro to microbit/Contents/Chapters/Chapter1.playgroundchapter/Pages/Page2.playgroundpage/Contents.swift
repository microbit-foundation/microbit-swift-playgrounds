//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "Page2Narrative")
 As you have seen, the LEDs on the BBC micro:bit can be turned on to display text.
 
 In the previous exercise simply inputting letters of the alphabet resulted in the micro:bit displaying those letters on the screen. However, what if we want to display shapes other than letters?
 
 It is possibly not a surprise to learn that it is possible to turn the LEDs on in any combination we wish so that any shapes that will fit on a 5 x 5 grid can be displayed.
 
 Let's try this out.
 
 1. Run the code below.
 
 2. Notice that the micro:bit displays a ‘heart’ shape.
 
 3. For this exercise some shapes have been created for you. So click on the word ‘heart’ and you will see a list of 6 other shapes that can be displayed.
 
 4. Select a shape from the list.
 
 5. Run your code again.
 
 6. Repeat steps 4 and 5 until you have tried each different shape.
 
 Was it obvious to you what each shape was supposed to represent?
 
 Notice that a 5 x 5 grid has some limitations because shapes that are displayed can be quite basic, but it is still a very useful feature. For example, once you learn more about the micro:bit, it would be possible to write a program to display a heart every time you took a step.
 
 When drawing your own shapes you need to consider these constraints by trying to draw shapes that are not too detailed.
 
 If you have some paper handy why not draw a 5 x 5 grid and see what other shapes you can make in such a small space.
 */
//#-hidden-code
import PlaygroundSupport

//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, duck, happy, target, chessboard, rabbit, giraffe)

//#-end-hidden-code
let imageToDisplay = iconImage(./*#-editable-code icon name*/heart/*#-end-editable-code*/)
imageToDisplay.showImage()
