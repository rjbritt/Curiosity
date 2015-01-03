//
//  Character.swift
//  Characters designed to be used to play Curiosity.
//  Curiosity
//
//  Created by Ryan Britt on 12/8/14.
//  Copyright (c) 2014 Ryan Britt. All rights reserved.
//

import UIKit

class Character: SKSpriteNode
{
    enum XDirection
    {
        case Right, Left, None
    }
    
    //Ideas: enum for valid characters, listening var to determine what character is currently in play
    //      Allow for double jump
    
    //MARK: Private Properties
    private let leftVelocityMovementThreshold:CGFloat = -0.1 // m/s that determines if the character is moving to the left.
    private let rightVelocityMovementThreshold:CGFloat = 0.1 // m/s that determines if the character is moving to the right.
    
    //MARK: Public Properties
    var jumpXMovementConstant:Double = 0 //Determines the amount of movement allowed midair while jumping
    var torqueConstant:Double = 0 //Determines the amount of torque applied during movement
    var jumpConstant:CGFloat = 0 //Determines the amount of vertical impulse applied during a jump
    
    var jumpVelocityThreshold:CGFloat = 50 //character must be ascending with more velocity than this threshold
    var fallingVelocityThreshold:CGFloat = -30 //character must be descending with more velocity than this threshold.
    
    var accelerationX:Double = 0
    var accelerationY:Double = 0
    
    var canJump = true
    
    //MARK: Computed Properties
    var isFalling:Bool
    {
        if self.physicsBody?.velocity.dy < fallingVelocityThreshold
        {
            return true
        }
        return false
        
    }
    
    var isJumping:Bool // Computed property to tell whether the character is jumping or not.
        {
            if ((self.physicsBody?.velocity.dy > jumpVelocityThreshold))
            {
                return true
            }
            return false
            
        }
    
    var direction:XDirection //Computed property to tell the direction of the character
    {
        if (self.physicsBody?.velocity.dx > rightVelocityMovementThreshold)
        {
            return .Right
        }
        else if (self.physicsBody?.velocity.dx < leftVelocityMovementThreshold)
        {
            return .Left
        }
        return .None
        
    }
    
    //MARK: Class Methods
    

    /**
    Returns a character configured in a particular way from the CharacterInformation plist file. Returns a nil Character
    if there isn't a definition for that character name
    
    :param: name The name of the predefined character
    
    :returns: An optional representing the character if there are presets for one, or a nil value if there are not.
    */
    class func presetCharacter(name:String) -> Character?
    {
        var charSprite:Character?
        
        // Initialize preset characters with their unique "personality" which will affect their playstyle.
        // All presets are temporarily set to the same as that of Curiosity.
        
        let path = NSBundle.mainBundle().pathForResource("CharacterInformation", ofType: "plist")
        
        var presetCharacters:NSArray?
        
        if let validPath = path
        {
            presetCharacters = NSArray(contentsOfFile: validPath)
        }
        
        if let allCharacters = presetCharacters
        {
            for characterEntry in allCharacters
            {
                let character = characterEntry as NSDictionary
                if let thisName = character.valueForKey("name") as? String
                {
                    if (thisName == name)
                    {
                        charSprite = Character(texture: SKTexture(imageNamed: name))
                        charSprite?.name = name
                        charSprite?.physicsBody = SKPhysicsBody(circleOfRadius: charSprite!.size.height/2)//SKPhysicsBody(texture: charSprite!.texture, alphaThreshold: 0.8, size: charSprite!.size)
                        charSprite?.physicsBody?.mass = CGFloat((character.valueForKey("mass") as NSNumber).doubleValue)
                        charSprite?.jumpXMovementConstant = (character.valueForKey("jumpXMovementConstant") as NSNumber).doubleValue
                        charSprite?.torqueConstant = (character.valueForKey("torqueConstant") as NSNumber).doubleValue
                        charSprite?.jumpConstant = CGFloat((character.valueForKey("jumpConstant") as NSNumber).doubleValue)
                    }
                }
            }
        }
        
        charSprite?.physicsBody?.affectedByGravity = true
        charSprite?.physicsBody?.allowsRotation = true
        charSprite?.physicsBody?.categoryBitMask = PhysicsCategory.Character.rawValue
        
        //Offset due to the Camera/World relationship
        if let char = charSprite
        {
            charSprite?.position = CGPointMake(0, charSprite!.size.height)

        }
        
        return charSprite
    }
    
    //MARK: Instance Methods
    
    /**
    Commands the character to perform the physics related to a jump
    */
    func jump()
    {
        println(self.physicsBody?.velocity.dy)
        //Limit another jump to be started by making sure that the character isn't already jumping.
        if !isJumping && canJump
        {
            self.physicsBody?.applyImpulse(CGVectorMake(0, jumpConstant))
        }
    }
    
    /**
    Approximation of a torque curve for characters. Doubles the torque applied within the first 90 m/s of their X velocity
    
    :param: velocity The full velocity vector of the character
    
    :returns: An appropriate torque depending on the character's X velocity and the tilt of the device.
    */
    func torqueToApplyForCharacterWithVelocity(velocity:CGVector) -> CGFloat
    {
        var torque:CGFloat = 0.0
        if fabs(velocity.dx) < 90.0
        {
            torque = CGFloat(2 * (-accelerationX / torqueConstant))
        }
        else
        {
            torque = CGFloat(-accelerationX / torqueConstant)
        }
        
        return torque
    }
    
    /**
    Commands the character to move for one frame. As the applied effects are part of the physics engine, these
    effects are not guaranteed to only last for the length of one frame.
    */
    func move()
    {
        let deltaX = CGFloat(accelerationX * jumpXMovementConstant)
        
        let torqueX = torqueToApplyForCharacterWithVelocity(physicsBody!.velocity)
        
        // Determines any side motion in air
        if (isJumping)
        {
            physicsBody?.applyImpulse(CGVectorMake(deltaX, 0))
        }
            
        // Defaults to determining side motion on an area marked as solid
        else if !isJumping
        {
            physicsBody?.applyTorque(torqueX)
        }
    }
}
