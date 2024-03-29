//
//  GameVCLevelExtension.swift
//  Curiosity
//
//  Created by Ryan Britt on 1/24/15.
//  Copyright (c) 2015 Ryan Britt. All rights reserved.
//

extension GameViewController
{
    /**
    Configures the scene as a particular tutorial scene. All the tutorial scenes have a similar background and only 
    differ based on the part of gameplay that is being demonstrated.
    
    :param: scene     The scene to configure
    :param: tutNumber What tutorial number to configure this scene for.
    */
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
        case 1: //Tilt Tutorial
            scene.maxJumps = 0
            scene.name = "Tilt To Move"
            
        case 2: //Jump Tutorial
            scene.maxJumps = 1
            scene.name = "Swipe Up To Jump"
            
        case 3://Double Jump Tutorial
            scene.name = "Double Jump"
            break //maxJumps is default set to 2
            
        case 4://Effect Tutorial
            scene.name = "Move to Orb"
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
        scene.name = "Level 1"
        
    }

    
    func configureLevel2ForScene(scene:CuriosityScene)
    {
        //Initializes a parallax background that will move with the character.
        let parallaxImageNames:NSArray = NSArray(objects: "hills", "blueDayBackground")
        let size = UIImage(named:"blueDayBackground")!.size
        
        scene.parallaxBackground = PBParallaxScrolling(backgrounds:parallaxImageNames, size:size, direction:kPBParallaxBackgroundDirectionRight, fastestSpeed:0.3, andSpeedDecrease:0.2)
        
        scene.characterSpriteNode = Character.presetCharacter("Curiosity")
        scene.name = "Level 2"
    }
    
    
    /**
    Replaces an optional placeholder node in a scene with a valid, non-nil node. If the placeholder is nil, this method does nothing.
    
    :param: node1 An optional placeholder node that is found in a .sks serialized file. It may or may not be nil.
    :param: node2 The node to replace the placeholder with.
    
    :returns: Bool stating whether the replacement was successful or not.
    */
    func replacePlaceholderNode(node1:SKNode?, withNode node2:SKNode) -> Bool
    {
        var successful = false
        
        if let placeholder = node1
        {
            if let parent = placeholder.parent
            {
                node2.position = placeholder.position
                parent.addChild(node2)
                placeholder.removeFromParent()
                successful = true
            }
        }
        return successful
    }

}