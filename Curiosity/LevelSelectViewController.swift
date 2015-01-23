//
//  LevelSelectViewController.swift
//  Curiosity
//
//  Created by Ryan Britt on 12/27/14.
//  Copyright (c) 2014 Ryan Britt. All rights reserved.
//

import UIKit

class LevelSelectViewController: UIViewController {

    @IBOutlet weak var jumpControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
        //Find the destination view controller
        var nextVC:GameViewController?
        
        if segue.destinationViewController.isMemberOfClass(GameViewController)
        {
            nextVC = segue.destinationViewController as? GameViewController
        }
        
        nextVC?.levelSelectVCDelegate = self
        
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
                nextVC?.levelSelected = .Level1
            case "Level 2":
                nextVC?.levelSelected = .Level2
            case "Tutorial":
                nextVC?.levelSelected = .Tut3
            default:
                break
            }
        }

    }


}
