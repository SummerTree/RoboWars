//
//  Bullet.swift
//  SideScroller
//
//  Created by Justin Dike 2 on 10/28/15.
//  Copyright © 2015 CartoonSmart. All rights reserved.
//

import Foundation
import SpriteKit

class Bullet:SKSpriteNode {
    
    var explodeAction:SKAction?
    var isExploding:Bool = false
    
    var soundBulletImpact:String = ""
    
    var theSpeed:CGFloat = 10
    
    var weaponRotationSpeed:Float = 0
    
    var image:String = "bullet"
    
    var whoFired:String = "Player1"
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
   
    init () {
        
        
        let imageTexture = SKTexture(imageNamed: image)
        super.init(texture: imageTexture, color:SKColor.clear, size: imageTexture.size() )
        
        
    }
    
    func setUpBulletWithName(_ weaponName:String){
        
        
        let imageTexture = SKTexture(imageNamed: weaponName)
        
       self.size = imageTexture.size()
        
        self.texture = imageTexture
        let body:SKPhysicsBody = SKPhysicsBody(texture: imageTexture, alphaThreshold: 0, size: imageTexture.size() )
        
        self.physicsBody = body
        
        body.isDynamic = true
        body.affectedByGravity = false
        body.allowsRotation = true
        
        body.restitution = 0
        
        self.zPosition = 99
        
        body.categoryBitMask = BodyType.bullet.rawValue
        body.collisionBitMask = BodyType.platform.rawValue  | BodyType.player.rawValue |  BodyType.deadZone.rawValue
        body.contactTestBitMask =  BodyType.platform.rawValue  | BodyType.player.rawValue | BodyType.bullet.rawValue 
        
       
        setUpExplodeAnimation()
        
        
        if ( weaponRotationSpeed != 0){
            
            let rotate:SKAction = SKAction.rotate(byAngle: 360, duration: TimeInterval(weaponRotationSpeed) )
            let repeatRotate:SKAction = SKAction.repeatForever(rotate)
            self.run(repeatRotate, withKey: "Rotate")
            
        }
        
        
        
    }
    

    
   
    func explode(){
        
        if ( isExploding == false) {
            
            self.physicsBody = nil
            self.zPosition = 3000
            self.removeAction(forKey: "Rotate")
            
            isExploding = true
            
            theSpeed = 0
            
            playSound(soundBulletImpact)
            
            self.run(explodeAction!)
            
        }
       
        
    }
    
    
    
    func update() {
        
        
        
            if (self.xScale == 1) {
            
                self.position = CGPoint(x: self.position.x + theSpeed, y: self.position.y )
            
            
            } else {
            
                self.position = CGPoint(x: self.position.x - theSpeed, y: self.position.y )
            }
        
       
        
    }
    
    
    func setUpExplodeAnimation() {
        
        let atlas  = SKTextureAtlas(named:"Explode")
        
        var array = [String]()
        
        
        for i in 1...8 {
            
            let nameString = String(format: "Explode%i", i)
            array.append(nameString)
            
        }
        
        var atlasTextures = [SKTexture]()
        
        for k in 0 ..< array.count  {
            
            let texture:SKTexture = atlas.textureNamed( array[k] )
            
            //let texture:SKTexture = SKTexture(imageNamed: array[k])  //if not using the .atlas folder
            atlasTextures.append(texture)
            
        }
        
        let atlasAnimation:SKAction =  SKAction.animate(with: atlasTextures, timePerFrame: 1/20, resize:true, restore:false )
        let run:SKAction = SKAction.run{
            
            self.removeFromParent();
        }
        
        explodeAction = SKAction.sequence( [ atlasAnimation, run] )
        
    }

    func playSound(_ theSound:String ){
        
        if (theSound != ""){
        
            let sound:SKAction = SKAction.playSoundFileNamed(theSound, waitForCompletion: true)
            self.run(sound)
            
        }
        
    }
    
}







