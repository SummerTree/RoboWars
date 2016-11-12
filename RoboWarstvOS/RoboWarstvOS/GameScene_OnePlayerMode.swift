//
//  GameScene_OnePlayerMode.swift
//  SideScroller
//


import Foundation
import SpriteKit
import GameController

extension GameScene {

    
    func cancelOnePlayerLoops(){
        
        self.removeAction(forKey: "EnemyPlayerShoot")
        self.removeAction(forKey: "EnemyPlayerJump")
        self.removeAction(forKey: "EnemyPlayerWalk")
        self.removeAction(forKey: "EnemyPlayerStop")
    }
    

    func setUpLoopsForOnePlayerMode(){
        
       
            
            shootLoopOnePlayerMode()
            jumpLoopOnePlayerMode()
            walkLoopOnePlayerMode()
            stopLoopOnePlayerMode()
        
    }
    
    func stopLoopOnePlayerMode(){
        
        
        
        let randTime:UInt32 = arc4random_uniform(4) + 1
        
        let wait:SKAction = SKAction.wait( forDuration: TimeInterval( randTime ) )
        let run:SKAction = SKAction.run{
            
                
            self.gcLiftUpDPadWithPlayer(self.enemyPlayerInOnePlayerMode!);
            self.stopLoopOnePlayerMode();
            
        }
        let seq:SKAction = SKAction.sequence([wait, run])
        
        self.run(seq, withKey:"EnemyPlayerStop" )
        
        
        
    }
    func walkLoopOnePlayerMode(){
        
        
        
        let randTime:UInt32 = arc4random_uniform(4) + 1
        
        let wait:SKAction = SKAction.wait( forDuration: TimeInterval( randTime ) )
        let run:SKAction = SKAction.run{
            
            if ( self.playerVersusPlayer == true) {
            
                //opposing player is always facing the opponent in player versus player
            
                if ( self.enemyPlayerInOnePlayerMode?.xScale == 1 ){
                
                    self.enemyPlayerInOnePlayerMode?.goRight()
                
                } else {
                
                    self.enemyPlayerInOnePlayerMode?.goLeft()
                }
            
                
            } else {
                
                let dice:UInt32 = arc4random_uniform(2)
                
                if ( dice == 0 ){
                    
                    self.enemyPlayerInOnePlayerMode?.xScale = 1
                    self.enemyPlayerInOnePlayerMode?.goRight()
                    
                    
                } else {
                    
                    self.enemyPlayerInOnePlayerMode?.xScale = -1
                    self.enemyPlayerInOnePlayerMode?.goLeft()
                }
                
            }
            
            
            
            self.walkLoopOnePlayerMode();
            
        }
        let seq:SKAction = SKAction.sequence([wait, run])
        
        self.run(seq, withKey:"EnemyPlayerWalk" )
        
        
        
    }
    
    
    func jumpLoopOnePlayerMode(){
        
        
        
        let randTime:UInt32 = arc4random_uniform(4) + 1
        
        let wait:SKAction = SKAction.wait( forDuration: TimeInterval( randTime ) )
        let run:SKAction = SKAction.run{
            
            self.enemyPlayerInOnePlayerMode?.jump()
            self.jumpLoopOnePlayerMode();
            
        }
        let seq:SKAction = SKAction.sequence([wait, run])
        
        self.run(seq, withKey:"EnemyPlayerJump" )
        
        
        
    }
    
    
    func shootLoopOnePlayerMode(){
        
        
        
        let randTime:UInt32 = arc4random_uniform(2) + 1
        
        let wait:SKAction = SKAction.wait( forDuration: TimeInterval( randTime ) )
        let run:SKAction = SKAction.run{
            
            self.shootInOnePlayerMode();
            self.shootLoopOnePlayerMode();
            
        }
        let seq:SKAction = SKAction.sequence([wait, run])
        
        self.run(seq, withKey:"EnemyPlayerShoot" )
        
        
        
    }
    
    
    func shootInOnePlayerMode() {
        
        if ( enemyPlayerInOnePlayerMode != nil) {
            
            shoot(enemyPlayerInOnePlayerMode!)
            
        }
        
        
    }
   
    
    
    
    
    
    func showControllerLabel(){
        
        self.connectController.position = self.controllerLocation
        self.connectController.isHidden = false
       
    }
    func hideControllerLabel(){
        
        self.connectController.isHidden = true
        
    }
    
   
    

}
