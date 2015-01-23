//
//  Enums.swift
//  Curiosity
//
//  Created by Ryan Britt on 1/1/15.
//  Copyright (c) 2015 Ryan Britt. All rights reserved.
//

import Foundation

//TODO: transform into a struct with enum capabilities and an easier ability to advance levels and keep track of what the current level is.
enum CuriosityGameLevel:String
{
    case Level1 = "Level 1", Level2 = "Level 2", Level3 = "2", Tut1 = "Tutorial1",
    Tut2 = "Tutorial2", Tut3 = "Tutorial3", Tut4 = "Tutorial4", Tut5 = "Tutorial5",
    Tut6 = "Tutorial6"
}

enum PhysicsCategory:UInt32
{
    case None = 0
    case Character = 1
    case Item = 2
    case Environment = 3
    case All = 4294967295
}

func distanceBetweenPointOne(pointOne:CGPoint, andPointTwo pointTwo:CGPoint) -> Float
{
    var distance:Float = 0
    
    distance = sqrtf(powf(Float(pointTwo.x) - Float(pointOne.x), 2) +
         powf(Float(pointTwo.y) - Float(pointOne.y), 2))
    
    return distance

}
