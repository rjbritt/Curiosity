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
    private var motionManager = CMMotionManager();
    private var queue = NSOperationQueue();
    
    private let movementConstant:Double = 7.0
    private let jumpConstant:CGFloat = 80.0
    private let jumpVelocityLimit:CGFloat = 30.0 // Limit for the positive and negative Y velocity before another jump is allowed.
    
    private var accelerationX:Double = 0
    private var accelerationY:Double = 0
    var curiositySpriteNode:SKSpriteNode?

    override func didMoveToView(view: SKView)
    {        
        /* Setup your scene here */
        
        var swipeRecognizer:UISwipeGestureRecognizer =  UISwipeGestureRecognizer(target: self, action:"jump")
        swipeRecognizer.direction = UISwipeGestureRecognizerDirection.Up
        swipeRecognizer.delegate = self
        view.addGestureRecognizer(swipeRecognizer)
        
        if(!motionManager.accelerometerActive)
        {
            motionManager.accelerometerUpdateInterval = (1/60.0)
            motionManager.startAccelerometerUpdatesToQueue(queue, withHandler: {(acData, error) -> Void in
                self.accelerationX = acData.acceleration.y
                self.accelerationY = acData.acceleration.x
            })
        }
        
        if let curiosity = childNodeWithName("Curiosity")
        {
            curiositySpriteNode = curiosity as? SKSpriteNode
        }
        
//        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
//        myLabel.text = "Hello, World!";
//        myLabel.fontSize = 65;
//        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
//        
//        self.addChild(myLabel)
    }
//
//    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//        /* Called when a touch begins */
//        
//        for touch: AnyObject in touches {
//            let location = touch.locationInNode(self)
//            
//            let sprite = SKSpriteNode(imageNamed:"Spaceship")
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(sprite)
//        }
//    }

    func jump()
    {

        if let curiositySKNode = curiositySpriteNode
        {
            NSLog("DY:%@ \n",curiositySKNode.physicsBody!.velocity.dy)
            
            //Limit another jump to be started by making sure that the velocity is between a threshold
            if ((curiositySKNode.physicsBody?.velocity.dy < jumpVelocityLimit) && (curiositySKNode.physicsBody?.velocity.dy > -jumpVelocityLimit))
            {
                curiositySKNode.physicsBody?.applyImpulse(CGVectorMake(0, jumpConstant))
            }
        }
    }
    
    
    override func update(currentTime: CFTimeInterval)
    {
        /* Called before each frame is rendered */
        if let curiositySKNode = curiositySpriteNode
        {
            curiositySKNode.position = CGPointMake(curiositySKNode.position.x + (CGFloat(accelerationX * movementConstant)), curiositySKNode.position.y)
        }
        
        self.frame
        
//        NSLog("X: %lf Y:%lf \n",accelerationX,accelerationY)

        
        
    }
}

extension GameScene:UIGestureRecognizerDelegate
{
    
}