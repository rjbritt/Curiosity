//
//  InteractiveScene.swift
//  Curiosity
//
//  Created by Ryan Britt on 8/25/14.
//  Copyright (c) 2014 Ryan Britt. All rights reserved.
//

import Foundation
import CoreData

class InteractiveScene: NSManagedObject {

    @NSManaged var tagIncr: Int64
    @NSManaged var name: String
    @NSManaged var sceneActorElements: NSSet
    @NSManaged var sceneEnvironmentElements: NSSet

}
