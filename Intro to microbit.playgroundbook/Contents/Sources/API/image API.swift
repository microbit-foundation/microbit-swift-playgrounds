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

public func arrowImage(_ arrowName: MicrobitImage.ArrowName) -> MicrobitImage {
    
    var stringImage: String
    switch arrowName {
        
    case .north:
        stringImage = """
        ..#..
        .###.
        #.#.#
        ..#..
        ..#..
        """
        
    case .northEast:
        stringImage = """
        ..###
        ...##
        ..#.#
        .#...
        #....
        """
        
    case .east:
        stringImage = """
        ..#..
        ...#.
        #####
        ...#.
        ..#..
        """
        
    case .southEast:
        stringImage = """
        #....
        .#...
        ..#.#
        ...##
        ..###
        """
        
    case .south:
        stringImage = """
        ..#..
        ..#..
        #.#.#
        .###.
        ..#..
        """
        
    case .southWest:
        stringImage = """
        ....#
        ...#.
        #.#..
        ##...
        ###..
        """
        
    case .west:
        stringImage = """
        ..#..
        .#...
        #####
        .#...
        ..#..
        """
        
    case .northWest:
        stringImage = """
        ###..
        ##...
        #.#..
        ...#.
        ....#
        """
    }
    
    return MicrobitImage(stringImage)
}

public func iconImage(_ iconName: MicrobitImage.IconName) -> MicrobitImage {
    
    var stringImage: String
    switch iconName {
        
    case .heart:
        stringImage = """
        .#.#.
        #####
        #####
        .###.
        ..#..
        """
        
    case .smallHeart:
        stringImage = """
        .....
        .#.#.
        .###.
        ..#..
        .....
        """
        
    case .yes:
        stringImage = """
        .....
        ....#
        ...#.
        #.#..
        .#...
        """
        
    case .no:
        stringImage = """
        #...#
        .#.#.
        ..#..
        .#.#.
        #...#
        """
        
    case .happy:
        stringImage = """
        .....
        .#.#.
        .....
        #...#
        .###.
        """
        
    case .sad:
        stringImage = """
        .....
        .#.#.
        .....
        .###.
        #...#
        """
        
    case .confused:
        stringImage = """
        .....
        .#.#.
        .....
        .#.#.
        #.#.#
        """
        
    case .angry:
        stringImage = """
        #...#
        .#.#.
        .....
        #####
        #.#.#
        """
        
    case .asleep:
        stringImage = """
        .....
        ##.##
        .....
        .###.
        .....
        """
        
    case .surprised:
        stringImage = """
        .#.#.
        .....
        ..#..
        .#.#.
        ..#..
        """
        
    case .silly:
        stringImage = """
        #...#
        .....
        #####
        ...##
        ...##
        """
        
    case .fabulous:
        stringImage = """
        #####
        ##.##
        .....
        .#.#.
        .###.
        """
        
    case .meh:
        stringImage = """
        ##.##
        .....
        ...#.
        ..#..
        .#...
        """
        
    case .tShirt:
        stringImage = """
        ##.##
        #####
        .###.
        .###.
        .###.
        """
        
    case .rollerSkate:
        stringImage = """
        ...##
        ...##
        #####
        #####
        .#.#.
        """
        
    case .duck:
        stringImage = """
        .##..
        ###..
        .####
        .###.
        .....
        """
        
    case .house:
        stringImage = """
        ..#..
        .###.
        #####
        .###.
        .#.#.
        """
        
    case .tortoise:
        stringImage = """
        .....
        .###.
        #####
        .#.#.
        .....
        """
        
    case .butterfly:
        stringImage = """
        ##.##
        #####
        ..#..
        #####
        ##.##
        """
        
    case .stickFigure:
        stringImage = """
        ..#..
        #####
        ..#..
        .#.#.
        #...#
        """
        
    case .ghost:
        stringImage = """
        .###.
        #.#.#
        #####
        #####
        #.#.#
        """
        
    case .sword:
        stringImage = """
        ..#..
        ..#..
        ..#..
        .###.
        ..#..
        """
        
    case .giraffe:
        stringImage = """
        ##...
        .#...
        .#...
        .###.
        .#.#.
        """
        
    case .skull:
        stringImage = """
        .###.
        #.#.#
        #####
        .###.
        .###.
        """
        
    case .umbrella:
        stringImage = """
        .###.
        #####
        ..#..
        #.#..
        ###..
        """
        
    case .snake:
        stringImage = """
        ##...
        ##.##
        .#.#.
        .###.
        .....
        """
        
    case .rabbit:
        stringImage = """
        #.#..
        #.#..
        ####.
        ##.#.
        ####.
        """
        
    case .cow:
        stringImage = """
        #...#
        #...#
        #####
        .###.
        ..#..
        """
        
    case .quarterNote:
        stringImage = """
        ..#..
        ..#..
        ..#..
        ###..
        ###..
        """
        
    case .eighthNote:
        stringImage = """
        ..#..
        ..##.
        ..#.#
        ###..
        ###..
        """
        
    case .pitchfork:
        stringImage = """
        #.#.#
        #.#.#
        #####
        ..#..
        ..#..
        """
        
    case .target:
        stringImage = """
        ..#..
        .###.
        ##.##
        .###.
        ..#..
        """
        
    case .triangle:
        stringImage = """
        .....
        ..#..
        .#.#.
        #####
        .....
        """
        
    case .leftTriangle:
        stringImage = """
        #....
        ##...
        #.#..
        #..#.
        #####
        """
        
    case .chessboard:
        stringImage = """
        .#.#.
        #.#.#
        .#.#.
        #.#.#
        .#.#.
        """
        
    case .diamond:
        stringImage = """
        ..#..
        .#.#.
        #...#
        .#.#.
        ..#..
        """
        
    case .smallDiamond:
        stringImage = """
        .....
        ..#..
        .#.#.
        ..#..
        .....
        """
        
    case .square:
        stringImage = """
        #####
        #...#
        #...#
        #...#
        #####
        """
        
    case .smallSquare:
        stringImage = """
        .....
        .###.
        .#.#.
        .###.
        .....
        """
        
    case .scissors:
        stringImage = """
        ##..#
        ##.#.
        ..#..
        ##.#.
        ##..#
        """
    }
    
    return MicrobitImage(stringImage)
}

extension MicrobitImage {
    
    public enum ArrowName {
        case north
        case northEast
        case east
        case southEast
        case south
        case southWest
        case west
        case northWest
    }
    
    public enum IconName {
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
    }
    
    public func showImage(offset: Int = 0) {
        
        let image = self.imageOffsetBy(offset)
        
        ContentMessenger.messenger.sendMessageOfType(.writeData,
                                                     forCharacteristicUUID: .ledStateUUID,
                                                     withData: image.imageData)
    }
    
    public func scrollImage(offset: Int, delay: Int) {
        
        if abs(offset) >= 10 {
            MicrobitImage().showImage()
            return
        }
        
        let actualOffset = offset == 0 ? 1 : offset
        let numberOfDisplaysRequired = 1 + Int(4 / abs(actualOffset))
        for frame in 1...numberOfDisplaysRequired {
            
            self.showImage(offset: (actualOffset > 0 ? -5 : 5) + frame * actualOffset)
            usleep(UInt32(delay) * 1000)
        }
    }
}
