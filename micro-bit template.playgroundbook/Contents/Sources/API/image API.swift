/*
 MIT License
 
 Copyright (c) 2018 micro:bit Educational Foundation
 Written by Gary J.H. Atkinson of Stinky Kitten Ltd.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import Foundation

public func createImage(_ leds: String) -> MicrobitImage {
    return MicrobitImage(leds)
}

/**
 Create an arrow shaped image for the LED screen.
 - returns:
 A MicrobitImage that can be displayed on the LED screen.
 - parameters:
    - _ The arrow name of the image you want to create. You can pick an arrow image such as: .north
 */
public func arrowImage(_ arrowName: MicrobitImage.ArrowName) -> MicrobitImage {
    
    switch arrowName {
        
    case .north:
        return """
        ..#..
        .###.
        #.#.#
        ..#..
        ..#..
        """
        
    case .northEast:
        return """
        ..###
        ...##
        ..#.#
        .#...
        #....
        """
        
    case .east:
        return """
        ..#..
        ...#.
        #####
        ...#.
        ..#..
        """
        
    case .southEast:
        return """
        #....
        .#...
        ..#.#
        ...##
        ..###
        """
        
    case .south:
        return """
        ..#..
        ..#..
        #.#.#
        .###.
        ..#..
        """
        
    case .southWest:
        return """
        ....#
        ...#.
        #.#..
        ##...
        ###..
        """
        
    case .west:
        return """
        ..#..
        .#...
        #####
        .#...
        ..#..
        """
        
    case .northWest:
        return """
        ###..
        ##...
        #.#..
        ...#.
        ....#
        """
    }
}

/**
 Create an icon image for the LED screen.
 
 - returns:
 A MicrobitImage that can be displayed on the LED screen.
 
 - parameters:
    - _ The icon name of the image you want to create. You can pick an icon image such as: .heart
 
 - LocalizationKey: iconImage()
 */
public func iconImage(_ iconName: MicrobitImage.IconName) -> MicrobitImage {
    
    switch iconName {
        
    case .heart:
        return """
        .#.#.
        #####
        #####
        .###.
        ..#..
        """
        
    case .smallHeart:
        return """
        .....
        .#.#.
        .###.
        ..#..
        .....
        """
        
    case .yes:
        return """
        .....
        ....#
        ...#.
        #.#..
        .#...
        """
        
    case .no:
        return """
        #...#
        .#.#.
        ..#..
        .#.#.
        #...#
        """
        
    case .happy:
        return """
        .....
        .#.#.
        .....
        #...#
        .###.
        """
        
    case .sad:
        return """
        .....
        .#.#.
        .....
        .###.
        #...#
        """
        
    case .confused:
        return """
        .....
        .#.#.
        .....
        .#.#.
        #.#.#
        """
        
    case .angry:
        return """
        #...#
        .#.#.
        .....
        #####
        #.#.#
        """
        
    case .asleep:
        return """
        .....
        ##.##
        .....
        .###.
        .....
        """
        
    case .surprised:
        return """
        .#.#.
        .....
        ..#..
        .#.#.
        ..#..
        """
        
    case .silly:
        return """
        #...#
        .....
        #####
        ...##
        ...##
        """
        
    case .fabulous:
        return """
        #####
        ##.##
        .....
        .#.#.
        .###.
        """
        
    case .meh:
        return """
        ##.##
        .....
        ...#.
        ..#..
        .#...
        """
        
    case .tShirt:
        return """
        ##.##
        #####
        .###.
        .###.
        .###.
        """
        
    case .rollerSkate:
        return """
        ...##
        ...##
        #####
        #####
        .#.#.
        """
        
    case .duck:
        return """
        .##..
        ###..
        .####
        .###.
        .....
        """
        
    case .house:
        return """
        ..#..
        .###.
        #####
        .###.
        .#.#.
        """
        
    case .tortoise:
        return """
        .....
        .###.
        #####
        .#.#.
        .....
        """
        
    case .butterfly:
        return """
        ##.##
        #####
        ..#..
        #####
        ##.##
        """
        
    case .stickFigure:
        return """
        ..#..
        #####
        ..#..
        .#.#.
        #...#
        """
        
    case .ghost:
        return """
        .###.
        #.#.#
        #####
        #####
        #.#.#
        """
        
    case .sword:
        return """
        ..#..
        ..#..
        ..#..
        .###.
        ..#..
        """
        
    case .giraffe:
        return """
        ##...
        .#...
        .#...
        .###.
        .#.#.
        """
        
    case .skull:
        return """
        .###.
        #.#.#
        #####
        .###.
        .###.
        """
        
    case .umbrella:
        return """
        .###.
        #####
        ..#..
        #.#..
        ###..
        """
        
    case .snake:
        return """
        ##...
        ##.##
        .#.#.
        .###.
        .....
        """
        
    case .rabbit:
        return """
        #.#..
        #.#..
        ####.
        ##.#.
        ####.
        """
        
    case .cow:
        return """
        #...#
        #...#
        #####
        .###.
        ..#..
        """
        
    case .quarterNote:
        return """
        ..#..
        ..#..
        ..#..
        ###..
        ###..
        """
        
    case .eighthNote:
        return """
        ..#..
        ..##.
        ..#.#
        ###..
        ###..
        """
        
    case .pitchfork:
        return """
        #.#.#
        #.#.#
        #####
        ..#..
        ..#..
        """
        
    case .target:
        return """
        ..#..
        .###.
        ##.##
        .###.
        ..#..
        """
        
    case .triangle:
        return """
        .....
        ..#..
        .#.#.
        #####
        .....
        """
        
    case .leftTriangle:
        return """
        #....
        ##...
        #.#..
        #..#.
        #####
        """
        
    case .chessboard:
        return """
        .#.#.
        #.#.#
        .#.#.
        #.#.#
        .#.#.
        """
        
    case .diamond:
        return """
        ..#..
        .#.#.
        #...#
        .#.#.
        ..#..
        """
        
    case .smallDiamond:
        return """
        .....
        ..#..
        .#.#.
        ..#..
        .....
        """
        
    case .square:
        return """
        #####
        #...#
        #...#
        #...#
        #####
        """
        
    case .smallSquare:
        return """
        .....
        .###.
        .#.#.
        .###.
        .....
        """
        
    case .scissors:
        return """
        ##..#
        ##.#.
        ..#..
        ##.#.
        ##..#
        """
        
    case .north, .northEast, .east, .southEast, .south, .southWest, .west, .northWest:
        if let arrowName = MicrobitImage.ArrowName(rawValue: iconName.rawValue) {
            return arrowImage(arrowName)
        } else {
            return MicrobitImage()
        }
    }
}

extension MicrobitImage {
    
    public enum ArrowName : String {
        case north
        case northEast
        case east
        case southEast
        case south
        case southWest
        case west
        case northWest
    }
    
    public enum IconName : String {
        case heart
        case smallHeart
        case yes
        case no
        case happy
        case sad
        case confused
        case angry
        case asleep
        case surprised
        case silly
        case fabulous
        case meh
        case tShirt
        case rollerSkate
        case duck
        case house
        case tortoise
        case butterfly
        case stickFigure
        case ghost
        case sword
        case giraffe
        case skull
        case umbrella
        case snake
        case rabbit
        case cow
        case quarterNote
        case eighthNote
        case pitchfork
        case target
        case triangle
        case leftTriangle
        case chessboard
        case diamond
        case smallDiamond
        case square
        case smallSquare
        case scissors
        case north
        case northEast
        case east
        case southEast
        case south
        case southWest
        case west
        case northWest
    }
    
    /**
     Show an image (picture) on the LED screen.
     
     - parameters:
        - offset: A number as an Int. Positive numbers offset the image to the left, whereas negative values offset it to the right. This parameter has a default value of 0, so it can be omitted.
     */
    public func showImage(offset: Int = 0) {
        
        let image = self.imageOffsetBy(dx: offset)
        
        ContentMessenger.messenger.sendMessageOfType(.writeData,
                                                     forCharacteristicUUID: .ledStateUUID,
                                                     withData: image.imageData)
    }
    
    /**
     Scroll (slide) an image (picture) from one side to the other of the LED screen.
     
     - parameters:
        - offset: A number that is an Int that sets how many LEDs to scroll at a time. Positive numbers scroll from right to left, whereas negative numbers scroll from left to right.
        - delay: A number that sets how many seconds to wait before scrolling by the amount of the offset. The bigger you make this number, the slower the image will scroll.
     */
    public func scrollImage(offset: Int, delayInSeconds: Double) {
        self.scrollImage(offset: offset, delay: Int(delayInSeconds * 1_000))
    }
    
    /**
     Scroll (slide) an image (picture) from one side to the other of the LED screen.
     
     - parameters:
        - offset: A number that is an Int that sets how many LEDs to scroll at a time. Positive numbers scroll from right to left, whereas negative numbers scroll from left to right.
        - delay: A number that sets how many milliseconds to wait before scrolling by the amount of the offset. (There are 1000 milliseconds in a second) The bigger you make this number, the slower the image will scroll.
     */
    public func scrollImage(offset: Int, delay: Int) {
        
        if abs(offset) >= 10 {
            MicrobitImage().showImage()
            return
        }
        
        let actualOffset = offset == 0 ? 1 : offset
        let numberOfDisplaysRequired = 1 + Int(4 / abs(actualOffset))
        for frame in 1...numberOfDisplaysRequired {
            
            self.showImage(offset: (actualOffset > 0 ? -5 : 5) + frame * actualOffset)
            usleep(UInt32(delay * 1_000))
        }
    }
}

extension Array where Element: MicrobitImage {
    
    /**
     A function that scrolls an array of images across the LED display.
     - parameters:
        - delay: A number that sets how many milli-seconds between each movement of the scroll. The bigger the value the slower the text will scroll.
        - withSpacing: an Int that adds an additional number of blank columns between each image. This parameter is optional and defaults to 0.
     */
    public func scrollImages(delay: Int = 200, withSpacing spacing: Int = 0) {
        for scrollIndex in self.scrollStartIndex()...self.scrollEndIndex(withSpacing: spacing) {
            let image = self.imageAtScrollIndex(scrollIndex, withSpacing: spacing)
            image.showImage()
            usleep(UInt32(delay * 1_000))
        }
    }
}
