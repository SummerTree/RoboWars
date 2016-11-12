//
//  Portal.swift
//  SideScroller
//
//  Created by Justin Dike 2 on 10/21/15.
//  Copyright © 2015 CartoonSmart. All rights reserved.
//

import Foundation
import SpriteKit


class Bumper: SKSpriteNode {
    
    
    
    
    func setUpBumper() {
        
       
        
        self.physicsBody?.categoryBitMask = BodyType.bumper.rawValue
        self.physicsBody?.collisionBitMask =  BodyType.player.rawValue | BodyType.bullet.rawValue | BodyType.ammo.rawValue
        self.physicsBody?.contactTestBitMask =  BodyType.bullet.rawValue 
        
    }
    
    
}