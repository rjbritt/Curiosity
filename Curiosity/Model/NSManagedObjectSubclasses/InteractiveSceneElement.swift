//
//  InteractiveSceneElement.swift
//  Curiosity
//
//  Created by Ryan Britt on 8/25/14.
//  Copyright (c) 2014 Ryan Britt. All rights reserved.
//

import Foundation
import CoreData

class InteractiveSceneElement: NSManagedObject {

    @NSManaged var image: NSData
    @NSManaged var center: String
    @NSManaged var name: String

}
