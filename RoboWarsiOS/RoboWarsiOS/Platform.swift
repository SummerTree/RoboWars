//
//  Platform.swift
//  SideScroller
//
//  Created by Justin Dike 2 on 10/20/15.
//  Copyright © 2015 CartoonSmart. All rights reserved.
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
        
        self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        self.physicsBody?.angularVelocity = 0
        
        let move:SKAction = SKAction.move(to: initialPosition, duration: time)
        self.run(move)
        
    }
    
}
