//
//  Portal.swift
//  SideScroller
//
//  Created by Justin Dike 2 on 10/21/15.
//  Copyright © 2015 CartoonSmart. All rights reserved.
//

import Foundation
import SpriteKit


class DeadZone: SKSpriteNode {
    
    
    func setUpDeadZone() {
        
     
        self.physicsBody?.categoryBitMask = BodyType.deadZone.rawValue
        self.physicsBody?.collisionBitMask = BodyType.player.rawValue | BodyType.platform.rawValue  | BodyType.enemy.rawValue
        self.physicsBody?.contactTestBitMask = BodyType.player.rawValue
        
    }
    
    
    
}