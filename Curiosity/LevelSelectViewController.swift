//
//  LevelSelectViewController.swift
//  Curiosity
//
//  Created by Ryan Britt on 12/27/14.
//  Copyright (c) 2014 Ryan Britt. All rights reserved.
//

import UIKit

class LevelSelectViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "level1"
        {
            let nextVC = segue.destinationViewController as CuriosityGameVC
            
            nextVC.levelSelected = .Level1
        }
        else if segue.identifier == "level2"
        {
            let nextVC = segue.destinationViewController as CuriosityGameVC
            nextVC.levelSelected = .Level2

        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
