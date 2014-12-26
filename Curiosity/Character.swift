//
//  Character.swift
//  Curiosity
//
//  Created by Ryan Britt on 12/8/14.
//  Copyright (c) 2014 Ryan Britt. All rights reserved.
//

import UIKit

class Character: SKSpriteNode
{
    var jumpXMovementConstant:Double = 0 //Determines the amount of movement allowed midair while jumping
    var torqueConstant:Double = 0 //Determines the amount of torque applied during movement
    var jumpConstant:CGFloat = 0 //Determines the amount of vertical impulse applied during a jump
    var ascendingJumpVelocityThreshold:CGFloat = 0 //character must be ascending with less velocity than this threshold.
    var descendingJumpVelocityThreshold:CGFloat = 0 //character must be descending with less velocity than this threshold.
    
    var accelerationX:Double = 0
    var accelerationY:Double = 0
    
    var isJumping:Bool
        {
            // If the Y velocity is between a threshold, then the character is jumping
            if ((self.physicsBody?.velocity.dy < ascendingJumpVelocityThreshold) &&
                (self.physicsBody?.velocity.dy > descendingJumpVelocityThreshold))
            {
                return false
            }
            return true
        }
    
    convenience init(fromSKSpriteNode:SKSpriteNode)
    {
        self.init(texture: fromSKSpriteNode.texture, color: fromSKSpriteNode.color, size: fromSKSpriteNode.size)
        self.name = fromSKSpriteNode.name
        self.position = fromSKSpriteNode.position
        self.zPosition = fromSKSpriteNode.zPosition
        self.physicsBody = fromSKSpriteNode.physicsBody
        
    }
    
    class func presetCharacterFromChildNode(charSpriteNode:SKSpriteNode?) -> Character?
    {
        var charSprite:Character?
        
        if let character = charSpriteNode
        {
            charSprite = Character(fromSKSpriteNode: character)
        }
        
        if let name = charSpriteNode?.name
        {
                // Initialize preset characters with their unique "personality" which will affect their playstyle.
                // All presets are temporarily set to the same as that of Curiosity.
                switch name
                {
                case "Curiosity":
                    charSprite?.jumpXMovementConstant = 3.0
                    charSprite?.torqueConstant = 7.0
                    charSprite?.jumpConstant = 150.0
                    charSprite?.ascendingJumpVelocityThreshold = 30.0
                    charSprite?.descendingJumpVelocityThreshold = -120.0
                    
                case "Excite":
                    charSprite?.jumpXMovementConstant = 3.0
                    charSprite?.torqueConstant = 7.0
                    charSprite?.jumpConstant = 150.0
                    charSprite?.ascendingJumpVelocityThreshold = 30.0
                    charSprite?.descendingJumpVelocityThreshold = -120.0
                    
                case "Anx":
                    charSprite?.jumpXMovementConstant = 3.0
                    charSprite?.torqueConstant = 7.0
                    charSprite?.jumpConstant = 150.0
                    charSprite?.ascendingJumpVelocityThreshold = 30.0
                    charSprite?.descendingJumpVelocityThreshold = -120.0
                    
                case "Adam":
                    charSprite?.jumpXMovementConstant = 3.0
                    charSprite?.torqueConstant = 7.0
                    charSprite?.jumpConstant = 150.0
                    charSprite?.ascendingJumpVelocityThreshold = 30.0
                    charSprite?.descendingJumpVelocityThreshold = -120.0
                    
                case "Amora":
                    charSprite?.jumpXMovementConstant = 3.0
                    charSprite?.torqueConstant = 7.0
                    charSprite?.jumpConstant = 150.0
                    charSprite?.ascendingJumpVelocityThreshold = 30.0
                    charSprite?.descendingJumpVelocityThreshold = -120.0
                    
                case "Pragma":
                    charSprite?.jumpXMovementConstant = 3.0
                    charSprite?.torqueConstant = 7.0
                    charSprite?.jumpConstant = 150.0
                    charSprite?.ascendingJumpVelocityThreshold = 30.0
                    charSprite?.descendingJumpVelocityThreshold = -120.0
                    
                case "Uto":
                    charSprite?.jumpXMovementConstant = 3.0
                    charSprite?.torqueConstant = 7.0
                    charSprite?.jumpConstant = 150.0
                    charSprite?.ascendingJumpVelocityThreshold = 30.0
                    charSprite?.descendingJumpVelocityThreshold = -120.0
                    
                default:
                    break
                }

        }
        
        return charSprite
    }
    
    /**
    Method to perform the physics related to a jump
    */
    func jump()
    {
        //Limit another jump to be started by making sure that the character isn't already jumping.
        if !isJumping
        {
            self.physicsBody?.applyImpulse(CGVectorMake(0, jumpConstant))
        }
        
    }
    
    /**
    Approximation of a torque curve for characters. Doubles the torque applied within the first 90 m/s of their X velocity
    
    :param: velocity The full velocity vector of the character
    
    :returns: An appropriate torque depending on the character's velocity and the tilt of the device.
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
}
