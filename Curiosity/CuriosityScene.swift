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
    private var motionManager = CMMotionManager();
    private var queue = NSOperationQueue();
    private let framerate = 60.0 //Frames planned to deliver per second.

    
    //MARK: Public instance variables
    var cloudBackground:PBParallaxScrolling?
    var parallaxBackground:PBParallaxScrolling?
    var characterSpriteNode:Character?
    var cameraNode:SKNode?


    //MARK: View Lifecycle Methods
    override func didMoveToView(view: SKView)
    {
        
        //Initializes a parallax background that will move with the character.
        let parallaxImages:NSArray = NSArray(objects:UIImage(named: "flowers")!,UIImage(named: "hills")!)
        let size = UIImage(named:"blueDayBackground")!.size
        
        parallaxBackground = PBParallaxScrolling(backgrounds:parallaxImages, size:size, direction:kPBParallaxBackgroundDirectionRight, fastestSpeed:3.0, andSpeedDecrease:1.0)
      
        //Initializes a cloud parallax background that will always move
        cloudBackground = PBParallaxScrolling(backgrounds: NSArray(object:UIImage(named: "blueDayBackground")!), size: size, direction: kPBParallaxBackgroundDirectionRight, fastestSpeed: 1.0, andSpeedDecrease: 1.0)
        cloudBackground?.zPosition = parallaxBackground!.zPosition - 1
        
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
        
        //Create the initial Character
        characterSpriteNode = Character.presetCharacter("Curiosity")
        
        if let world = childNodeWithName("//WORLD")
        {
            parallaxBackground?.anchorPoint = CGPointMake(0,0)
            if let parallax = parallaxBackground
            { world.addChild(parallax) }
            
            if let cloud = cloudBackground
            { world.addChild(cloud) }
            
            if let character = characterSpriteNode
            { world.addChild(character) }
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
            
            if(physicsBody!.velocity.dx > 0.1)
            {
                self.parallaxBackground?.direction = kPBParallaxBackgroundDirectionLeft
                self.parallaxBackground?.update(currentTime)
                
            }
            else if(character.physicsBody!.velocity.dx < -0.1)
            {
                self.parallaxBackground?.direction = kPBParallaxBackgroundDirectionRight
                self.parallaxBackground?.update(currentTime)
            }
            
            // Aligns the parallax background position with the cameraNode position that way the 
            // background follows along with the camera.
            self.parallaxBackground?.position.x = cameraNode!.position.x
            self.cloudBackground?.position.x = cameraNode!.position.x
            self.cloudBackground?.update(currentTime)
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
}