//#-hidden-code
//
//  LiveView.swift
//
//#-end-hidden-code

import PlaygroundSupport
import UIKit

let page = PlaygroundPage.current
let liveViewContainerController = LiveViewContainerController.controllerFromStoryboard("LiveView")
liveViewContainerController.addMicrobitMeasurement(.temperature(.celsius))
liveViewContainerController.addMicrobitMeasurement(.temperature(.fahrenheit))
page.liveView = liveViewContainerController
