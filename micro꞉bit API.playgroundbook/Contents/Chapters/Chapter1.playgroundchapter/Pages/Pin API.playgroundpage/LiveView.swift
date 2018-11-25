//#-hidden-code
//
//  LiveView.swift
//
//#-end-hidden-code

import PlaygroundSupport
import UIKit

let page = PlaygroundPage.current
let liveViewContainerController = LiveViewContainerController.controllerFromStoryboard("LiveView")
liveViewContainerController.addMicrobitMeasurement(.pin0(.raw))
liveViewContainerController.addMicrobitMeasurement(.pin1(.raw))
liveViewContainerController.addMicrobitMeasurement(.pin2(.raw))
page.liveView = liveViewContainerController
