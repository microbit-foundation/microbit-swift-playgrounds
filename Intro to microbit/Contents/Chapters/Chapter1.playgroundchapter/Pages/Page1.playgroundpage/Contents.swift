//#-hidden-code
//
//  Contents.swift
//
//#-end-hidden-code
/*:#localized(key: "Page1Narative")
 Perhaps the most noticeable feature of the BBC micro:bit is its 5 x 5 LED display.
 You can write programs to turn on each individual LED.
 Let's look at how to do this by firstly learning how to display text on the micro:bit.
 It is possible to display text in two ways depending on how many letters there are.
 
 1. Run the code below and notice what happens.
 2. Change the letter ‘M’ with any other SINGLE letter.
 3. Run the code again.
 4. Notice that when the micro:bit displays ONE letter it remains constantly.
 5. Now replace the single letter with a phrase of your choice – for example ‘Hello World’.
 6. Notice now that when more than one letter is shown it scrolls across the micro:bit a letter at a time.
 
 This activity is an excellent way to use the micro:bit as a name badge. See if you can think of any other ways in which scrolling text could be usefully applied.
 */
//#-hidden-code
import PlaygroundSupport

//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, displayText(_:))

//#-end-hidden-code
let textToDisplay = /*#-editable-code text to display*/"M"/*#-end-editable-code*/
showString(textToDisplay)
