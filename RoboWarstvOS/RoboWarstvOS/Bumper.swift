//
//  Portal.swift
//  SideScroller
//


import Foundation
import SpriteKit


class Bumper: SKSpriteNode {
    
    
    
    
    func setUpBumper() {
        
       
        
        self.physicsBody?.categoryBitMask = BodyType.bumper.rawValue
        self.physicsBody?.collisionBitMask =  BodyType.player.rawValue | BodyType.bullet.rawValue | BodyType.ammo.rawValue
        self.physicsBody?.contactTestBitMask =  BodyType.bullet.rawValue | BodyType.player.rawValue
        
    }
    
    
}
