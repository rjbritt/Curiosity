//
//  LevelSelectPageViewController.swift
//  Curiosity
//
//  Handles the paging between Level Select View Controllers
//
//  Created by Ryan Britt on 3/28/15.
//  Copyright (c) 2015 Ryan Britt. All rights reserved.
//

import UIKit

class LevelSelectPageViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension LevelSelectPageViewController: UIPageViewControllerDataSource
{
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        return nil
    }
}