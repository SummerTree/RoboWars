//
//  Portal.swift
//  SideScroller
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
