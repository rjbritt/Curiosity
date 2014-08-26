//
//  EnvironmentSceneElement.swift
//  Curiosity
//
//  Created by Ryan Britt on 8/25/14.
//  Copyright (c) 2014 Ryan Britt. All rights reserved.
//

import Foundation
import CoreData

class EnvironmentSceneElement: InteractiveSceneElement {

    @NSManaged var belongingScene: InteractiveScene
    @NSManaged var environment: Environment

}
