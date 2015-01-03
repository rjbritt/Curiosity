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
    var effect:(() -> ())?
        
    
    class func orbItemWithColor(color:UIColor) -> ItemSpriteNode
    {
        var tempItem = ItemSpriteNode(imageNamed: "spark")
        
        tempItem.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "spark"), alphaThreshold: 0.9, size: tempItem.size)
        tempItem.physicsBody?.dynamic = false
        
        tempItem.physicsBody?.categoryBitMask = PhysicsCategory.Item.rawValue
        tempItem.physicsBody?.collisionBitMask = PhysicsCategory.Character.rawValue//PhysicsCategory.Item.rawValue
        tempItem.physicsBody?.contactTestBitMask = PhysicsCategory.Character.rawValue
        
        tempItem.color = color
        tempItem.colorBlendFactor = 0.8
        
        let pulse = SKAction.repeatActionForever(SKAction.sequence([SKAction.scaleBy(1.5, duration: 1),
                                                                    SKAction.scaleTo(1.0, duration: 1)]))
        
        tempItem.runAction(pulse)
        
        return tempItem
        
    }
}

