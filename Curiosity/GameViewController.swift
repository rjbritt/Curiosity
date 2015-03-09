
//
//  GameViewController.swift
//  Curiosity
//  This view controller manages the view that presents the CuriosityScene SKScene. It handles
//  the delegation of the level setup to the scene extension methods and loads the 
//  CuriosityScene from the appropriate .sks file as declared in the levelSelected property.
//
//  Created by Ryan Britt on 8/25/14.
//  Copyright (c) 2014 Ryan Britt. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : String?) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData!)
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as CuriosityScene
            archiver.finishDecoding()
            
            return scene
        } else {
            return nil
        }
    }
    
}



class GameViewController: UIViewController
{
    var levelMgr:LevelTracker = LevelTracker()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        prepareCuriosityScene()
    }
    
    /**
    Configures the scene depending on the current level and 
    conditionally calls methods based on what level has been selected with the scene.
    */
    func prepareCuriosityScene()
    {
        if let scene = CuriosityScene.unarchiveFromFile(levelMgr.currentLevel.rawValue) as? CuriosityScene
        {
            
            // Configure the view.
            let skView = self.view as SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.showsDrawCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = SKSceneScaleMode.AspectFill
            
            scene.gameViewControllerDelegate = self
            
            //Configure the logic for each level
            switch levelMgr.currentLevel
            {
                
            case .Tut1:
                configureTutorialForScene(scene, TutorialNumber: 1)
            case .Tut2:
                configureTutorialForScene(scene, TutorialNumber: 2)
            case .Tut3:
                configureTutorialForScene(scene, TutorialNumber: 3)
            case .Tut4:
                configureTutorialForScene(scene, TutorialNumber: 4)
                break
            case .Level1:
                configureLevel1ForScene(scene)
            case .Level2:
                configureLevel2ForScene(scene)
 
            }
            
            //Character placement allows the use of a placeholder node named "CHARACTER" or a default setting.
            if let characterNode = scene.characterSpriteNode
            {
                
                if !replacePlaceholderNode(scene.childNodeWithName("//CHARACTER"), withNode: characterNode)
                {
                    //If there is no character placeholder, place the character node in a neutral position and add to world
                    characterNode.position = CGPoint(x: 0, y: characterNode.size.height)
                    scene.childNodeWithName("//WORLD")?.addChild(characterNode)
                }
            }
            
            skView.presentScene(scene)
        }
        

    }

    /**
    Ends the level. Typically used as a callback when a GameViewController is set as a delegate to any other class.
    */
    func endLevel()
    {
        //Modally presents End Level Controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var endLevelVC = storyboard.instantiateViewControllerWithIdentifier("EndLevelViewController") as EndLevelViewController
        endLevelVC.gameViewControllerDelegate = self
        endLevelVC.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        self.presentViewController(endLevelVC, animated: true, completion: nil)

    }
    
    /**
    Returns the user to the level select view controller. Typically used as a callback when a GameViewController is set as a delegate to any other class.
    */
    func returnToLevelSelect()
    {
        //Dismisses this view controller
        self.presentingViewController?.dismissViewControllerAnimated(true, completion:{
            let skView = self.view as SKView
            //presenting a new nil scene triggers the previous scene's willMoveFromView
            skView.presentScene(nil)
        })

    }
    
    /**
    Advances the levelMgr's current level. Then reprepares the current scene based off the new current level. Typically used as a callback when a GameViewController is set as a delegate to any other class.
    */
    func loadNextLevel()
    {
        levelMgr.nextLevel()
        prepareCuriosityScene()
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.Landscape.rawValue) //AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        println("Memory Warning")
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
