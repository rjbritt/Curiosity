
//
//  GameViewController.swift
//  Curiosity
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



class CuriosityGameViewController: UIViewController
{
    var levelSelected:CuriosityGameLevel = CuriosityGameLevel.Level1 //Defaults to level 1.
    var levelSelectVCDelegate:LevelSelectViewController?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        if let scene = CuriosityScene.unarchiveFromFile(levelSelected.rawValue) as? CuriosityScene
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

            self.prepareCuriosityScene(scene)
            scene.gameViewControllerDelegate = self

            skView.presentScene(scene)
        }
    }
    
    func prepareCuriosityScene(scene:CuriosityScene)
    {
        switch self.levelSelected
        {
        case .Level1:
            scene.configureLevel1()
        case .Level2:
            scene.configureLevel2()
        case .Level3:
            break
        case .Tut1:
            scene.configureTutorial()
        }
    }

    func returnToMenu()
    {
        levelSelectVCDelegate?.dismissViewControllerAnimated(true, completion:nil)
        let skView = self.view as SKView
        skView.presentScene(nil)
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
