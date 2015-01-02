//
//  Item.swift
//  Curiosity
//
//  Created by Ryan Britt on 12/28/14.
//  Copyright (c) 2014 Ryan Britt. All rights reserved.
//

import UIKit

class Item: SKSpriteNode
{
    func haveEffect(closure:() -> ())
    {
        closure()
        self.removeFromParent()
    }
}
