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
        var nextVC:CuriosityGameViewController?
        
        if segue.destinationViewController.isMemberOfClass(CuriosityGameViewController)
        {
            nextVC = segue.destinationViewController as? CuriosityGameViewController
        }
        
        if segue.identifier == "level1"
        {
           nextVC?.levelSelected = .Level1
        }
            
        else if segue.identifier == "level2"
        {
            nextVC?.levelSelected = .Level2
        }
        
        nextVC?.levelSelectVCDelegate = self

    }


}
