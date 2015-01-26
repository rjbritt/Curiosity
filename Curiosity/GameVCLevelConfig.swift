//
//  GameVCLevelExtension.swift
//  Curiosity
//
//  Created by Ryan Britt on 1/24/15.
//  Copyright (c) 2015 Ryan Britt. All rights reserved.
//

extension GameViewController
{
    func configureLevel1ForScene(scene:CuriosityScene)
    {
        //Initializes a parallax background that will move with the character.
        let parallaxImageNames:NSArray = NSArray(objects: "hills", "blueDayBackground")
        let size = UIImage(named:"blueDayBackground")!.size
        
        scene.parallaxBackground = PBParallaxScrolling(backgrounds:parallaxImageNames, size:size, direction:kPBParallaxBackgroundDirectionRight, fastestSpeed:0.3, andSpeedDecrease:0.2)
        
        scene.characterSpriteNode = Character.presetCharacter("Curiosity")
        
        //Create green orb and set effect
        var greenOrb = ItemSpriteNode.orbItemWithColor(UIColor.greenColor())
        
        greenOrb.storedEffect = {
            // Pan to and Raise Rock
            let rockNode = scene.childNodeWithName("//hiddenRock") as? SKSpriteNode
            if let validRock:SKSpriteNode = rockNode
            {
                if let camera = scene.cameraNode
                {
                    scene.panCameraToLocation(CGPoint(x: validRock.position.x, y: camera.position.y), forDuration: 1, andThenWait: 1)
                }
                let raiseRock = SKAction.moveBy(CGVector(dx: 0, dy: validRock.size.height), duration: 1)
                rockNode?.runAction(SKAction.sequence([SKAction.waitForDuration(1),raiseRock]))
            }
            
            
            // Raise Finish Node so the level can be completed
            let finishNode = scene.childNodeWithName("//Finish") as? SKSpriteNode
            
            if let validFinish = finishNode{
                let action = SKAction.moveBy(CGVector(dx: 0, dy: validFinish.size.height), duration: 0)
                finishNode?.runAction(action)
                finishNode?.physicsBody?.categoryBitMask = PhysicsCategory.Environment.rawValue
                finishNode?.physicsBody?.collisionBitMask = PhysicsCategory.Character.rawValue
            }
            greenOrb.removeAllActions()
        }
        
        //Replace placeholder with temp item
        replacePlaceholderNode(scene.childNodeWithName("//GreenOrb1"), withNode:greenOrb)

        
    }

    
    func configureLevel2ForScene(scene:CuriosityScene)
    {
        //Initializes a parallax background that will move with the character.
        let parallaxImageNames:NSArray = NSArray(objects: "hills", "blueDayBackground")
        let size = UIImage(named:"blueDayBackground")!.size
        
        scene.parallaxBackground = PBParallaxScrolling(backgrounds:parallaxImageNames, size:size, direction:kPBParallaxBackgroundDirectionRight, fastestSpeed:2.0, andSpeedDecrease:1.0)
        
        
        scene.characterSpriteNode = Character.presetCharacter("Curiosity")
    }
    
    func configureTutorialForScene(scene:CuriosityScene, TutorialNumber tutNumber:Int)
    {
        //Initializes a parallax background that will move with the character.
        let parallaxImageNames:NSArray = NSArray(objects: "hills", "blueDayBackground")
        let size = UIImage(named:"blueDayBackground")!.size
        
        //Initialize scene properties
        scene.parallaxBackground = PBParallaxScrolling(backgrounds:parallaxImageNames, size:size, direction:kPBParallaxBackgroundDirectionRight, fastestSpeed:0.3, andSpeedDecrease:0.2)
        
        scene.characterSpriteNode = Character.presetCharacter("Curiosity")
        switch tutNumber
        {
        case 1:
            scene.maxJumps = 0
        case 2:
            scene.maxJumps = 1
        case 3:
            break //maxJumps is default set to 2
        case 4:
            //Create green orb and set effect
            var greenOrb = ItemSpriteNode.orbItemWithColor(UIColor.greenColor())
            
            greenOrb.storedEffect = {
                // Pan to and Raise Finish Level
                let finishNode = scene.childNodeWithName("//Finish") as? SKSpriteNode
                if let validFinish:SKSpriteNode = finishNode
                {
                    if let camera = scene.cameraNode
                    {
                        scene.panCameraToLocation(CGPoint(x: validFinish.position.x, y: camera.position.y), forDuration: 1, andThenWait: 1)
                    }
                    let raiseFinish = SKAction.moveBy(CGVector(dx: 0, dy: validFinish.size.height), duration: 1)
                    finishNode?.runAction(SKAction.sequence([SKAction.waitForDuration(1),raiseFinish]))
                }
                greenOrb.removeAllActions()
            }
            
            //Replace placeholder with temp item
            replacePlaceholderNode(scene.childNodeWithName("//GreenOrb1"), withNode:greenOrb)
            

        default:
            break
        }
    }
    
    /**
    Replaces an optional placeholder node that may or may not be nil (If it is nil, this method does nothing) with a valid, non-nil node.
    
    :param: node1 An optional placeholder node that is found in a .sks serialized file. It may or may not be nil.
    :param: node2 The node to replace the placeholder with.
    */
    func replacePlaceholderNode(node1:SKNode?, withNode node2:SKNode)
    {
        if let placeholder = node1
        {
            node2.position = placeholder.position
            placeholder.parent?.addChild(node2)
            placeholder.removeFromParent()
        }
    }

}