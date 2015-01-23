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
        let parallaxImageNames:NSArray = NSArray(objects: "hills", "blueDayBackground")
        let size = UIImage(named:"blueDayBackground")!.size
        
        parallaxBackground = PBParallaxScrolling(backgrounds:parallaxImageNames, size:size, direction:kPBParallaxBackgroundDirectionRight, fastestSpeed:0.3, andSpeedDecrease:0.2)
        
        characterSpriteNode = Character.presetCharacter("Curiosity")
        
        //Create green orb and set effect
        var greenOrb = ItemSpriteNode.orbItemWithColor(UIColor.greenColor())
        
        greenOrb.storedEffect = {
                // Pan to and Raise Rock
                let rockNode = self.childNodeWithName("//hiddenRock") as? SKSpriteNode
                if let validRock:SKSpriteNode = rockNode
                {
                    if let camera = self.cameraNode
                    {
                        self.panCameraToLocation(CGPoint(x: validRock.position.x, y: camera.position.y), forDuration: 1, andThenWait: 1)
                    }
                    let raiseRock = SKAction.moveBy(CGVector(dx: 0, dy: validRock.size.height), duration: 1)
                    rockNode?.runAction(SKAction.sequence([SKAction.waitForDuration(1),raiseRock]))
                }
                
                
                // Raise Finish
                let finishNode = self.childNodeWithName("//Finish") as? SKSpriteNode

                if let validFinish = finishNode{
                    let action = SKAction.moveBy(CGVector(dx: 0, dy: validFinish.size.height), duration: 0)
                    finishNode?.runAction(action)
                    finishNode?.physicsBody?.categoryBitMask = PhysicsCategory.Environment.rawValue
                    finishNode?.physicsBody?.collisionBitMask = PhysicsCategory.Character.rawValue
                }
                greenOrb.removeAllActions()
        }
        
        //Replace placeholder with temp item
        let orbPlaceHolder = self.childNodeWithName("//GreenOrb1")
        if let placeholder = orbPlaceHolder
        {
            greenOrb.position = placeholder.position
            placeholder.parent?.addChild(greenOrb)
            placeholder.removeFromParent()
        }

    }
    
    func configureLevel2()
    {
        //Initializes a parallax background that will move with the character.
        let parallaxImageNames:NSArray = NSArray(objects: "hills", "blueDayBackground")
        let size = UIImage(named:"blueDayBackground")!.size
        
        parallaxBackground = PBParallaxScrolling(backgrounds:parallaxImageNames, size:size, direction:kPBParallaxBackgroundDirectionRight, fastestSpeed:2.0, andSpeedDecrease:1.0)
        
        
        characterSpriteNode = Character.presetCharacter("Curiosity")
    }
    
    func configureTutorial(tutNumber:Int)
    {
        //Initializes a parallax background that will move with the character.
        let parallaxImageNames:NSArray = NSArray(objects: "hills", "blueDayBackground")
        let size = UIImage(named:"blueDayBackground")!.size
        
        //Initialize scene properties
        parallaxBackground = PBParallaxScrolling(backgrounds:parallaxImageNames, size:size, direction:kPBParallaxBackgroundDirectionRight, fastestSpeed:0.3, andSpeedDecrease:0.2)
        
        characterSpriteNode = Character.presetCharacter("Curiosity")
        switch tutNumber
        {
        case 1:
            maxJumps = 0
        case 2:
            maxJumps = 1
        case 3:
            maxJumps = 2
        default:
            maxJumps = 2
        }
    }
}