//
//  Portal.swift
//  SideScroller
//
//  Created by Justin Dike 2 on 10/21/15.
//  Copyright © 2015 CartoonSmart. All rights reserved.
//

import Foundation
import SpriteKit


class Ammo: SKSpriteNode {
    
    var initialPosition:CGPoint = CGPoint.zero
    var canAward:Bool = true
    var awardsHowMuch:Int = 10
    var spawnsHowOften:UInt32 = 30
    var spawnsAtRandomTime:Bool = false
    var minimumTimeBetweenSpawns:TimeInterval = 5
    var awardsToBothPlayers:Bool = false
    var onlyAllowOneAtATime:Bool = false
    var soundAmmoCollect:String = ""
    var soundAmmoDrop:String = ""
    
   
    
    func setUp() {
        
        self.alpha = 0
        canAward = false
        
        initialPosition = self.position
        

        self.physicsBody?.categoryBitMask = BodyType.ammo.rawValue
        self.physicsBody?.collisionBitMask = BodyType.platform.rawValue | BodyType.deadZone.rawValue | BodyType.player.rawValue
        self.physicsBody?.contactTestBitMask = BodyType.player.rawValue
        
        
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        
        
        drop()
        
    }
    
    func pickedUp() {
        
        
        playSound(soundAmmoCollect)
        
        
        
        canAward = false
        
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        
        
        
        self.alpha = 0
        
        
        waitToDrop()
        
        if ( onlyAllowOneAtATime == true ) {
            
            if let scene:GameScene = self.parent as? GameScene {
                
                if ( self.name == "Player1Ammo") {
                    
                    scene.hasPlayer1AmmoAlready = false
                }
                if ( self.name == "Player2Ammo") {
                    
                    scene.hasPlayer2AmmoAlready = false
                }
            }
            
        }
        
                        
                      
        
        
    }
    
    func waitToDrop(){
        
        var refreshRandom:UInt32 = 0
        
        var refreshTime:TimeInterval = 0
        
        if ( spawnsAtRandomTime == true ) {
            
            refreshRandom = arc4random_uniform(spawnsHowOften)
            
            refreshTime = TimeInterval(refreshRandom) + minimumTimeBetweenSpawns
            
        } else {
            
            refreshTime = TimeInterval(spawnsHowOften) + minimumTimeBetweenSpawns
            
        }
        
        
        
        
        
        let move:SKAction = SKAction.move(to: initialPosition, duration: 0)
        self.run(move)
        
        
        let wait:SKAction = SKAction.wait(forDuration: refreshTime)
        let run:SKAction = SKAction.run{
            
            self.drop()
        }
        
        let seq:SKAction = SKAction.sequence( [wait, run ])
        self.run(seq)
    }
    
    
    func drop() {
        
        
         if ( onlyAllowOneAtATime == true ) {
        
            if let scene:GameScene = self.parent as? GameScene {
            
 
                if ( self.name == "Player1Ammo") {
            
                    if (scene.hasPlayer1AmmoAlready == true){
                
                        waitToDrop()
                
                    } else {
                
                        scene.hasPlayer1AmmoAlready = true
                        canAward = true
                
                        self.alpha = 1
                        self.physicsBody?.isDynamic = true
                        self.physicsBody?.affectedByGravity = true
                        self.physicsBody?.allowsRotation = true
                        
                         playSound(soundAmmoDrop)
                
                    }
            
                } else if ( self.name == "Player2Ammo") {
                    
                    if (scene.hasPlayer2AmmoAlready == true){
                        
                        waitToDrop()
                        
                    } else {
                        
                        scene.hasPlayer2AmmoAlready = true
                        canAward = true
                        
                        self.alpha = 1
                        self.physicsBody?.isDynamic = true
                        self.physicsBody?.affectedByGravity = true
                        self.physicsBody?.allowsRotation = true
                        
                        playSound(soundAmmoDrop)
                        
                    }
                    
                }
                
            }
            
            
            
         } else {
            
            
            canAward = true
            
            self.alpha = 1
            self.physicsBody?.isDynamic = true
            self.physicsBody?.affectedByGravity = true
            self.physicsBody?.allowsRotation = true
            
        }
        
        
        
        
        
    }
    
    func playSound(_ theSound:String ){
        
        if (theSound != ""){
        
            let sound:SKAction = SKAction.playSoundFileNamed(theSound, waitForCompletion: true)
            self.run(sound)
            
        }
        
    }
    
    
}
