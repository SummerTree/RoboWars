//
//  GameScene_Touches.swift
//  SideScrolleriOS
//
//  Created by Justin Dike 2 on 12/4/15.
//  Copyright © 2015 CartoonSmart. All rights reserved.
//

import Foundation
import SpriteKit


extension GameScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        
        
        
        for touch in (touches ) {
            let location = touch.location(in: self)
            
            let convertedLocation:CGPoint = self.convert(location, to: theCamera)
            
            
            if ( self.isPaused == true){
                
                if (resumeGame!.frame.contains(convertedLocation)) {
                    
                   
                        unpauseScene()
                    
                    
                } else if (mainMenu!.frame.contains(convertedLocation)) {
                    
                    
                    goBackToMainMenu()
                    
                    
                } else if (pauseButton.frame.contains(convertedLocation)) {
                    
                   
                        
                        unpauseScene()
                    
                    
                }
                
                
                
            } else {
            
            //scene is not paused
            
            if (pauseButton.frame.contains(convertedLocation)) {
                
                if ( self.isPaused == false){
                    
                    pauseScene()
                    
                } else {
                    
                    unpauseScene()
                }
                
            }
            
            else if (button1.frame.contains(convertedLocation)) {
                
                thePlayer.xHeldDown = true
                
                self.pressedShoot(thePlayer)
                
                button1.alpha = 0.3
                
            } else if (button2.frame.contains(convertedLocation)) {
                
                button2.alpha = 0.3
                
                self.pressedJump ( thePlayer )
                
            } else if (convertedLocation.x < 0 ) {
                
                //location is left of camera
                
                stickActive = true
                
               
                
                ball.alpha = 0.4
                base.alpha = 0.4
                
                base.position = convertedLocation
                ball.position = convertedLocation
                
            } else {
                
                stickActive = false
                
                
            }
                
            }
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in (touches ) {
            let location = touch.location(in: self)
            
            let convertedLocation:CGPoint = self.convert(location, to: theCamera)
            
            //v1.3
            if ( self.isPaused == true && convertedLocation.x < 0) {
                
                stopMusicByGoingLeft()
                
                
                
            } else if ( self.isPaused == true && convertedLocation.x > 0) {
                
                nextTrackByGoingRight()
                
                
                
            }
            else if (convertedLocation.x < 0 && self.isPaused == false) {
                //checks that x was on the left side of the screen
                
                
                let v = CGVector(dx: convertedLocation.x - base.position.x, dy:  convertedLocation.y - base.position.y)
                let angle = atan2(v.dy, v.dx)
                
               
                //println( deg + 180 )
                
                
                
                
                let length:CGFloat = base.frame.size.height / 2
                
                //let length:CGFloat = 40
                
                let xDist:CGFloat = sin(angle - 1.57079633) * length
                let yDist:CGFloat = cos(angle - 1.57079633) * length
                
                
                if (base.frame.contains(convertedLocation)) {
                    
                    ball.position = convertedLocation
                    
                } else {
                    
                    ball.position = CGPoint( x: base.position.x - xDist, y: base.position.y + yDist)
                    
                }
                
                
                
                if ( thePlayer.onPole == false ){
                
                    if ( xDist < 0) {
                        
                        
                            
                            gcRightWithPlayer(thePlayer)
                      
                        
                        
                    } else {
                        
                       
                        
                            gcLeftWithPlayer(thePlayer)
                      
                    }
                    
                } else {
                    
                    
                    if ( abs(yDist) > abs(xDist) ){
                        
                        //go up or down
                        if ( yDist > 0) {
                            
                            gcUpWithPlayer(thePlayer)
                            
                        } else {
                            
                            gcDownWithPlayer(thePlayer)
                        }
                        
                        
                    } else {
                        
                        if ( xDist < 0) {
                            
                           
                                
                                gcRightWithPlayer(thePlayer)
                                
                           
                            
                        } else {
                            
                            
                                
                                gcLeftWithPlayer(thePlayer)
                                
                            
                        }
                        
                    }
                    
                   
                
                
                }
               
                
                
            } // ends stickActive test
            
            
            
        }
        
        
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        thePlayer.xHeldDown = false
        
         justStartedNewTrack = false
        
        resetJoyStick()
        
         button1.alpha = 0.1
         button2.alpha = 0.1
        
        if (stickActive == true) {
            
            // let go for joystick
            
           self.gcLiftUpDPadWithPlayer(thePlayer)
            
        } else if (stickActive == false) {
            
            //assumes let go of a button
            
            
            
        }
        
    }
    
    
    
    
    
    func resetJoyStick(){
        
        
        
        let move:SKAction = SKAction.move(to: base.position, duration: 0.2)
        move.timingMode = .easeOut
        
        ball.run(move)
        
        
        let fade:SKAction = SKAction.fadeAlpha(to: 0, duration: 0.3)
        
        ball.run(fade)
        base.run(fade)
        
        
        
        
    }




}
