//
//  Portal.swift
//  SideScroller
//
//  Created by Justin Dike 2 on 10/21/15.
//  Copyright © 2015 CartoonSmart. All rights reserved.
//

import Foundation
import SpriteKit


class Enemy: SKSpriteNode {
    
    
    
    var hasProperties:Bool = false
    var spawnNode:String = ""
    var reviveTime:TimeInterval = 0
    var reviveCount:Int = 0
    
    var timesRevived:Int = 0
    
    var speedAfterRevive:CGFloat = 0
    
    var treatLikeBullet:Bool = false
    
    var theSpeed:CGFloat = 0
    
    var atlasName:String = ""
    
    var walkFrames = [String]()
    var angryWalkFrames = [String]()
    var deadFrames = [String]()
    var hurtFrames = [String]()
    var shootFrames = [String]()
    var angryShootFrames = [String]()
    var attackFrames = [String]()
    var angryAttackFrames = [String]()
    
    var angryWalkAction:SKAction?
    var walkAction:SKAction?
    var deadAction:SKAction?
    var hurtAction:SKAction?
    var shootAction:SKAction?
    var angryShootAction:SKAction?
    var attackAction:SKAction?
    var angryAttackAction:SKAction?
    
    var angryWalkFPS:TimeInterval = 30
    var walkFPS:TimeInterval = 10
    var hurtFPS:TimeInterval = 10
    var deadFPS:TimeInterval = 10
    var shootFPS:TimeInterval = 10
    var angryShootFPS:TimeInterval = 20
    var attackFPS:TimeInterval = 10
    var angryAttackFPS:TimeInterval = 20
    
    var jumpOnToKill:Bool = false
    var jumpThreshold:CGFloat = 0
    var jumpOnBounceBack:CGFloat = 500
    
    var isDown:Bool = false
    var isDead:Bool = false
    var blinkToDeath:Bool = false
    var score:Int = 0
    var enemyKillCount:Int = 1
    
    var bodyOffset:CGPoint = CGPoint.zero
    
    var soundEnemyEnter:String = ""
    var soundEnemyHurt:String = ""
    var soundEnemyDie:String = ""
    var soundEnemyAttack:String = ""
    
    var preloadedSoundEnemyEnter:SKAction?
    var preloadedSoundEnemyHurt:SKAction?
    var preloadedSoundEnemyDie:SKAction?
    var preloadedSoundEnemyAttack:SKAction?
    
    var moveUpAndDown:Bool = false
    var moveUpAndDownAmount:CGFloat = 20
    var moveUpAndDownTime:TimeInterval = 0.5
    
    var removeOutsideBoundary:Bool = false
    
    //v1.62 added
    
    var explodeAsBullet:Bool = false // if treat like bullet is true, this will use the deadFrames when the bullet impacts something
    
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    init (image:String, theBodyType:String, theBodyOffset:CGPoint, radiusDivider:CGFloat, bodySize:CGSize ) {
        
        
        let imageTexture = SKTexture(imageNamed: image)
        super.init(texture: imageTexture, color:SKColor.clear, size: imageTexture.size() )
        
        self.texture = imageTexture
        
        var body:SKPhysicsBody = SKPhysicsBody()
        
       
        
        if ( theBodyType == "Alpha"){
        
            body = SKPhysicsBody(texture: imageTexture, alphaThreshold: 0, size: imageTexture.size() )
            
        } else if ( theBodyType == "Circle"){
           
            body = SKPhysicsBody(circleOfRadius: imageTexture.size().width / radiusDivider, center:theBodyOffset )
            
        } else if ( theBodyType == "Rectangle"){
            
            body = SKPhysicsBody(rectangleOf: bodySize, center: theBodyOffset)
            
        }
        
        self.physicsBody = body
        
        self.physicsBody?.categoryBitMask = BodyType.enemy.rawValue
        self.physicsBody?.collisionBitMask = BodyType.player.rawValue | BodyType.platform.rawValue | BodyType.bullet.rawValue  |  BodyType.coin.rawValue | BodyType.enemybumper.rawValue
        
        
      
            
            self.physicsBody?.contactTestBitMask = BodyType.player.rawValue  | BodyType.bullet.rawValue | BodyType.enemybumper.rawValue
            
        
        
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.allowsRotation = false
        
        self.physicsBody?.restitution = 0
        self.physicsBody?.friction = 1
        
        
        
        
        
        
    }
    
    
    func makeAdjustments(){
        
        if ( treatLikeBullet == true){
            
            //adding in platform if treated like bullet
            
            
            
            self.physicsBody?.contactTestBitMask = BodyType.player.rawValue  | BodyType.bullet.rawValue | BodyType.platform.rawValue
            
        }
        
        
    }
    
    
   
    
    func setUpAnimations(){
        
        
       
        
        if (walkFrames.count > 0){
            
            setUpWalkAnimation()
            self.run(walkAction!, withKey: "Walk")
            
        }
        if (deadFrames.count > 0){
            
            setUpDeadAnimation()
            
        }
        if (hurtFrames.count > 0){
            
            setUpHurtAnimation()
            
        }
        if (angryWalkFrames.count > 0){
            
            setUpAngryWalkAnimation()
            
        }
        
        if (shootFrames.count > 0){
            
            setUpShootAnimation()
            
        }
        if (angryShootFrames.count > 0){
            
            setUpAngryShootAnimation()
            
        }
        
        if (attackFrames.count > 0){
            
            setUpAttackAnimation()
            
        }
        if (angryAttackFrames.count > 0){
            
            setUpAngryAttackAnimation()
            
        }
        
        
        if ( moveUpAndDown == true){
            
          
            self.physicsBody?.affectedByGravity = false
            startToMoveUpAndDown()
        }
        
    }
    
    func preloadSounds(){
        
        
        if (soundEnemyAttack != ""){
            
            preloadedSoundEnemyAttack = SKAction.playSoundFileNamed(soundEnemyAttack, waitForCompletion: false)
            
        }
        if (soundEnemyEnter != ""){
            
            preloadedSoundEnemyEnter = SKAction.playSoundFileNamed(soundEnemyEnter, waitForCompletion: false)
            
        }
        if (soundEnemyHurt != ""){
            
            preloadedSoundEnemyHurt = SKAction.playSoundFileNamed(soundEnemyHurt, waitForCompletion: false)
            
        }
        if (soundEnemyDie != ""){
            
            preloadedSoundEnemyDie = SKAction.playSoundFileNamed(soundEnemyDie, waitForCompletion: false)
            
        }
        
        
    }
    
    
    func reverse(){
        
        
        
        if ( self.xScale == 1){
            
            self.xScale = -1
            self.position = CGPoint(x: self.position.x + 2, y: self.position.y )
            
        } else {
            
            self.xScale = 1
            self.position = CGPoint(x: self.position.x - 2, y: self.position.y )
        }
        
        
    }
    
    func update(){
        
        if (self.xScale == 1) {
            
            self.position = CGPoint(x: self.position.x + theSpeed, y: self.position.y )
            
            
        } else {
            
            self.position = CGPoint(x: self.position.x - theSpeed, y: self.position.y )
        }
        

    }
    
    func setUpWalkAnimation() {
        
        let atlas  = SKTextureAtlas(named:atlasName)
        
        var atlasTextures = [SKTexture]()
        
        for name in walkFrames {
            
            let texture:SKTexture = atlas.textureNamed( name )
            atlasTextures.append(texture)
            
        }
        
        let atlasAnimation = SKAction.animate(with: atlasTextures, timePerFrame: 1 / walkFPS, resize:true, restore:false )
        walkAction = SKAction.repeatForever(atlasAnimation)
        
       
        
        
    }
    func setUpAngryWalkAnimation() {
        
        let atlas  = SKTextureAtlas(named:atlasName)
        
        var atlasTextures = [SKTexture]()
        
        for name in angryWalkFrames {
            
            let texture:SKTexture = atlas.textureNamed( name )
            atlasTextures.append(texture)
            
        }
        
        let atlasAnimation = SKAction.animate(with: atlasTextures, timePerFrame: 1 / angryWalkFPS, resize:true, restore:false )
        angryWalkAction = SKAction.repeatForever(atlasAnimation)
        
        
        
        
    }
    
    
    func setUpDeadAnimation() {
        
        let atlas  = SKTextureAtlas(named:atlasName)
        
        var atlasTextures = [SKTexture]()
        
        for name in deadFrames {
            
            let texture:SKTexture = atlas.textureNamed( name )
            atlasTextures.append(texture)
            
        }
        
        deadAction =  SKAction.animate(with: atlasTextures, timePerFrame: 1 / deadFPS, resize:true, restore:false )
        

    }
    
    func setUpHurtAnimation() {
        
        let atlas  = SKTextureAtlas(named:atlasName)
        
        var atlasTextures = [SKTexture]()
        
        for name in hurtFrames {
            
            let texture:SKTexture = atlas.textureNamed( name )
            atlasTextures.append(texture)
            
        }
        
        hurtAction =  SKAction.animate(with: atlasTextures, timePerFrame: 1 / hurtFPS , resize:true, restore:false )
        
        
    }
    
    func setUpShootAnimation() {
        
        let atlas  = SKTextureAtlas(named:atlasName)
        
        var atlasTextures = [SKTexture]()
        
        for name in shootFrames {
            
            let texture:SKTexture = atlas.textureNamed( name )
            atlasTextures.append(texture)
            
        }
        
        
        
        let atlasAnimation = SKAction.animate(with: atlasTextures, timePerFrame: 1 / shootFPS, resize:true, restore:false )
        let run:SKAction = SKAction.run{
            
            if (self.walkAction != nil) {
                    
                    self.run(self.walkAction!, withKey:"Walk")
                    
            }
            
        }
        shootAction = SKAction.sequence( [atlasAnimation, run ] )
        
    }
    func setUpAngryShootAnimation() {
        
        let atlas  = SKTextureAtlas(named:atlasName)
        
        var atlasTextures = [SKTexture]()
        
        for name in angryShootFrames {
            
            let texture:SKTexture = atlas.textureNamed( name )
            atlasTextures.append(texture)
            
        }
        
        
        
        let atlasAnimation = SKAction.animate(with: atlasTextures, timePerFrame: 1 / angryShootFPS, resize:true, restore:false )
        let run:SKAction = SKAction.run{
            
            if (self.angryWalkAction != nil) {
                
                self.run(self.angryWalkAction!, withKey:"Walk")
                
            } else if (self.walkAction != nil) {
                
                self.run(self.walkAction!, withKey:"Walk")
                
            }

            
        }
        angryShootAction = SKAction.sequence( [atlasAnimation, run ] )
        
    }
    
    func setUpAttackAnimation() {
        
        let atlas  = SKTextureAtlas(named:atlasName)
        
        var atlasTextures = [SKTexture]()
        
        for name in attackFrames {
            
            let texture:SKTexture = atlas.textureNamed( name )
            atlasTextures.append(texture)
            
        }
        
        
        
        let atlasAnimation = SKAction.animate(with: atlasTextures, timePerFrame: 1 / attackFPS, resize:true, restore:false )
        let run:SKAction = SKAction.run{
            
            if (self.walkAction != nil) {
                
                self.run(self.walkAction!, withKey:"Walk")
                
            }
            
        }
        attackAction = SKAction.sequence( [atlasAnimation, run ] )
        
    }
    func setUpAngryAttackAnimation() {
        
        let atlas  = SKTextureAtlas(named:atlasName)
        
        var atlasTextures = [SKTexture]()
        
        for name in angryAttackFrames {
            
            let texture:SKTexture = atlas.textureNamed( name )
            atlasTextures.append(texture)
            
        }
        
        
        
        let atlasAnimation = SKAction.animate(with: atlasTextures, timePerFrame: 1 / angryAttackFPS, resize:true, restore:false )
        let run:SKAction = SKAction.run{
            
            if (self.angryWalkAction != nil) {
                
                self.run(self.angryWalkAction!, withKey:"Walk")
                
            } else if (self.walkAction != nil) {
                
                self.run(self.walkAction!, withKey:"Walk")
                
            }
            
            
        }
        angryAttackAction = SKAction.sequence( [atlasAnimation, run ] )
        
    }
    
    
    
    func shot(){
        
        if ( isDown == false && isDead == false) {
        
            isDown = true
            
             self.removeAllActions()
            
            if ( self.moveUpAndDown == true){
                
                self.physicsBody?.affectedByGravity = true
                
            }
            
        
            self.theSpeed = 0
            
            self.physicsBody?.collisionBitMask =  BodyType.platform.rawValue
            self.physicsBody?.contactTestBitMask = 0
        
            if ( reviveCount > 0){
                
                if (timesRevived >= reviveCount){
                
                    //don't revive
                    
                   
                    playSound(soundEnemyDie)
                    
                    isDead = true
                    
                    if ( blinkToDeath == true) {
                        
                        if ( deadAction != nil) {
                        
                            let run:SKAction = SKAction.run {
                                
                                self.blinkOut()
                            }
                            
                            self.run( SKAction.sequence( [deadAction!, run  ] ))
                            
                            
                        } else {
                            
                            blinkOut()
                            
                        }
                        
                       
                        
                    } else {
                        
                        
                        if ( deadAction != nil) {
                            
                            let remove:SKAction = SKAction.removeFromParent()
                            self.run( SKAction.sequence( [deadAction!, remove  ] ))
                            
                        } else {
                            
                            self.removeFromParent()
                        }
                        
                        
                    }
                
                } else {
                    
                    //Not dead, just hurt
                    
                    playSound(soundEnemyHurt)
                    //
                    if ( hurtAction != nil) {
                    
                    self.run(hurtAction!, withKey: "Hurt")
                        
                    }
                    
                    
                    
                    
                    let wait:SKAction = SKAction.wait(forDuration: reviveTime - 1)
                    let wiggleRight:SKAction = SKAction.moveBy(x: -2, y: 0, duration: 1 / 10)
                    let wiggleLeft:SKAction = SKAction.moveBy(x: 2, y: 0, duration: 1 / 10)
                    let seq:SKAction = SKAction.sequence([wiggleRight, wiggleLeft])
                    let repeatSeq:SKAction = SKAction.repeat(seq, count: 5)
                    
                    let run:SKAction = SKAction.run{
                        
                        self.timesRevived += 1
                        self.removeAction(forKey: "Hurt")
                        
                        if ( self.angryWalkAction != nil){
                            
                            self.run(self.angryWalkAction!, withKey:"WalK")
                            
                        }
                        
                        else if ( self.walkAction != nil){
                        
                            self.run(self.walkAction!, withKey:"WalK")
                        
                        }
                        
                        
                        if ( self.moveUpAndDown == true){
                            self.physicsBody?.affectedByGravity = false
                            self.startToMoveUpAndDown()
                        }
                        
                        self.isDown = false
                        self.theSpeed = self.speedAfterRevive
                        self.physicsBody?.collisionBitMask =  BodyType.platform.rawValue | BodyType.player.rawValue | BodyType.bullet.rawValue
                        self.physicsBody?.contactTestBitMask = BodyType.player.rawValue | BodyType.bullet.rawValue
                        
                    }
                    let seq2:SKAction = SKAction.sequence([wait,repeatSeq, run ])
                    
                    self.run(seq2)
                    
                    
                    
                    
                }
            
                
            } else {
                
                
                
                
                isDead = true
                
                playSound(soundEnemyDie)
               
                if ( blinkToDeath == true) {
                    
                    if ( deadAction != nil) {
                    
                        let run:SKAction = SKAction.run {
                            
                            self.blinkOut()
                        }
                        
                        self.run( SKAction.sequence( [deadAction!, run  ] ))
                        
                    } else {
                   
                        blinkOut()
                        
                    }
                    
                } else {
                    
                    if ( deadAction != nil) {
                        
                        let remove:SKAction = SKAction.removeFromParent()
                        self.run( SKAction.sequence( [deadAction!, remove  ] ))
                        
                    } else {
                        
                        self.removeFromParent()
                    }
                    
                }
                
                
            }
        
            
        }
        
    }
    
    //v1.62 added
    func explode() {
        
        // only used if
        if (explodeAsBullet == true && deadAction != nil) {
            
            
            self.physicsBody = nil
            
            let remove:SKAction = SKAction.removeFromParent()
            self.run( SKAction.sequence( [deadAction!, remove  ] ))
            
            
        } else {
            
            self.removeFromParent()
        }
        
    }
    
    
    func blinkOut(){
        
        let hide:SKAction = SKAction.hide()
        let wait:SKAction = SKAction.wait(forDuration: 0.05)
        let unhide:SKAction = SKAction.unhide()
        
        let seq:SKAction = SKAction.sequence( [hide, wait,unhide, wait])
        let repeatAction:SKAction = SKAction.repeat(seq, count: 6)
        let remove:SKAction = SKAction.removeFromParent()
        let seq2:SKAction = SKAction.sequence( [repeatAction, remove] )
        
        self.run(seq2)
        
        
    }
    
    func startToMoveUpAndDown(){
        
        let moveUp:SKAction = SKAction.moveBy(x: 0, y: moveUpAndDownAmount, duration: moveUpAndDownTime)
        let moveDown:SKAction = SKAction.moveBy(x: 0, y: -moveUpAndDownAmount, duration: moveUpAndDownTime)
        let seq:SKAction = SKAction.sequence( [moveUp, moveDown])
        let repeatSeq:SKAction = SKAction.repeatForever(seq)
        self.run(repeatSeq, withKey: "MoveUpAndDown")
        
    }
    
    func playSound(_ theSound:String ){
        
        if (theSound != ""){
            
            if (soundEnemyAttack == theSound){
                
                if (preloadedSoundEnemyAttack != nil){
                    
                    self.run(preloadedSoundEnemyAttack!)
                    
                }
                
                
            }
            else if (soundEnemyEnter == theSound){
                
                if (preloadedSoundEnemyEnter != nil){
                    
                    self.run(preloadedSoundEnemyEnter!)
                    
                }
            }
            else if (soundEnemyHurt == theSound){
                
                if (preloadedSoundEnemyHurt != nil){
                    
                    self.run(preloadedSoundEnemyHurt!)
                    
                }
            }
            else if (soundEnemyDie == theSound){
                
                if ( preloadedSoundEnemyDie != nil){
                    
                    self.run(preloadedSoundEnemyDie!)
                    
                }
                
            } else {
                
                let sound:SKAction = SKAction.playSoundFileNamed(theSound, waitForCompletion: true)
                self.run(sound)
                
            }
            
            
            
            
        }
        
    }
    
    
    func enemyShoot(){
        
       
        
        //called when an enemy is spawned from another enemy
        
        if ( timesRevived >= 1){
            
            if ( angryShootAction != nil){
                
                self.run(angryShootAction! , withKey:"Shoot")
                
            } else if ( shootAction != nil){
                
                self.run(shootAction! , withKey:"Shoot")
                
            }
            
            
        } else {
        
        
            if ( shootAction != nil){
            
                self.run(shootAction! , withKey:"Shoot")
            
            }
            
        }
        
        
    }
    
    
    func attack(){
        
        if ( timesRevived >= 1 && angryAttackFrames.count != 0){
            
            self.run(angryAttackAction! , withKey:"Attack")
            
            print("running angry attack")
            
        } else if (attackFrames.count != 0 ){
            
             self.run(attackAction! , withKey:"Attack")
            
            print(" normal attack")
        }
        
        
    }
    
    
}



