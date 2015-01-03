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
        
        let orbPlaceHolder = self.childNodeWithName("//GreenOrb1")
        var tempItem = ItemSpriteNode.orbItemWithColor(UIColor.greenColor())
//        tempItem.position = CGPointMake(272,193)//characterSpriteNode!.position.x - 100, characterSpriteNode!.position.y)

        //TODO: fix effect still being nil after explicit set.
        tempItem.effect =
            {
            let node = self.childNodeWithName("//block1")
            
            let action = SKAction.moveBy(CGVector(dx: 0, dy: 100), duration: 1)
            node?.runAction(action)
            }
        
        if let placeholder = orbPlaceHolder
        {
            tempItem.position = placeholder.position
            placeholder.parent?.addChild(tempItem)
            placeholder.removeFromParent()
        }
        
        
        
        
//        items.append(tempItem)
        
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