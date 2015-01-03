//
//  SceneExtensionForLevels.swift
//  Curiosity
//
//  Created by Ryan Britt on 12/27/14.
//  Copyright (c) 2014 Ryan Britt. All rights reserved.
//

extension CuriosityScene
{
    func configureLevel1()
    {
        //Initializes a parallax background that will move with the character.
        let parallaxImages:NSArray = NSArray(objects:UIImage(named: "hills")!,UIImage(named:"blueDayBackground")!)
        let size = UIImage(named:"blueDayBackground")!.size
        
        parallaxBackground = PBParallaxScrolling(backgrounds:parallaxImages, size:size, direction:kPBParallaxBackgroundDirectionRight, fastestSpeed:2.0, andSpeedDecrease:1.0)
        
        characterSpriteNode = Character.presetCharacter("Curiosity")
        
        //Create temp Item and set effect
        var tempItem = ItemSpriteNode.orbItemWithColor(UIColor.greenColor())
        
        tempItem.effect =
            {
                let node = self.childNodeWithName("//hiddenRock") as? SKSpriteNode
                if let validNode = node
                {
                    let action = SKAction.moveBy(CGVector(dx: 0, dy: validNode.size.height), duration: 1)
                    node?.runAction(action)
                }
        }

        self.enumerateChildNodesWithName("//*Orb*", usingBlock: { (node, stop) -> Void in
            if let placeholder:SKSpriteNode = (node as? SKSpriteNode)
            {
                if placeholder.name == "GreenOrb1"
                {
                    tempItem.position = placeholder.position
                    placeholder.parent?.addChild(tempItem)
                    placeholder.removeFromParent()
                }
            }
        })

        
        //Replace placeholder with temp item
        let orbPlaceHolder = self.childNodeWithName("//GreenOrb1")
        if let placeholder = orbPlaceHolder
        {
            tempItem.position = placeholder.position
            placeholder.parent?.addChild(tempItem)
            placeholder.removeFromParent()
        }

    }
    
    func configureLevel2()
    {
        //Initializes a parallax background that will move with the character.
        let parallaxImages:NSArray = NSArray(objects:UIImage(named: "hills")!,UIImage(named:"blueDayBackground")!)
        let size = UIImage(named:"blueDayBackground")!.size
        
        parallaxBackground = PBParallaxScrolling(backgrounds:parallaxImages, size:size, direction:kPBParallaxBackgroundDirectionRight, fastestSpeed:2.0, andSpeedDecrease:1.0)
        
        characterSpriteNode = Character.presetCharacter("Curiosity")
    }
    
    
}