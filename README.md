# micro:bit Swift Playgrounds

##Overview

This document covers how to use the BBC micro:bit template book to create your own Swift Playground book. It does not include details on the format of the playground books or the markup of the Content.swift files.

The term _Swift Playground_ can have different meanings. When we refer to a Swift Playground we mean a _Swift Playground Book_. The book format allows for the creation of chapters and pages such that it is structured in a book format.

For a complete description of the Swift Playground book format please refer to the [Apple documentation][playground_link]. You should familiarise yourself with this documentation before attempting to create your own book.

[playground_link]:https://developer.apple.com/documentation/swift_playgrounds?language=objc

##The micro:bit Template Book

Creating a Swift Playground from scratch is a complex programming task. By providing a template book we have written all the complex code required to pair and communicate with the micro:bit over Bluetooth. You can think of the template book as providing a Playground SDK (Software Development Kit).

The template book is provided in this repository as **micro-bit template.playgroundbook**

After cloning this folder, you should rename it to something appropriate but keep the extension **.playgroundbook**

On a Mac OS computer this will appear as a file _bundle_ which means it appears as a single file but is actually a directory structure. To open the directory structure, you need to select the book and choose **Show Package Contents** from the Finder's contextual menu.

To edit the book you will ideally require a tool suitable for editing Swift and plist files. We would recommend downloading Xcode from the Apple App Store.

The files you need to edit are located in **Contents/Chapters/** You will also need to edit the appropriate **manifest.plist** files. Refer to the [Apple documentation][playground_link] on details of this.

Inside the **Contents/Sources** directory you will find all the source files required for the playground to communicate with the micro:bit as well as a host of other supporting functionality. These may also provide an additional insight into the functionality of our Swift Playground SDK.

##Testing Your Book
To test your book you can either:

* Copy it to the **Playgrounds** folder in your iCloud drive. The Swift Playgrounds app on your iPad will notice it has been added/updated and download it accordingly.
* Airdrop the playground book from the Finder to your iPad, then respond accordingly on the iPad. This is fine the first time you copy the book but subsequent drops will make copies of the book which will build-up over time and need to be deleted.
* Utilise a script file as detailed below or author an Automator action.

The Apple documentation also lists various ways of getting your playground onto a device.

##The micro:bit API Book

This repository also contains another Swift Playground book called **microbit API.playgroundbook**

This playground provides an interactive demonstration of the whole of the API we have defined for interacting with the micro:bit much of which is not included in the _Intro_ book. You may wish to install this to your iPad and explore it before developing your own book as it will illustrate the many possibilites that are possible from the Swift Playgrounds app.

##Using Script Files

The repository also contains three script files:

* create\_doc\_book.sh
* create\_intro\_book.sh
* create\_template\_book.sh

These were used by us to the create the **micro:bit API**,  **Intro to the BBC micro:bit** and **micro-bit template** playground books. These scripts copy and _compile_ the **micro-bit source** book and then merge the books' contents from separate folders. You may wish to copy and modify one of these scripts for your own workflow. They contain lines to compile the original storyboard and assets from the _source_ book. Unless you intend to modify the storyboard or assets then you should just work from the compiled template book instead.
