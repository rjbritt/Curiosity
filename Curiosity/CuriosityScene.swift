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
	//Defaults
	private let motionManager = CMMotionManager();
	private let queue = NSOperationQueue();
	private let framerate = 60.0 //Minimum Frames planned to deliver per second.
	private var cameraSpeed:Float = 0
	private var jumpCount = 0
	private var tempCharacterLocation = CGPointMake(0, 0)
	private var isCameraTracking = false
	private var cameraOrigin = CGPointMake(0, 0)

	//MARK: Public instance variables
	weak var gameViewControllerDelegate:GameViewController?
	
	var orientation:UIInterfaceOrientation = .LandscapeLeft
	var parallaxBackground:PBParallaxScrolling? // A set of parallax backgrounds to be used as a backdrop for the action
	var farOutBackground:PBParallaxScrolling? // A background designed to be farther out than the other parallel backgrounds
	var maxJumps = 2
	var characterSpriteNode:Character? // The character that is currently presented in the scene
	

	
	// listens to when the set method is called and sets the physics world property of the scene appropriatly
	var scenePaused:Bool = false {
		willSet(pausedValue){
			if pausedValue == true
			{ physicsWorld.speed = 0 }
			else{ physicsWorld.speed = 1 }
			
		}
	}
	
	//MARK: View Lifecycle Methods
	/**
	Initial entry point for the scene.
	
	:param: view <#view description#>
	*/
	override func didMoveToView(view: SKView)
	{
		var jumpRecognizer:UIGestureRecognizer
		jumpRecognizer = UISwipeGestureRecognizer(target: self, action:"jump:")
		(jumpRecognizer as! UISwipeGestureRecognizer).direction = UISwipeGestureRecognizerDirection.Up
		view.addGestureRecognizer(jumpRecognizer)
		
		//Starts the accelerometer updating to hand the acceleration X and Y to the character.
		if(!motionManager.accelerometerActive)
		{
			motionManager.accelerometerUpdateInterval = (1/self.framerate)
			if orientation == .LandscapeLeft {
				motionManager.startAccelerometerUpdatesToQueue(queue, withHandler: {(acData, error) -> Void in
					self.characterSpriteNode?.accelerationX = acData!.acceleration.y
					self.characterSpriteNode?.accelerationY = acData!.acceleration.x
				})
			}
				
			else {
				motionManager.startAccelerometerUpdatesToQueue(queue, withHandler: {(acData, error) -> Void in
					self.characterSpriteNode?.accelerationX = -acData!.acceleration.y
					self.characterSpriteNode?.accelerationY = -acData!.acceleration.x
				})
			}
		}
		
		
		//Add the parallax backgrounds
		if let parallax = parallaxBackground
		{ addChild(parallax) }
		
		if let farOut = farOutBackground
		{ addChild(farOut) }
		
		if let camera = camera {
			cameraOrigin = camera.position
			parallaxBackground?.position.x = camera.position.x
			farOutBackground?.position.x = camera.position.x
		}
		
		self.physicsWorld.contactDelegate = self
		
		// Create label to describe the scene.
		let myLabel = SKLabelNode(fontNamed:"Chalkduster")
		
		if let sceneName = name {
			myLabel.text = sceneName
		}
		
		myLabel.fontSize = 65
		myLabel.alpha = 0
		myLabel.position =  camera!.position // Requires a camera. Do I really want to force a camera? Maybe change...

		
		// Animate the label
		let fade = SKAction.sequence([SKAction.runBlock({self.scenePaused = true}), SKAction.fadeInWithDuration(0.5), SKAction.waitForDuration(0.5), SKAction.fadeOutWithDuration(0.5), SKAction.runBlock({self.scenePaused = false})])
		myLabel.runAction(fade)
		
		self.addChild(myLabel)
		
	}
	
	/*
	Spritekit lifecycle method called every time a frame updates. For this scene, a sanity check is called to make sure the game isn't paused
	then moves the character, adjusts the direction of the parallax backgrounds, adjusts the position of the parallax backgrounds to match that of the camera.
	*/
	override func update(currentTime: CFTimeInterval)
	{
		/* Called before each frame is rendered */
		if !scenePaused {
			if let characterSKNode = characterSpriteNode {
				characterSKNode.move()
				
			}
		}
	}
	
	
	override func didFinishUpdate() {
		if !scenePaused {
			
			//May need to remove depending on type of levels designed... Note to self for later.
			if(characterSpriteNode?.position.x >= cameraOrigin.x) {
				isCameraTracking = true
			} else {
				isCameraTracking = false
			}

		
			if isCameraTracking {
				trackCameraToCharacter()
			}
			//the background position depends on the position of the camera, so it must always be updated after the camera.
			updateBackground()
		}
	}
	
	override func willMoveFromView(view: SKView)
	{
		characterSpriteNode = nil
		farOutBackground = nil
		parallaxBackground = nil
		gameViewControllerDelegate = nil
		camera = nil
		
		self.enumerateChildNodesWithName("//*", usingBlock: { (node:SKNode! , stop:UnsafeMutablePointer<ObjCBool>) -> Void in
			node.removeAllChildren()
			node.removeAllActions()
			node.removeFromParent()
		})
		
		motionManager.stopAccelerometerUpdates()
		motionManager.stopDeviceMotionUpdates()
	}
	
	//MARK: Accessory Methods
	
	/**
	Delegate method called from a UIGestureRecognizer to call the character jump method as long as it doesn't exceed the set maxJumps
	*/
	func jump(sender:UIGestureRecognizer) {
		//TODO: EXTRACT MAX JUMP LOGIC TO CHARACTER
		if(jumpCount < maxJumps) {
			jumpCount += 1
			characterSpriteNode?.jump()
		}
	}
	
	
	/**
	Determines the background speed factor based on the character's current speed.
	
	- returns: A factor to be be used in computing the background's effective speed.
	*/
	func determineBackgroundSpeedFactor() -> Float {
		var factor:Float = 0.0
		let speedDivisionFactor:Float = 100.0 //100 rounds off the speed in a nice way as the velocity goes between 0 and 1000 on average
		if let char = characterSpriteNode {
			let speed = char.physicsBody?.velocity.dx
			if let spd = speed {
				factor = abs(Float(spd)/speedDivisionFactor)
				// absolute value because the direction handling is done in the parallax scrolling class.
			}
		}
		
		return factor
	}
	
	/**
	Handles what happens when a level is completed.
	*/
	func levelFinish() {
		scenePaused = true
		gameViewControllerDelegate?.endLevel()
	}
	
	
	/**
	Pans the camera to a specific location within the scene and then pans back to the original location.
	
	:param: location The CGPoint describing the location
	:param: duration How long the camera will take to get there (affects the speed the camera moves... d/t)
	:param: wait     How long the camera will wait until it pans back to the original location.
	*/
	func panCameraToLocation(location:CGPoint, forDuration duration:NSTimeInterval, andThenWait wait:NSTimeInterval)
	{
		if let camera = camera
		{
			//Set the default direction and change it if necessary
			var toParallaxDirection:PBParallaxBackgroundDirection = kPBParallaxBackgroundDirectionRight
			
			if(location.x > camera.position.x) {
				toParallaxDirection = kPBParallaxBackgroundDirectionLeft
			}
			scenePaused = true
			
			let cameraOrigin = camera.position
			
			//This is the direction the parallax background needs to be moving for the pan direction.
			let setParallaxToDir = SKAction.runBlock({
				if let farOut = self.farOutBackground {
					farOut.direction = toParallaxDirection
				}
				
				if let parallax = self.parallaxBackground {
					parallax.direction = toParallaxDirection
				}
				self.cameraSpeed = (distanceBetweenPointOne(cameraOrigin, andPointTwo: location) / Float(duration)) / 100.0
			})
			
			let reverseParallax = SKAction.runBlock( {
				self.farOutBackground?.reverseMovementDirection()
				self.parallaxBackground?.reverseMovementDirection()
				self.cameraSpeed = (distanceBetweenPointOne(cameraOrigin, andPointTwo: location) / Float(duration)) / 100.0
				
			})
			
			let panCamera = SKAction.sequence([SKAction.moveTo(location, duration: duration),SKAction.runBlock({
				self.cameraSpeed = 0
			})])
			
			let panCameraBack = SKAction.moveTo(cameraOrigin, duration: duration)
			let unpause = SKAction.runBlock({
				self.scenePaused = false
				self.paused = false
			})
			
			let cameraAction:SKAction = SKAction.sequence([setParallaxToDir,panCamera,SKAction.waitForDuration(wait),reverseParallax, panCameraBack,unpause])
			
			camera.runAction(cameraAction)
		}
	}
	
	
	/**
	Moves the camera based upon the character. Allows for one to one dependent X movement and Y movement based upon the original height of the scene.
	*/
	private func trackCameraToCharacter(){
		if let camera = camera {
			if let characterSKNode = characterSpriteNode {
				camera.position.x = characterSKNode.position.x
				
				//verically moves the camera up if the character is above the top of the initial viewport.
				if(characterSKNode.position.y >= self.size.height) {
					//Camera hasn't caught up with the character
					if(camera.position.y < characterSKNode.position.y) {
						//MARK: TODO Stepping, designed to make this transition smoother. Might be able to be replaced with something different in ios 9
						let difference = abs(characterSKNode.position.y - camera.position.y)
						if(difference > 5) {
							camera.position.y += 5
						}
						else { camera.position.y += difference }
					}
						//Camera has caught up with the character and follows the character's Y Value above the ground
					else { camera.position.y = characterSKNode.position.y }
				}
				else
				{
					//Moves the camera back down to the Y of the character if the character is below the top
					// of the initial viewport.
					if(camera.position.y > self.size.height/2) {
						let difference = abs(characterSKNode.position.y - camera.position.y)
						if(difference > 5) {
							camera.position.y -= 5
						}
						else {
							camera.position.y -= difference
						}
					}
				}
			}
		}
	}
	
	/**
	Aligns the parallax background position with the cameraNode position that way the
	background follows along with the camera.
	
	The background speeds are increased with a factor determined by the character's speed.
	*/
	private func updateBackground(){
		if let camera = camera{
			
			// Aligns the parallax background position with the cameraNode position that way the
			// background follows along with the camera.
			
			self.parallaxBackground?.position.x = camera.position.x
			self.farOutBackground?.position.x = camera.position.x
			
			let backgroundSpeedFactor = determineBackgroundSpeedFactor()
			farOutBackground?.updateWithSpeedModifiedByFactor(backgroundSpeedFactor)
			parallaxBackground?.updateWithSpeedModifiedByFactor(backgroundSpeedFactor)
			
			if let character = characterSpriteNode {
				if(character.direction == .Right) {
					parallaxBackground?.direction = kPBParallaxBackgroundDirectionLeft
					farOutBackground?.direction = kPBParallaxBackgroundDirectionLeft
				}
				else if(character.direction == .Left) {
					parallaxBackground?.direction = kPBParallaxBackgroundDirectionRight
					farOutBackground?.direction = kPBParallaxBackgroundDirectionRight
				}
			}
			
		}
	}
}

//MARK: SKPhysicsContactDelegate
extension CuriosityScene: SKPhysicsContactDelegate
{
	func didBeginContact(contact: SKPhysicsContact) {
		jumpCount = 0
		determineItemContactBetweenBodies(contact.bodyA, bodyB: contact.bodyB)
		determineEnvironmentContactBetweenBodies(contact.bodyA, bodyB: contact.bodyB)
	}
	
	
	/**
	Determines whether an item contacted a character and performs the item's stored effect if so.
	
	- parameter bodyA: SKPhysics body labeled A
	- parameter bodyB: SKPhysics body labeled B
	*/
	func determineItemContactBetweenBodies(bodyA:SKPhysicsBody, bodyB:SKPhysicsBody)
	{
		var item:ItemSpriteNode?
		
		//Item Contact
		if(bodyA.categoryBitMask == PhysicsCategory.Character.rawValue &&
			bodyB.categoryBitMask == PhysicsCategory.Item.rawValue) {
			item = (bodyB.node as! ItemSpriteNode)
		}
		else if (bodyB.categoryBitMask == PhysicsCategory.Character.rawValue &&
			bodyA.categoryBitMask == PhysicsCategory.Item.rawValue) {
			item = (bodyA.node as! ItemSpriteNode)
		}
		
		if let validItem = item {
			validItem.storedEffect?()
			
			//This assumes we want to remove all items from parent at time of initial use. May need to extract and refactor...
			validItem.storedEffect = nil
			validItem.removeFromParent()
		}
	}
	
	
	/**
	Determines whether an Environment contacted a character and has particular effects if the Environment is of
	a particular type. eg:Level Finish environments.
	
	- parameter bodyA: SKPhysics body labeled A
	- parameter bodyB: SKPhysics body labeled B
	*/
	func determineEnvironmentContactBetweenBodies(bodyA:SKPhysicsBody, bodyB:SKPhysicsBody) {
		var environment:SKSpriteNode?
		
		//Environment Contact
		if(bodyA.categoryBitMask == PhysicsCategory.Character.rawValue &&
			bodyB.categoryBitMask == PhysicsCategory.Environment.rawValue) {
			environment = bodyB.node as? SKSpriteNode
		}
		else if (bodyB.categoryBitMask == PhysicsCategory.Character.rawValue &&
			bodyA.categoryBitMask == PhysicsCategory.Environment.rawValue) {
			environment = bodyA.node as? SKSpriteNode
		}
		
		if let validEnv = environment {
			if validEnv.name == "Finish" {
				levelFinish()
				}
			}
	}
	
}

