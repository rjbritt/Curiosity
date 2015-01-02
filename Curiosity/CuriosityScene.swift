//
//  GameScene.swift
//  Curiosity
//
//  Created by Ryan Britt on 8/25/14.
//  Copyright (c) 2014 Ryan Britt. All rights reserved.
//

import SpriteKit
import CoreMotion
import Foundation

class CuriosityScene: SKScene
{
    
    //MARK: Private instance variables
    private let motionManager = CMMotionManager();
    private let queue = NSOperationQueue();
    private let framerate = 30.0 //Minimum Frames planned to deliver per second.
    
    //MARK: Public instance variables
    var farOutBackground:PBParallaxScrolling? // A background designed to be farther out than the other parallel backgrounds
    var parallaxBackground:PBParallaxScrolling? // A set of parallax backgrounds to be used as a backdrop for the action
    
    var characterSpriteNode:Character? // The character that is currently presented in the scene
    var cameraNode:SKNode?
    var items:[Item]?


    //MARK: View Lifecycle Methods
    override func didMoveToView(view: SKView)
    {        
        //Initializes and sets the swipe gesture recognizer that will cause the character to jump
        var swipeRecognizer:UISwipeGestureRecognizer =  UISwipeGestureRecognizer(target: self, action:"jump")
        swipeRecognizer.direction = UISwipeGestureRecognizerDirection.Up
        view.addGestureRecognizer(swipeRecognizer)
        
        //Starts the accelerometer updating to hand the acceleration X and Y to the character.
        if(!motionManager.accelerometerActive)
        {
            motionManager.accelerometerUpdateInterval = (1/self.framerate)
            motionManager.startAccelerometerUpdatesToQueue(queue, withHandler: {(acData, error) -> Void in
                self.characterSpriteNode?.accelerationX = acData.acceleration.y
                self.characterSpriteNode?.accelerationY = acData.acceleration.x
            })
        }
        
        if let world = childNodeWithName("//WORLD")
        {
            parallaxBackground?.anchorPoint = CGPointMake(0,0)
            if let parallax = parallaxBackground
            { world.addChild(parallax) }
            
            if let cloud = farOutBackground
            { world.addChild(cloud) }
            
            if let character = characterSpriteNode
            { world.addChild(character) }
            
            if let allItems = items
            {
                for item in allItems
                {
                    world.addChild(item)
                }
            }
        }
        cameraNode = childNodeWithName("//CAMERA")
        cameraNode?.position.y = self.size.height/2
    
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
    }
    
    override func update(currentTime: CFTimeInterval)
    {
        /* Called before each frame is rendered */
        if let character = characterSpriteNode
        {
            character.move()
            
            if(character.direction == .Right)
            {
                parallaxBackground?.direction = kPBParallaxBackgroundDirectionLeft
                farOutBackground?.direction = kPBParallaxBackgroundDirectionLeft
            }
            else if(character.direction == .Left)
            {
                parallaxBackground?.direction = kPBParallaxBackgroundDirectionRight
                farOutBackground?.direction = kPBParallaxBackgroundDirectionRight
            }
            
            
            // Aligns the parallax background position with the cameraNode position that way the 
            // background follows along with the camera.
            self.parallaxBackground?.position.x = cameraNode!.position.x
            self.farOutBackground?.position.x = cameraNode!.position.x
            
            let backgroundSpeedFactor = determineBackgroundSpeedFactor()
            
            farOutBackground?.update(currentTime, withSpeedModifiedBy: backgroundSpeedFactor)
            parallaxBackground?.update(currentTime, withSpeedModifiedBy: backgroundSpeedFactor)
        }
    }
    
    override func didFinishUpdate()
    {
        if let characterSKNode = characterSpriteNode
        {
            if let camera = cameraNode
            {
                //Moves the camera along with the character
                camera.position.x = characterSKNode.position.x
                
                //verically moves the camera up if the character is above the top of the initial viewport.
                if(characterSKNode.position.y >= self.size.height)
                {
                    let move = SKAction.moveToY(characterSKNode.position.y, duration: 1)
                    camera.runAction(move)
                }
                else
                {
                    //Moves the camera back down to a neutral Y height if the character is below the top
                    // of the initial viewport.
                    if(camera.position.y != self.size.height/2)
                    {
                        let move = SKAction.moveToY(self.size.height/2, duration: 0.5)
                        camera.runAction(move)
                    }                    
                }
                
                //Centers the view on the camera node.
                self.centerOnNode(camera)
            }
        }

    }
    
    /**
    Local method simply to call the character jump method.
    */
    func jump()
    {
        characterSpriteNode?.jump()
    }
    
    
    
    //MARK: Accessory Methods

    
    /**
    Centers the frame on a particular node. Usually this will be a node designated as the camera for the scene
    
    :param: node The node to center the frame on.
    */
    func centerOnNode(node:SKNode)
    {
        var cameraPositionInScene:CGPoint = node.scene!.convertPoint(node.position, fromNode: node.parent!)
        
        if let world = node.parent
        {
            world.position = CGPointMake(world.position.x - cameraPositionInScene.x, world.position.y - cameraPositionInScene.y)
        }
    }
    
    /**
    Determines the background speed factor based on the character's current speed.
    
    :returns: A factor to be be used in computing the background's effective speed.
    */
    func determineBackgroundSpeedFactor() -> Float
    {
        var factor:Float = 0.0
        let speedDivisionFactor:Float = 100.0 //100 rounds off the speed in a nice way as the velocity goes between 0 and 1000 on average
        if let char = characterSpriteNode
        {
            let speed = char.physicsBody?.velocity.dx
            if let spd = speed
            {
                factor = abs(Float(spd)/speedDivisionFactor)
                // absolute value because the direction handling is done in the parallax scrolling class.
                // Attempting to do so with the sign of the velocity simply unrolls the created "banner" of repeating backgrounds.
            }
        }
        
        return factor
    }
}