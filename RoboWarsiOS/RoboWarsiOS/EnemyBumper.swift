//
//  Portal.swift
//  SideScroller
//
//  Created by Justin Dike 2 on 10/21/15.
//  Copyright © 2015 CartoonSmart. All rights reserved.
//

import Foundation
import SpriteKit


class EnemyBumper: SKSpriteNode {
    
    
    
    
    func setUpBumper() {
        
       
        
        self.physicsBody?.categoryBitMask = BodyType.enemybumper.rawValue
        self.physicsBody?.collisionBitMask = BodyType.enemy.rawValue
        self.physicsBody?.contactTestBitMask = BodyType.enemy.rawValue 
        
    }
    
    
}