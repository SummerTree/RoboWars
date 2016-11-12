//
//  Pole.swift
//  SideScroller
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
