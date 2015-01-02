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
        
//        var tempItem = Item(imageNamed: "spark")
//        tempItem.position = CGPointMake(characterSpriteNode!.position.x, characterSpriteNode!.position.y)
//        items?.append(tempItem)
        
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