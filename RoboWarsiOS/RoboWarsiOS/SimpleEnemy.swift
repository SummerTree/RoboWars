//
//  Portal.swift
//  SideScroller
//
//  Created by Justin Dike 2 on 10/21/15.
//  Copyright © 2015 CartoonSmart. All rights reserved.
//

import Foundation
import SpriteKit


class SimpleEnemy: SKSpriteNode {
    
    var score:Int = 50
    var enemyKillCount:Int = 1
    var isDead:Bool = false
    var jumpOnBounceBack:CGFloat = 100
    
    
    func setUp(){
        
        self.physicsBody?.categoryBitMask = BodyType.enemy.rawValue
        self.physicsBody?.collisionBitMask = BodyType.player.rawValue | BodyType.platform.rawValue | BodyType.bullet.rawValue
        self.physicsBody?.contactTestBitMask = BodyType.player.rawValue | BodyType.bullet.rawValue

        
        if ( self.name!.range(of: "Enemy") != nil ){
          

            let numberForScore:String = self.name!.replacingOccurrences(of: "Enemy", with: "", options:String.CompareOptions.caseInsensitive , range: nil)
            
            score = Int(numberForScore)!
            
           
            
        }

        
       
    }
    
    
    
    func blinkOut(){
        
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = 0
        
        let hide:SKAction = SKAction.hide()
        let wait:SKAction = SKAction.wait(forDuration: 0.05)
        let unhide:SKAction = SKAction.unhide()
        
        let seq:SKAction = SKAction.sequence( [hide, wait,unhide, wait])
        let repeatAction:SKAction = SKAction.repeat(seq, count: 6)
        let remove:SKAction = SKAction.removeFromParent()
        let seq2:SKAction = SKAction.sequence( [repeatAction, remove] )
        
        self.run(seq2)
        
        
    }
    
}



