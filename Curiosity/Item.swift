//
//  Item.swift
//  Curiosity
//
//  Created by Ryan Britt on 12/28/14.
//  Copyright (c) 2014 Ryan Britt. All rights reserved.
//

import UIKit

class ItemSpriteNode: SKSpriteNode
{
    /// An effect that is stored as a closure for later use.
    var storedEffect:(() -> ())?
    
    
    /**
    Class method that generates an "orb" with a particular color.
    These orbs are used as generic items that can have any stored effect and will have an automatic
    pulsing action.
    
    - parameter color: UIColor to make the orb
    
    - returns: An ItemSpriteNode that is configured as a circular orb with a forever pulsing action.
    */
    class func orbItemWithColor(color:UIColor) -> ItemSpriteNode
    {
        let image = UIImage(named: "spark")
        let tempItem = ItemSpriteNode(texture: SKTexture(image: image!))
        
        tempItem.physicsBody = SKPhysicsBody(texture: tempItem.texture!, alphaThreshold: 0.9, size: tempItem.size)
        tempItem.physicsBody?.dynamic = false
        
        tempItem.physicsBody?.categoryBitMask = PhysicsCategory.Item.rawValue
        tempItem.physicsBody?.collisionBitMask = PhysicsCategory.Character.rawValue
        tempItem.physicsBody?.contactTestBitMask = PhysicsCategory.Character.rawValue
        
        tempItem.color = color
        tempItem.colorBlendFactor = 0.8
        
        let pulse = SKAction.repeatActionForever(SKAction.sequence([SKAction.scaleBy(2.0, duration: 1),
                                                                    SKAction.scaleTo(1.0, duration: 1)]))
        
        tempItem.runAction(pulse)
        
        return tempItem
        
    }
}

