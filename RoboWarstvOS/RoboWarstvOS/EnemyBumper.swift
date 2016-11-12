//
//  Portal.swift
//  SideScroller
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
