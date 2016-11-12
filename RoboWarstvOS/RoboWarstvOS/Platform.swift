//
//  Platform.swift
//  SideScroller
//


import Foundation
import SpriteKit


class Platform: SKSpriteNode {
    
    var initialPosition:CGPoint = CGPoint.zero
    
    func setUpPlatform() {

        self.physicsBody?.categoryBitMask = BodyType.platform.rawValue
        self.physicsBody?.collisionBitMask = BodyType.player.rawValue | BodyType.platform.rawValue
        self.physicsBody?.contactTestBitMask = BodyType.player.rawValue
        
        initialPosition = self.position
        
       self.physicsBody?.restitution = 0
        
    }
    
    //v 1.42
    
    func resetPlatform(_ time:TimeInterval){
        
        //self.position = initialPosition
        
        //print(initialPosition)
        
        let move:SKAction = SKAction.move(to: initialPosition, duration: time)
        self.run(move)
        
    }

    
}
