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

class GameScene: SKScene
{
    
    //MARK: Private instance variables
    private var motionManager = CMMotionManager();
    private var queue = NSOperationQueue();
    
    private let framerate = 60.0 //Frames planned to deliver per second.
    private let jumpXMovementConstant:Double = 3.0
    private let torqueConstant:Double = 7.0 //7.0
    private let jumpConstant:CGFloat = 150.0
    private let ascendingJumpVelocityThreshold:CGFloat = 30.0 //character must be ascending with less velocity than this threshold.
    private let descendingJumpVelocityThreshold:CGFloat = -120.0 //character must be descending with less velocity than this threshold.
    
    private var accelerationX:Double = 0
    private var accelerationY:Double = 0
    private var cloudBackground:PBParallaxScrolling?
    private var parallaxBackground:PBParallaxScrolling?
    
    //MARK: Public instance variables
    var curiositySpriteNode:SKSpriteNode?
    var cameraNode:SKNode?
    var isJumping:Bool
        {
        if let curiositySKNode = curiositySpriteNode
        {
            // If the Y velocity is between a threshold, then the character is jumping
            if ((curiositySKNode.physicsBody?.velocity.dy < ascendingJumpVelocityThreshold) &&
                (curiositySKNode.physicsBody?.velocity.dy > descendingJumpVelocityThreshold))
            {
                return false
            }
        }
        return true
    }

    //MARK: View Lifecycle Methods
    override func didMoveToView(view: SKView)
    {        
        /* Setup your scene here */
        
        let parallaxImages:NSArray = NSArray(objects:UIImage(named: "flowers")!,UIImage(named: "hills")!)
        let size = UIImage(named:"blueDayBackground")!.size
        parallaxBackground = PBParallaxScrolling(backgrounds:parallaxImages, size:size, direction:kPBParallaxBackgroundDirectionRight, fastestSpeed:3.0, andSpeedDecrease:1.0)
      
        cloudBackground = PBParallaxScrolling(backgrounds: NSArray(object:UIImage(named: "blueDayBackground")!), size: size, direction: kPBParallaxBackgroundDirectionRight, fastestSpeed: 1.0, andSpeedDecrease: 1.0)
        cloudBackground?.zPosition = parallaxBackground!.zPosition - 1
        
        
        if let world = childNodeWithName("//WORLD")
        {
            parallaxBackground?.anchorPoint = CGPointMake(0,0)
            world.addChild(parallaxBackground!)
            world.addChild(cloudBackground!)
        }
        
        var swipeRecognizer:UISwipeGestureRecognizer =  UISwipeGestureRecognizer(target: self, action:"jump")
        swipeRecognizer.direction = UISwipeGestureRecognizerDirection.Up
        view.addGestureRecognizer(swipeRecognizer)
        
        if(!motionManager.accelerometerActive)
        {
            motionManager.accelerometerUpdateInterval = (1/self.framerate)
            motionManager.startAccelerometerUpdatesToQueue(queue, withHandler: {(acData, error) -> Void in
                self.accelerationX = acData.acceleration.y
                self.accelerationY = acData.acceleration.x
            })
        }
        
        if let curiosity = childNodeWithName("//Curiosity")
        {
            curiositySpriteNode = curiosity as? SKSpriteNode
        }
        
        cameraNode = childNodeWithName("//CAMERA")
        cameraNode?.position.y = self.size.height/2
    
        
//        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
//        myLabel.text = "Hello, World!";
//        myLabel.fontSize = 65;
//        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
//        
//        self.addChild(myLabel)
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
    }
    
    override func update(currentTime: CFTimeInterval)
    {
        let deltaX = CGFloat(accelerationX * jumpXMovementConstant)

        /* Called before each frame is rendered */
        if let curiositySKNode = curiositySpriteNode
        {
            let torqueX = torqueToApplyForCharacterWithVelocity(curiositySKNode.physicsBody!.velocity)//CGFloat(-accelerationX / torqueContstant)

            if(curiositySKNode.physicsBody!.velocity.dx > 0.1)
            {
                self.parallaxBackground?.direction = kPBParallaxBackgroundDirectionLeft
                self.parallaxBackground?.update(currentTime)

            }
            else if(curiositySKNode.physicsBody!.velocity.dx < -0.1)
            {
                self.parallaxBackground?.direction = kPBParallaxBackgroundDirectionRight
                self.parallaxBackground?.update(currentTime)

            }
            
            if(isJumping)
            {
                curiositySKNode.physicsBody?.applyImpulse(CGVectorMake(deltaX, 0))
            }
            else if !isJumping
            {
                curiositySKNode.physicsBody?.applyTorque(torqueX)
            }
            self.parallaxBackground?.position.x = cameraNode!.position.x
            self.cloudBackground?.position.x = cameraNode!.position.x
            self.cloudBackground?.update(currentTime)

        }
    }
    
    override func didFinishUpdate()
    {
        if let curiositySKNode = curiositySpriteNode
        {
            if let camera = cameraNode
            {
                camera.position.x = curiositySKNode.position.x
                
                if(curiositySKNode.position.y >= self.size.height)
                {
                    let move = SKAction.moveToY(curiositySKNode.position.y, duration: 1)
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
    
    //MARK: Methods
    
    /**
    Method to perform the physics related to a jump
    */
    func jump()
    {
        if let curiositySKNode = curiositySpriteNode
        {
            //Limit another jump to be started by making sure that the character isn't already jumping.
            if !isJumping
            {
                curiositySKNode.physicsBody?.applyImpulse(CGVectorMake(0, jumpConstant))
            }
        }
    }
    
    /**
    Approximation of a torque curve for characters. Doubles the torque applied within the first 90 m/s of their X velocity
    
    :param: velocity The full velocity vector of the character
    
    :returns: An appropriate torque depending on the character's velocity and the tilt of the device.
    */
    func torqueToApplyForCharacterWithVelocity(velocity:CGVector) -> CGFloat
    {
        var torque:CGFloat = 0.0
        if fabs(velocity.dx) < 90.0
        {
            torque = CGFloat(2 * (-accelerationX / torqueConstant))
        }
        else
        {
            torque = CGFloat(-accelerationX / torqueConstant)
        }
        
        return torque
    }
    
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