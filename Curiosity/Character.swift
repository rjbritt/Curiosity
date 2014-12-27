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
    //Ideas: enum for valid characters, listening var to determine what character is currently in play
    //      Allow for double jump
    
    
    
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
    
    class func presetCharacter(name:String) -> Character?
    {
        var charSprite:Character?

        // Initialize preset characters with their unique "personality" which will affect their playstyle.
        // All presets are temporarily set to the same as that of Curiosity.
        switch name
        {
        case "Curiosity":
            charSprite = Character(texture: SKTexture(imageNamed: "Curiosity 2"))
            charSprite?.physicsBody = SKPhysicsBody(texture: charSprite!.texture, size: charSprite!.size)
            charSprite?.physicsBody?.mass = 0.2
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
        
        charSprite?.physicsBody?.affectedByGravity = true
        charSprite?.physicsBody?.allowsRotation = true
        charSprite?.position = CGPointMake(0, charSprite!.size.height)
        
        return charSprite
    }
    
    /**
    Commands the character to perform the physics related to a jump
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
