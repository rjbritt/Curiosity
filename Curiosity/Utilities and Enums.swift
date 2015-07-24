//
//  Enums.swift
//  Curiosity
//
//  Created by Ryan Britt on 1/1/15.
//  Copyright (c) 2015 Ryan Britt. All rights reserved.
//

import Foundation
//MARK: enums

/**
Enum describing levels in Curiosity the game. 
The raw value equates to the name of the .sks file that is used for the level.
*/
enum CuriosityGameLevel:String
{
    case Level1 = "Level 1", Level2 = "Level 2", Tut1 = "Tutorial1",
    Tut2 = "Tutorial2", Tut3 = "Tutorial3", Tut4 = "Tutorial4"
    //An array of ordered levels for use in determining the next level to advance to.
    static let orderedLevels = [Tut1, Tut2, Tut3, Tut4, Level1, Level2]
}


////Directions in the game
//enum GameDirection{
//    case Up, Down, Left, Right;
//}

/**
Physics categories used for this game.
*/
enum PhysicsCategory:UInt32
{
    case None = 0
    case Character = 1
    case Item = 2
    case Environment = 3
    case All = 4294967295
}

//MARK: Structs

/**
*  A struct designed for tracking what CuriosityGameLevel the character is on, and the max Level they have unlocked.
*/
struct LevelTracker
{
    //MARK: Type Level
    static var highestUnlockedLevel:CuriosityGameLevel = .Tut1
    
    /**
    Unlocks an arbitrary level in the game. This is implemented in such a way that once a level is unlocked, so are any levels below it.
    
    - parameter nextLevel: The next Level to unlock.
    */
    static func unlockLevel(nextLevel:CuriosityGameLevel)
    {
        let highestLvl = CuriosityGameLevel.orderedLevels.indexOf(highestUnlockedLevel)
        let nextLvl = CuriosityGameLevel.orderedLevels.indexOf(nextLevel)

        if(nextLvl > highestLvl)
        {
            highestUnlockedLevel = nextLevel
        }
    }
    
    static func levelIsUnlocked(level:CuriosityGameLevel) -> Bool
    {
        let highestLvl = CuriosityGameLevel.orderedLevels.indexOf(highestUnlockedLevel)
        let lvl = CuriosityGameLevel.orderedLevels.indexOf(level)
        
        return lvl <= highestLvl
    }
    
    //MARK: Instance level
    var currentLevel = CuriosityGameLevel.Tut1
    
    /**
    Changes the current level to any of the currently unlocked levels.
    
    - parameter level: Level to make the current level

    - returns: A Bool describing whether or not the level was changed.
    */
    mutating func goToLevel(level:CuriosityGameLevel) -> Bool
    {
        var isSuccessful = true
        
        if LevelTracker.levelIsUnlocked(level)
        {
            currentLevel = level
        }
        else
        {
            isSuccessful = false
        }
        
        return isSuccessful
    }
    
    /**
    Advances the current level following the appropriate order of Curiosity Game Levels. If the level is locked, it becomes unlocked.
    
    - returns: A Bool describing whether or not the next level was reached. False can be caused by either the level already being at the max level or an error occuring and the current level not being able to be found.
    */
    mutating func nextLevel() -> Bool
    {
        var isSuccessful = true
        let currentLvl = CuriosityGameLevel.orderedLevels.indexOf(currentLevel)
        if let lvlIndex = currentLvl
        {
            let nextLvlIndex = lvlIndex + 1
            if(nextLvlIndex < CuriosityGameLevel.orderedLevels.count)
            {
                let nextLevel = CuriosityGameLevel.orderedLevels[nextLvlIndex]
                if !(LevelTracker.levelIsUnlocked(nextLevel))
                {
                    LevelTracker.unlockLevel(nextLevel)
                }
                
                currentLevel = nextLevel
                
            }
            else // level is already at the max level
            { isSuccessful = false }

        }
        else // Something went wrong and nil was returned
        { isSuccessful = false }

       return isSuccessful

    }
}

//MARK: Helper Functions

/**
Determines the distance between two CGPoints

- parameter pointOne: The first CGPoint
- parameter pointTwo: The second CGPoint

- returns: A Float value that represents the distance between the two CGPoints.
*/
func distanceBetweenPointOne(pointOne:CGPoint, andPointTwo pointTwo:CGPoint) -> Float
{
    var distance:Float = 0
    
    distance = sqrtf(powf(Float(pointTwo.x) - Float(pointOne.x), 2) +
         powf(Float(pointTwo.y) - Float(pointOne.y), 2))
    
    return distance
}

func - (left:CGPoint, right:CGPoint) -> CGPoint
{
	return CGPointMake(left.x - right.x, left.y - right.y)
}




