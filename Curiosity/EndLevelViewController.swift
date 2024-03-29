//
//  EndLevelViewController.swift
//  Curiosity
//
//  Created by Ryan Britt on 1/25/15.
//  Copyright (c) 2015 Ryan Britt. All rights reserved.
//

import UIKit

class EndLevelViewController: UIViewController {
    
    var gameViewControllerDelegate:GameViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returnToLevelSelect(sender: AnyObject) {
        
                gameViewControllerDelegate?.returnToLevelSelect()
    }
    
    @IBAction func nextLevel(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        gameViewControllerDelegate?.loadNextLevel()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
