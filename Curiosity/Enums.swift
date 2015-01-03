//
//  Enums.swift
//  Curiosity
//
//  Created by Ryan Britt on 1/1/15.
//  Copyright (c) 2015 Ryan Britt. All rights reserved.
//

import Foundation

enum CuriosityGameLevel:String
{
    case Level1 = "Level 1", Level2 = "Level 2", Level3 = "2"
}

enum PhysicsCategory:UInt32
{
    case None = 0
    case Character = 1
    case Item = 2
    case Environment = 3
    case All = 9999
}
