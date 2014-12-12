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
    var cloudBackground:PBParallaxScrolling?
    var parallaxBackground:PBParallaxScrolling?
    
    //MARK: Public instance variables
    var characterSpriteNode:Character?
    var cameraNode:SKNode?


    //MARK: View Lifecycle Methods
    override func didMoveToView(view: SKView)
    {        
        /* Setup your scene here */
        
        let parallaxImages:NSArray = NSArray(objects:UIImage(named: "flowers")!,UIImage(named: "hills")!)
        let size = UIImage(named:"blueDayBackground")!.size
        parallaxBackground = PBParallaxScrolling(backgrounds:parallaxImages, size:size, direction:kPBParallaxBackgroundDirectionRight, fastestSpeed:3.0, andSpeedDecrease:1.0)
      
        cloudBackground = PBParallaxScrolling(backgrounds: NSArray(object:UIImage(named: "blueDayBackground")!), size: size, direction: kPBParallaxBackgroundDirectionRight, fastestSpeed: 1.0, andSpeedDecrease: 1.0)
        cloudBackground?.zPosition = parallaxBackground!.zPosition - 1
        
        var swipeRecognizer:UISwipeGestureRecognizer =  UISwipeGestureRecognizer(target: self, action:"jump")
        swipeRecognizer.direction = UISwipeGestureRecognizerDirection.Up
        view.addGestureRecognizer(swipeRecognizer)
        
        if(!motionManager.accelerometerActive)
        {
            motionManager.accelerometerUpdateInterval = (1/self.framerate)
            motionManager.startAccelerometerUpdatesToQueue(queue, withHandler: {(acData, error) -> Void in
                self.characterSpriteNode?.accelerationX = acData.acceleration.y
                self.characterSpriteNode?.accelerationY = acData.acceleration.x
            })
        }
        
        let tempNode = childNodeWithName("//Curiosity") as? SKSpriteNode
        characterSpriteNode = Character.presetCharacterNamed("Curiosity")//presetCharacterFromChildNode(tempNode)
        tempNode?.removeFromParent()
        
        
        if let world = childNodeWithName("//WORLD")
        {
            parallaxBackground?.anchorPoint = CGPointMake(0,0)
            world.addChild(parallaxBackground!)
            world.addChild(cloudBackground!)
            world.addChild(characterSpriteNode!)
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
            let deltaX = CGFloat(character.accelerationX * character.jumpXMovementConstant)
            
            let torqueX = character.torqueToApplyForCharacterWithVelocity(character.physicsBody!.velocity)
            
            if(character.physicsBody!.velocity.dx > 0.1)
            {
                self.parallaxBackground?.direction = kPBParallaxBackgroundDirectionLeft
                self.parallaxBackground?.update(currentTime)
                
            }
            else if(character.physicsBody!.velocity.dx < -0.1)
            {
                self.parallaxBackground?.direction = kPBParallaxBackgroundDirectionRight
                self.parallaxBackground?.update(currentTime)
            }
            
            if (character.isJumping)
            {
                character.physicsBody?.applyImpulse(CGVectorMake(deltaX, 0))
            }
            else if !character.isJumping
            {
                character.physicsBody?.applyTorque(torqueX)
            }
            
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
                camera.position.x = characterSKNode.position.x
                
                if(characterSKNode.position.y >= self.size.height)
                {
                    let move = SKAction.moveToY(characterSKNode.position.y, duration: 1)
                    camera.runAction(move)
                }
                else
                {
                    if(camera.position.y != self.size.height/2)
                    {
                        let move = SKAction.moveToY(self.size.height/2, duration: 0.5)
                        camera.runAction(move)
                    }                    
                }
                
                self.centerOnNode(camera)
            }
        }

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