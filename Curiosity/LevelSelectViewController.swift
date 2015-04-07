//
//  LevelSelectViewController.swift
//  Curiosity
//
//
//  Created by Ryan Britt on 12/27/14.
//  Copyright (c) 2014 Ryan Britt. All rights reserved.
//

import UIKit


class LevelSelectViewController: UIViewController {

    var currentLevelSelectVC:LevelSelectViewController?
    
    @IBOutlet weak var tutButton: UIButton!
    @IBOutlet weak var lvl1Button: UIButton!
    @IBOutlet weak var lvl2Button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 override func viewWillAppear(animated: Bool) {
        tutButton.tintColor = LevelTracker.levelIsUnlocked(.Tut1) ? view.window?.tintColor : UIColor.grayColor()
        lvl1Button.tintColor = LevelTracker.levelIsUnlocked(.Level1) ? view.window?.tintColor : UIColor.grayColor()
        lvl2Button.tintColor = LevelTracker.levelIsUnlocked(.Level2) ? view.window?.tintColor : UIColor.grayColor()
        
        tutButton.userInteractionEnabled = LevelTracker.levelIsUnlocked(.Tut1)
        lvl1Button.userInteractionEnabled = LevelTracker.levelIsUnlocked(.Level1)
        lvl2Button.userInteractionEnabled = LevelTracker.levelIsUnlocked(.Level2)

    }    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
        //Find the destination view controller
        var nextVC:GameViewController?
        
        if segue.destinationViewController.isMemberOfClass(GameViewController)
        {
            nextVC = segue.destinationViewController as? GameViewController
        }
        
        //Set the appropriate level selected
        var senderButton:UIButton?
        if let senderObj:AnyObject = sender
        {
            if (senderObj.isMemberOfClass(UIButton))
            {
                senderButton = sender as? UIButton
            }
        }

        
        let senderName = senderButton?.titleLabel?.text
        if let name = senderName
        {
            switch name
            {
            case "Level 1":
                nextVC?.levelMgr.goToLevel(.Level1)
            case "Level 2":
                nextVC?.levelMgr.goToLevel(.Level2)
            case "Tutorial": // If tutorial is selected, only start over the tutorial if level 1 has been unlocked
                if let vc = nextVC {
                    nextVC?.levelMgr.goToLevel(LevelTracker.levelIsUnlocked(.Level1) ? .Tut1 : LevelTracker.highestUnlockedLevel) }

            default:
                break
            }
        }

    }

    @IBAction func returnToMenu(sender: AnyObject)
    {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

}

