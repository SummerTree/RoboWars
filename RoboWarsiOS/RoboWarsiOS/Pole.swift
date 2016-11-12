//
//  Pole.swift
//  SideScroller
//
//  Created by Justin Dike 2 on 10/20/15.
//  Copyright © 2015 CartoonSmart. All rights reserved.
//

import Foundation
import SpriteKit


class Pole: SKSpriteNode {
    
    func setUpPole() {
        
        let body:SKPhysicsBody = SKPhysicsBody(rectangleOf: self.frame.size)
        
        self.physicsBody = body
        body.isDynamic = false
        body.affectedByGravity = false
        body.allowsRotation = false
        
        self.physicsBody?.categoryBitMask = BodyType.pole.rawValue
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = BodyType.player.rawValue
        
    }
    
    
}
