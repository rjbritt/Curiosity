//
//  ActorSceneElement.swift
//  Curiosity
//
//  Created by Ryan Britt on 8/25/14.
//  Copyright (c) 2014 Ryan Britt. All rights reserved.
//

import Foundation
import CoreData

class ActorSceneElement: InteractiveSceneElement {

    @NSManaged var belongingScene: InteractiveScene
    @NSManaged var actor: Actor

}
