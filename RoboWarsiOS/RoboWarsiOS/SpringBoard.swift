//
//  MovingPlatformX.swift
//  SideScroller
//
//  Created by Justin Dike 2 on 10/23/15.
//  Copyright © 2015 CartoonSmart. All rights reserved.
//

import Foundation
import SpriteKit


class SpringBoard: Platform {
    
    var atlasName:String = ""
    var frames = [String]()
    var FPS:TimeInterval = 30
    var boast:CGVector = CGVector(dx: 0, dy: 100)
    var springAnimation:SKAction?
    var bounciness:CGFloat = 1
    var alreadySprung: Bool = false
    
    
    var initialTexture:SKTexture?
    
    func setUpWithDict (_ springDictionary:[String : AnyObject ] ) {
    
        for (theKey, theValue) in springDictionary {
            
            if (theKey == "Frames"){
                
                if (theValue is [String ]){
                    
                    frames = theValue as! [String]
                }
                
            } else if (theKey == "FPS"){
                
                if (theValue is TimeInterval ){
                    
                    FPS = theValue as! TimeInterval
                }
                
            }  else if (theKey == "Atlas"){
                
                if (theValue is String ){
                    
                    atlasName = theValue as! String
                }
                
            } else if (theKey == "Velocity"){
                
                if (theValue is String ){
                    
                    boast =  CGVectorFromString( theValue as! String )
                }
                
            } else if (theKey == "Restitution"){
                
                if (theValue is CGFloat ){
                    
                    
                    bounciness = theValue as! CGFloat
                    
                }
                
            }
        }
        
        
        
        
        
        if ( frames.count > 0) {
            
            
            initialTexture = SKTexture(imageNamed: frames[0] )
            self.texture = initialTexture
            
        
            setUpAnimation()
            
        }
    
    
    }
    
    func spring() {
        
        if (alreadySprung == false) {
            
            alreadySprung = true
        
            self.physicsBody?.restitution = bounciness
        
            if ( springAnimation != nil) {
        
                self.run(springAnimation!)
            
            }
        
        }
        
    }
    
    func setUpAnimation() {
        
        
        
        let atlas  = SKTextureAtlas(named:atlasName)
        
        var atlasTextures = [SKTexture]()
        
        for name in frames {
            
            let texture:SKTexture = atlas.textureNamed( name )
            atlasTextures.append(texture)
            
        }
        
        let animation:SKAction = SKAction.animate(with: atlasTextures, timePerFrame: 1 / FPS, resize:false, restore:true )
        let run:SKAction = SKAction.run{
            
             self.alreadySprung = false
            
            if ( self.initialTexture != nil ) {
                
                self.texture = self.initialTexture
               
            }
        }
        
        springAnimation = SKAction.sequence([animation, run])
        

        
    }
    
    
}
