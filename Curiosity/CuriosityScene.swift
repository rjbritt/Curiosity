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
    private var cameraSpeed:Float = 0
    private var jumpCount = 0

    //MARK: Public instance variables
    weak var gameViewControllerDelegate:CuriosityGameViewController?
    
    var farOutBackground:PBParallaxScrolling? // A background designed to be farther out than the other parallel backgrounds
    var parallaxBackground:PBParallaxScrolling? // A set of parallax backgrounds to be used as a backdrop for the action
    var maxJumps = 2
    var characterSpriteNode:Character? // The character that is currently presented in the scene
    var cameraNode:SKNode?
    var isPaused = false

    //MARK: View Lifecycle Methods
    override func didMoveToView(view: SKView)
    {
        //Since the contactTestBitMask cannot be set in the .sks, it is set to the same as the collision bit mask here before
        //any other modifications are made.
        self.enumerateChildNodesWithName("//*", usingBlock: { (node:SKNode!, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            if node.isMemberOfClass(SKSpriteNode)
            {
                let sprite = node as SKSpriteNode
                if let physicsBody = sprite.physicsBody
                {
                    physicsBody.contactTestBitMask = physicsBody.collisionBitMask
                }
            }
        })
        
        var jumpRecognizer:UIGestureRecognizer

        jumpRecognizer = UISwipeGestureRecognizer(target: self, action:"jump:")
        (jumpRecognizer as UISwipeGestureRecognizer).direction = UISwipeGestureRecognizerDirection.Up
        view.addGestureRecognizer(jumpRecognizer)
        
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
            
            if let farOut = farOutBackground
            { world.addChild(farOut) }
            
            if let character = characterSpriteNode
            { world.addChild(character) }
        }
        cameraNode = childNodeWithName("//CAMERA")
        cameraNode?.position.y = self.size.height/2
        
        self.physicsWorld.contactDelegate = self

    
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
    }
    
    override func update(currentTime: CFTimeInterval)
    {
        /* Called before each frame is rendered */
        
        if !isPaused
        {
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
                
                farOutBackground?.update(currentTime, withSpeedModifiedByFactor: backgroundSpeedFactor)
                parallaxBackground?.update(currentTime, withSpeedModifiedByFactor: backgroundSpeedFactor)
            }
        }
        else //scene is paused, but camera may be moving, so background needs to update
        {
            let backgroundSpeedFactor = determineBackgroundSpeedFactor()

            farOutBackground?.update(currentTime)
            parallaxBackground?.update(currentTime)
//            farOutBackground?.update(currentTime, withNewMaxSpeed: cameraSpeed)
//            parallaxBackground?.update(currentTime, withNewMaxSpeed: cameraSpeed)
        }

    }
    
    override func didFinishUpdate()
    {
        
        //TODO: Check and see if constant SKActions here are making the frames stutter. 
        
        //Unwrapping the camera outside of the isPaused check allows the camera to be refreshed
        //even when all of the movement in the scene is paused
        if let camera = cameraNode
        {
            //If the scene isn't paused then the camera isn't forced to keep up with the character.
            if !isPaused
            {
                if let characterSKNode = characterSpriteNode
                {
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
                            let move = SKAction.moveToY(self.size.height/2, duration: 1)
                            move.timingMode = SKActionTimingMode.Linear
                            camera.runAction(move)
                        }
                    }
                }
            }
            
            

            //Centers the view on the camera node.
            self.centerOnNode(camera)
        }
    }
    
    override func willMoveFromView(view: SKView)
    {
        self.enumerateChildNodesWithName("*", usingBlock: { (node:SKNode! , stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            node.removeAllChildren()
            node.removeAllActions()
            node.removeFromParent()
        })
    }
    
    //MARK: Accessory Methods

    /**
    Delegate method called from a UIGestureRecognizer to call the character jump method as long as it doesn't exceed the set
    maxJumps
    */
    func jump(sender:UIGestureRecognizer)
    {
        if(jumpCount < maxJumps)
        {
            jumpCount += 1
            characterSpriteNode?.jump()
        }
    }

    
    /**
    Centers the frame on a particular node. Usually this will be a node designated as the camera for the scene
    
    :param: node The node to center the frame on.
    */
    func centerOnNode(node:SKNode)
    {
        if let scene = node.scene?
        {
            // should the from node be the scene?
            var cameraPositionInScene:CGPoint = scene.convertPoint(node.position, fromNode: node.parent!)
            
            if let world = node.parent
            {
                world.position = CGPointMake(world.position.x - cameraPositionInScene.x, world.position.y - cameraPositionInScene.y)
            }
        }
    }
    
    /**
    Determines the background speed factor based on the character's current speed.
    
    :returns: A factor to be be used in computing the +background's effective speed.
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
    
    /**
    Method that handles what happens when a level is completed.
    */
    func levelFinish()
    {
       gameViewControllerDelegate?.returnToMenu()
    }
    
    func panCameraToLocation(location:CGPoint, forDuration duration:NSTimeInterval, andThenWait wait:NSTimeInterval)
    {
        if let camera = cameraNode
        {
            //Set the default direction and change it if necessary
            var toParallaxDirection:PBParallaxBackgroundDirection = kPBParallaxBackgroundDirectionRight
            var backParallaxDirection:PBParallaxBackgroundDirection = kPBParallaxBackgroundDirectionLeft

            if(location.x > camera.position.x)
            {
                toParallaxDirection = kPBParallaxBackgroundDirectionLeft
                backParallaxDirection = kPBParallaxBackgroundDirectionRight
            }
            
            //Pause all character/env moving
            isPaused = true
            
            let cameraOrigin = camera.position
            
            
            //This is the direction the parallax background needs to be moving for the pan direction.
            let setParallaxToDir = SKAction.runBlock({
                if let farOut = self.farOutBackground
                {
                    farOut.direction = toParallaxDirection
                }
                
                if let parallax = self.parallaxBackground
                {
                    parallax.direction = toParallaxDirection
                }
                self.cameraSpeed = (distanceBetweenPointOne(cameraOrigin, andPointTwo: location) / Float(duration)) / 100.0
            })
            
            let reverseParallax = SKAction.runBlock({
                self.farOutBackground?.reverseMovementDirection()
                self.parallaxBackground?.reverseMovementDirection()
                self.cameraSpeed = (distanceBetweenPointOne(cameraOrigin, andPointTwo: location) / Float(duration)) / 100.0

            })
            
            let panCamera = SKAction.sequence([SKAction.moveTo(location, duration: duration),SKAction.runBlock({
                self.cameraSpeed = 0
                })])
            
            let panCameraBack = SKAction.moveTo(cameraOrigin, duration: duration)
            let unpause = SKAction.runBlock({
                self.isPaused = false
            })
            
            let cameraAction:SKAction = SKAction.sequence([setParallaxToDir,panCamera,SKAction.waitForDuration(wait),reverseParallax, panCameraBack,unpause])
            
            self.cameraNode?.runAction(cameraAction)
        }

        

    }
}
extension CuriosityScene: SKPhysicsContactDelegate
{
    func didBeginContact(contact: SKPhysicsContact)
    {
        jumpCount = 0
        determineItemContactBetweenBodies(contact.bodyA, bodyB: contact.bodyB)
        determineEnvironmentContactBetweenBodies(contact.bodyA, bodyB: contact.bodyB)
    }
    
    
    /**
    Determines whether an item contacted a character and performs the item's stored effect if so.
    
    :param: bodyA SKPhysics body labeled A
    :param: bodyB SKPhysics body labeled B
    */
    func determineItemContactBetweenBodies(bodyA:SKPhysicsBody, bodyB:SKPhysicsBody)
    {
        var item:ItemSpriteNode?
        
        //Item Contact
        if(bodyA.categoryBitMask == PhysicsCategory.Character.rawValue &&
            bodyB.categoryBitMask == PhysicsCategory.Item.rawValue)
        { 
            item = (bodyB.node as ItemSpriteNode)
        }
        else if (bodyB.categoryBitMask == PhysicsCategory.Character.rawValue &&
            bodyA.categoryBitMask == PhysicsCategory.Item.rawValue)
        {
            item = (bodyA.node as ItemSpriteNode)
        }
        
        if let validItem = item
        {
            validItem.storedEffect?()
            validItem.storedEffect = nil
            validItem.removeFromParent()
        }
    }
    
    /**
    Determines whether an Environment contacted a character and has particular effects if the Environment is of 
    a particular type. eg:Level Finish environments.
    
    :param: bodyA SKPhysics body labeled A
    :param: bodyB SKPhysics body labeled B
    */
    func determineEnvironmentContactBetweenBodies(bodyA:SKPhysicsBody, bodyB:SKPhysicsBody)
    {
        var environment:SKSpriteNode?
        
        //Environment Contact
        if(bodyA.categoryBitMask == PhysicsCategory.Character.rawValue &&
            bodyB.categoryBitMask == PhysicsCategory.Environment.rawValue)
        {
            environment = bodyB.node as? SKSpriteNode
        }
        else if (bodyB.categoryBitMask == PhysicsCategory.Character.rawValue &&
            bodyA.categoryBitMask == PhysicsCategory.Environment.rawValue)
        {
            environment = bodyA.node as? SKSpriteNode
        }
        
        if let validEnv = environment
        {
            if validEnv.name == "Finish"
            {
                levelFinish()
            }
        }
        
    }
    
}

