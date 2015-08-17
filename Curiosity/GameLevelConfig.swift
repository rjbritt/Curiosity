//
//  GameLevelConfig.swift
//  Curiosity
//
//  Created by Ryan Britt on 1/24/15.
//  Copyright (c) 2015 Ryan Britt. All rights reserved.
//

class GameLevelConfig {
    /**
    Configures the scene as a particular tutorial scene. All the tutorial scenes have a similar background and only 
    differ based on the part of gameplay that is being demonstrated.
    
    - parameter scene:     The scene to configure
    - parameter tutNumber: What tutorial number to configure this scene for.
    */
    class func configureTutorialForScene(scene:CuriosityScene, TutorialNumber tutNumber:Int)
    {
        //Initializes a parallax background that will move with the character.
        let parallaxImageNames = NSArray(objects: "hills", "blueDayBackground")
        let size = UIImage(named:"blueDayBackground")!.size
        
        //Initialize scene properties
        scene.parallaxBackground = PBParallaxScrolling(backgrounds:parallaxImageNames as [AnyObject], size:size, direction:kPBParallaxBackgroundDirectionRight, fastestSpeed:0.3, andSpeedDecrease:0.2)
		
		scene.characterSpriteNode = Character.presetCharacter("Curiosity")
		replacePlaceholderNode(scene.childNodeWithName("//CHARACTER"), withNode:scene.characterSpriteNode!)
		
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
            let greenOrb = ItemSpriteNode.orbItemWithColor(UIColor.greenColor())
            
            greenOrb.storedEffect = {
                // Pan to and Raise Finish Level
                let finishNode = scene.childNodeWithName("//Finish") as? SKSpriteNode
                if let validFinish:SKSpriteNode = finishNode
                {
                    if let camera = scene.camera
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
    
    class func configureLevel1ForScene(scene:CuriosityScene)
    {
        //Initializes a parallax background that will move with the character.
        let parallaxImageNames = NSArray(objects: "hills", "blueDayBackground")
        let size = UIImage(named:"blueDayBackground")!.size
        
        scene.parallaxBackground = PBParallaxScrolling(backgrounds:parallaxImageNames as [AnyObject], size:size, direction:kPBParallaxBackgroundDirectionRight, fastestSpeed:0.3, andSpeedDecrease:0.2)
		
		scene.characterSpriteNode = Character.presetCharacter("Curiosity")
		replacePlaceholderNode(scene.childNodeWithName("//CHARACTER"), withNode:scene.characterSpriteNode!)
		
        let greenOrb = ItemSpriteNode.orbItemWithColor(UIColor.greenColor())
        greenOrb.storedEffect = {
			
            // Pan to and Raise Rock
            let rockNode = scene.childNodeWithName("//hiddenRock") as? SKSpriteNode
            if let validRock:SKSpriteNode = rockNode {
                if let camera = scene.camera {
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
            }
            greenOrb.removeAllActions()
        }
        
        replacePlaceholderNode(scene.childNodeWithName("//GreenOrb1"), withNode:greenOrb)
        scene.name = "Level 1"
        
    }

    
    class func configureLevel2ForScene(scene:CuriosityScene)
    {
        //Initializes a parallax background that will move with the character.
        let parallaxImageNames = NSArray(objects: "hills", "blueDayBackground")
        let size = UIImage(named:"blueDayBackground")!.size
        
        scene.parallaxBackground = PBParallaxScrolling(backgrounds:parallaxImageNames as [AnyObject], size:size, direction:kPBParallaxBackgroundDirectionRight, fastestSpeed:0.3, andSpeedDecrease:0.2)
        
		scene.characterSpriteNode = Character.presetCharacter("Curiosity")
		replacePlaceholderNode(scene.childNodeWithName("//CHARACTER"), withNode:scene.characterSpriteNode!)
		
        scene.name = "Level 2"
        
        let greenOrb = ItemSpriteNode.orbItemWithColor(UIColor.greenColor())
        let greenOrb2 = ItemSpriteNode.orbItemWithColor(UIColor.greenColor())
        
        let yScalePercent = 50;
        
        greenOrb.storedEffect = {

            //Find and scale the first tree 
            if let treeTrunk1 = scene.childNodeWithName("//TreeTrunk1") as? SKSpriteNode {
                if let tree1 = scene.childNodeWithName("//TreeTop1") as? SKSpriteNode {
                    scaleTreeTrunk(treeTrunk1, toYPercent: yScalePercent, andMoveTop: tree1)
                }
                
            }
            
            //Find and scale the second tree
            if let treeTrunk2 =  scene.childNodeWithName("//TreeTrunk2") as? SKSpriteNode {
                if let tree2 = scene.childNodeWithName("//TreeTop2") as? SKSpriteNode {
                    scaleTreeTrunk(treeTrunk2, toYPercent: yScalePercent, andMoveTop: tree2)
                }
            }
        }
        
        greenOrb2.storedEffect = {
            
        }
        replacePlaceholderNode(scene.childNodeWithName("//GreenOrb1"), withNode: greenOrb)
        replacePlaceholderNode(scene.childNodeWithName("//GreenOrb2"), withNode: greenOrb2)
    }
    
    
    /**
    Replaces an optional placeholder node in a scene with a valid, non-nil node. If the placeholder is nil, this method does nothing.
    
    - parameter node1: An optional placeholder node that is found in a .sks serialized file. It may or may not be nil.
    - parameter node2: The node to replace the placeholder with.
    
    - returns: Bool stating whether the replacement was successful or not.
    */
    private class func replacePlaceholderNode(node1:SKNode?, withNode node2:SKNode) -> Bool
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
    
    private class func panToAndRaiseSpriteNode(node:SKSpriteNode, inScene scene:CuriosityScene,withCamera camera:SKCameraNode, andWaitFor wait:NSTimeInterval) {
        
        scene.panCameraToLocation(CGPoint(x: node.position.x, y: camera.position.y), forDuration: 1, andThenWait: wait)
        let raiseNode = SKAction.moveBy(CGVector(dx: 0, dy: node.size.height), duration: 1)
        node.runAction(SKAction.sequence([SKAction.waitForDuration(1),raiseNode]))
    }
    
    private class func scalesSKSpriteNodebyXPercent(xPercent:Int, andYPercent yPercent:Int, forDuration duration:NSTimeInterval) -> SKAction {
        
        let xScalar = CGFloat(xPercent) / 100.00
        let yScalar = CGFloat(yPercent) / 100.00
        
        return SKAction.scaleXBy(xScalar, y:yScalar, duration: duration)
    }
    
    private class func scaleTreeTrunk(trunk:SKSpriteNode, toYPercent percent:Int, andMoveTop top:SKSpriteNode){
        let newHeight = trunk.size.height * (CGFloat(percent) / 100.00)
        let positionDifference = trunk.position.y + (newHeight/2)
        let newPosition = trunk.position.y - positionDifference
        
        let scaleTreeTrunk = scalesSKSpriteNodebyXPercent(100, andYPercent: percent, forDuration: 1)
        let moveTrunkUp = SKAction.moveToY(newPosition, duration: 1)
        let combination = SKAction.group([scaleTreeTrunk, moveTrunkUp])
        let moveDown = SKAction.moveByX(0, y: -newHeight, duration: 1)
  
        trunk.runAction(combination)
        top.runAction(moveDown)
    }


}