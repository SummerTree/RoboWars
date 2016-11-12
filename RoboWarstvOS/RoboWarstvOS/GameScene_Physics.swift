//
//  GameScene_Physics.swift
//  SideScrollertvOS
//


import Foundation
import SpriteKit
import GameController

extension GameScene {

    func playerWithPlatform(_ playerNode:Player, platformNode:Platform) {
        
        playerNode.playSound(playerNode.soundLand)
        
        
        if ( playerNode == thePlayer){
            
            if let theMovingPlatform = platformNode as? MovingPlatform {
                
                currentMovingPlatform = theMovingPlatform
                playerNode.stopJump()
                
            } else if let theSpringBoard:SpringBoard = platformNode as? SpringBoard {
                
                theSpringBoard.spring()
                playerNode.physicsBody?.applyImpulse( theSpringBoard.boast)
            }
                
            else {
                
                playerNode.stopJumpFromPlatformContact()
            }
            
        } else if ( playerNode == thePlayer2){
            
            if let theMovingPlatform = platformNode as? MovingPlatform {
                
                currentMovingPlatform2 = theMovingPlatform
                playerNode.stopJump()
                
            } else if let theSpringBoard:SpringBoard = platformNode as? SpringBoard {
                
                theSpringBoard.spring()
                playerNode.physicsBody?.applyImpulse( theSpringBoard.boast)
                
            }
                
            else {
                
                playerNode.stopJumpFromPlatformContact()
            }
            
        }
        
        
    }
    
    
    @objc(didBeginContact:) func didBegin(_ contact: SKPhysicsContact) {
        
        
        //MARK:  PLAYER with PLATFORM
        
        if ( contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.platform.rawValue){
            
            
            if let somePlayer:Player = contact.bodyA.node as? Player{
                
                
                
                playerWithPlatform(somePlayer, platformNode:contact.bodyB.node as! Platform)
                
                
                
            }
            
            
            
            
            
            
            
        } else if ( contact.bodyA.categoryBitMask == BodyType.platform.rawValue && contact.bodyB.categoryBitMask == BodyType.player.rawValue){
            
            
            if let somePlayer:Player = contact.bodyB.node as? Player{
                
                playerWithPlatform(somePlayer, platformNode:contact.bodyA.node as! Platform)
                
            }
            
            
        }
        
        
        //MARK:  PLAYER with POLE
        
        
        if ( contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.pole.rawValue){
            
            if let somePlayer:Player = contact.bodyA.node as? Player{
                
                if (somePlayer == thePlayer){
                    
                    thePlayer.onPole = true
                    
                    if let theMovingPole = contact.bodyB.node as? MovingPole {
                        
                        currentMovingPole = theMovingPole
                    }
                    
                } else if (somePlayer == thePlayer2){
                    
                    thePlayer2.onPole = true
                    
                    if let theMovingPole = contact.bodyB.node as? MovingPole {
                        
                        currentMovingPole2 = theMovingPole
                    }
                    
                }
                
            }
            
            
            
            
            
            
            
            
        } else if ( contact.bodyA.categoryBitMask == BodyType.pole.rawValue && contact.bodyB.categoryBitMask == BodyType.player.rawValue){
            
            if let somePlayer:Player = contact.bodyB.node as? Player{
                
                if (somePlayer == thePlayer){
                    
                    thePlayer.onPole = true
                    
                    if let theMovingPole = contact.bodyA.node as? MovingPole {
                        
                        currentMovingPole = theMovingPole
                    }
                    
                } else if (somePlayer == thePlayer2){
                    
                    thePlayer2.onPole = true
                    
                    if let theMovingPole = contact.bodyA.node as? MovingPole {
                        
                        currentMovingPole2 = theMovingPole
                    }
                    
                }
                
            }
            
            
        }
        
        //MARK:  PLAYER with PORTAL
        
        
        if ( contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.portal.rawValue){
            
            //v1.4
            
            if let somePortal:Portal = contact.bodyB.node as? Portal{
                
                if ( somePortal.goesToSpecificLevel == false && somePortal.movesPlayerToNode == false  ){
                    
                    levelsPassed = levelsPassed + 1
                    
                    loadAnotherLevel ( currentLevel + 1, transitionImage: "LevelPassed" )
                    
                } else {
                    
                    if let somePlayer:Player = contact.bodyA.node as? Player{
                    
                        handleContactWithCustomPortal(somePortal, thePlayerEnteringPortal:somePlayer)
                        
                    }
                    
                    
                    
                    
                }

                
            }
            
            
            
            
            
        } else if ( contact.bodyA.categoryBitMask == BodyType.portal.rawValue && contact.bodyB.categoryBitMask == BodyType.player.rawValue){
            
            //v1.4
            
            if let somePortal:Portal = contact.bodyA.node as? Portal{
                
                if ( somePortal.goesToSpecificLevel == false && somePortal.movesPlayerToNode == false){
                    
                    levelsPassed = levelsPassed + 1
                    
                    loadAnotherLevel ( currentLevel + 1, transitionImage: "LevelPassed" )
                    
                } else {
                    
                    if let somePlayer:Player = contact.bodyB.node as? Player{
                        
                        handleContactWithCustomPortal(somePortal, thePlayerEnteringPortal:somePlayer)
                        
                    }
                    
                }
                
                
            }
            
            
            
        }
        
        //MARK:  PLAYER with DEADZOne
        
        
        if ( contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.deadZone.rawValue){
            
            
            if let somePlayer:Player = contact.bodyA.node as? Player{
                
                killPlayer(somePlayer)
                
            }
            
            
            
            
        } else if ( contact.bodyA.categoryBitMask == BodyType.deadZone.rawValue && contact.bodyB.categoryBitMask == BodyType.player.rawValue){
            
            
            if let somePlayer:Player = contact.bodyB.node as? Player{
                
                killPlayer(somePlayer)
                
            }
            
            
            
        }
        
        
        
        //MARK: PLAYER with PLAYER
        
        
        if ( contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.player.rawValue){
            
            
            if (thePlayer.position.y > thePlayer2.position.y + playerOnPlayerBounceThreshold) {
                
                thePlayer.stopJump()
                
                if (thePlayer2.onPole == false){
                    
                    
                    if ( stealHearts == true){
                        
                        if (heartsPlayer2 > 1 && heartsPlayer1 < 4){
                            
                            addLife( thePlayer )
                            stealLife( thePlayer2 )
                            
                        }
                    }
                    
                    if ( (thePlayer.physicsBody?.velocity.dy)! <= 0.0){
                        
                        //bump player 1 upward if going down
                        
                        thePlayer.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                        thePlayer.physicsBody?.applyImpulse(CGVector(dx: 0, dy: playerOnPlayerImpact))
                        
                        thePlayer.playSound(thePlayer.soundBounce)
                        
                    }
                    
                    //bump player 2 left or right
                    
                    if (thePlayer.position.x < thePlayer2.position.x){
                        
                        thePlayer2.physicsBody?.applyImpulse(CGVector(dx: playerOnPlayerImpact, dy: 0))
                    } else {
                        
                        thePlayer2.physicsBody?.applyImpulse(CGVector(dx: -playerOnPlayerImpact, dy: 0))
                    }
                    
                }
                
                
            } else if (thePlayer2.position.y > thePlayer.position.y + playerOnPlayerBounceThreshold) {
                
                thePlayer2.stopJump()
                
                if (thePlayer.onPole == false){
                    
                    if ( stealHearts == true){
                        
                        if (heartsPlayer1 > 1 && heartsPlayer2 < 4 ){
                            
                            addLife( thePlayer2 )
                            stealLife( thePlayer )
                            
                        }
                    }
                    
                    if ( (thePlayer2.physicsBody?.velocity.dy)! <= 0.0){
                        
                        //bump player 2 upward if going down
                        
                        thePlayer2.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                        thePlayer2.physicsBody?.applyImpulse(CGVector(dx: 0, dy: playerOnPlayerImpact))
                        
                        thePlayer2.playSound(thePlayer2.soundBounce)
                    }
                    
                    //bump player 1 left or right
                    
                    if (thePlayer2.position.x < thePlayer.position.x){
                        
                        thePlayer.physicsBody?.applyImpulse(CGVector(dx: playerOnPlayerImpact, dy: 0))
                    } else {
                        
                        thePlayer.physicsBody?.applyImpulse(CGVector(dx: -playerOnPlayerImpact, dy: 0))
                    }
                    
                }
                
            }
            
            
        }
        
        
        
        //MARK:  PLAYER with Enemy
        
        
        if ( contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.enemy.rawValue){
            
            
            
            
            
            if let somePlayer:Player = contact.bodyA.node as? Player{
                
                
                if let someEnemy:Enemy = contact.bodyB.node as? Enemy{
                    
                    handleContactWithPlayerAndEnemy(somePlayer, someEnemy: someEnemy, contactPoint: contact.contactPoint)
                    
                } else if let someEnemy:SimpleEnemy = contact.bodyB.node as? SimpleEnemy{
                    
                  
                    
                    handleContactWithPlayerAndSimpleEnemy(somePlayer, someEnemy: someEnemy, contactPoint: contact.contactPoint)
                    
                }
                
            }
            
            
            
            
        } else if ( contact.bodyA.categoryBitMask == BodyType.enemy.rawValue && contact.bodyB.categoryBitMask == BodyType.player.rawValue){
            
            
            
            if let somePlayer:Player = contact.bodyB.node as? Player{
                
                
                if let someEnemy:Enemy = contact.bodyA.node as? Enemy{
                    
                    handleContactWithPlayerAndEnemy(somePlayer, someEnemy: someEnemy, contactPoint: contact.contactPoint)
                    
                    
                } else if let someEnemy:SimpleEnemy = contact.bodyA.node as? SimpleEnemy{
                    
                    
                    
                    handleContactWithPlayerAndSimpleEnemy(somePlayer, someEnemy: someEnemy, contactPoint: contact.contactPoint)
                    
                }
                
                
            }
            
            
            
        }
        
        //MARK:  Bullet with Enemy
        
        
        
        if ( contact.bodyA.categoryBitMask == BodyType.bullet.rawValue && contact.bodyB.categoryBitMask == BodyType.enemy.rawValue){
            
            
            if let someBullet:Bullet = contact.bodyA.node as? Bullet {
                
                
                someBullet.explode()
                someBullet.position = contact.contactPoint
                
                if let someEnemy:Enemy = contact.bodyB.node as? Enemy {
                    
                    someEnemy.shot()
                    
                    if (someEnemy.isDead == true){
                        
                        addToScore(someBullet.whoFired, amount: someEnemy.score)
                        someEnemy.score = 0
                        
                        addToEnemyKillCount(someEnemy.enemyKillCount)
                        someEnemy.enemyKillCount = 0
                        
                    }
                    
                } else if let someEnemy:SimpleEnemy = contact.bodyB.node as? SimpleEnemy {
                    
                    
                    
                    if (someEnemy.isDead == false){
                        
                        someEnemy.isDead = true
                        
                        addToScore(someBullet.whoFired, amount: someEnemy.score)
                        someEnemy.score = 0
                        
                        addToEnemyKillCount(someEnemy.enemyKillCount)
                        someEnemy.enemyKillCount = 0
                        
                        someEnemy.blinkOut()
                        
                    }
                    
                }
                
                
                
                
            }
            
            
        } else if ( contact.bodyA.categoryBitMask == BodyType.enemy.rawValue && contact.bodyB.categoryBitMask == BodyType.bullet.rawValue){
            
            if let someBullet:Bullet = contact.bodyB.node as? Bullet {
                
                
                someBullet.explode()
                someBullet.position = contact.contactPoint
                
                if let someEnemy:Enemy = contact.bodyA.node as? Enemy {
                    
                    someEnemy.shot()
                    
                    if (someEnemy.isDead == true){
                        
                        addToScore(someBullet.whoFired, amount: someEnemy.score)
                        someEnemy.score = 0
                        
                        addToEnemyKillCount(someEnemy.enemyKillCount)
                        someEnemy.enemyKillCount = 0
                    }
                    
                } else if let someEnemy:SimpleEnemy = contact.bodyA.node as? SimpleEnemy {
                    
                    if (someEnemy.isDead == false){
                        
                        someEnemy.isDead = true
                        
                        addToScore(someBullet.whoFired, amount: someEnemy.score)
                        someEnemy.score = 0
                        
                        addToEnemyKillCount(someEnemy.enemyKillCount)
                        someEnemy.enemyKillCount = 0
                        
                        someEnemy.blinkOut()
                        
                    }
                }
                
                
            }
            
        }
        
        
        
        
        //MARK: Player with Bullet
        
        
        if ( contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.bullet.rawValue){
            
            if let somePlayer:Player = contact.bodyA.node as? Player{
                
                if let someBullet:Bullet = contact.bodyB.node as? Bullet {
                    
                    someBullet.explode()
                    someBullet.position = contact.contactPoint
                    
                    if (playerVersusPlayer == false) {
                        
                        if ( someBullet.xScale == 1){
                            
                            somePlayer.physicsBody?.applyImpulse(CGVector(dx: someBullet.theSpeed * 3,  dy: 0))
                            
                        } else {
                            
                            somePlayer.physicsBody?.applyImpulse(CGVector(dx: someBullet.theSpeed * -3, dy: 0))
                        }
                        
                        
                    } else if (playerVersusPlayer == true) {
                        
                        killPlayer(somePlayer)
                        
                    }
                    
                }
                
                
                
            }
            
            
        } else if ( contact.bodyA.categoryBitMask == BodyType.bullet.rawValue && contact.bodyB.categoryBitMask == BodyType.player.rawValue){
            
            
            if let somePlayer:Player = contact.bodyB.node as? Player{
                
                if let someBullet:Bullet = contact.bodyA.node as? Bullet {
                    
                    someBullet.explode()
                    someBullet.position = contact.contactPoint
                    
                    if (playerVersusPlayer == false) {
                        
                        
                        if ( someBullet.xScale == 1){
                            
                            somePlayer.physicsBody?.applyImpulse(CGVector(dx: someBullet.theSpeed * 3, dy: 0))
                            
                        } else {
                            
                            somePlayer.physicsBody?.applyImpulse(CGVector(dx: someBullet.theSpeed * -3, dy: 0))
                        }
                        
                    } else  if (playerVersusPlayer == true) {
                        
                        killPlayer(somePlayer)
                        
                        
                    }
                    
                }
                
            }
            
        }
        
        //MARK: Bullet with Bullet
        
        
        if ( contact.bodyA.categoryBitMask == BodyType.bullet.rawValue && contact.bodyB.categoryBitMask == BodyType.bullet.rawValue){
            
            if let someBullet2:Bullet = contact.bodyA.node as? Bullet{
                
                if let someBullet:Bullet = contact.bodyB.node as? Bullet {
                    
                    someBullet.explode()
                    someBullet2.explode()
                    someBullet.position = contact.contactPoint
                    someBullet2.position = contact.contactPoint
                    
                }
                
                
            }
            
            
        }
        
        //MARK:  Enemy with Platform (only applies to enemies treated like bullets)
        
        
        if ( contact.bodyA.categoryBitMask == BodyType.enemy.rawValue && contact.bodyB.categoryBitMask == BodyType.platform.rawValue){
            
            if let someEnemy:Enemy = contact.bodyA.node as? Enemy{
                
                if ( someEnemy.treatLikeBullet == true){
                    
                    someEnemy.removeFromParent()
                }
                
                
            }
            
            
            
        } else if ( contact.bodyA.categoryBitMask == BodyType.platform.rawValue && contact.bodyB.categoryBitMask == BodyType.enemy.rawValue){
            
            
            
            if let someEnemy:Enemy = contact.bodyB.node as? Enemy{
                
                if ( someEnemy.treatLikeBullet == true){
                    
                    someEnemy.removeFromParent()
                }
                
                
            }
            
            
            
        }
        
        
        
        
        //MARK:  Bullet with Platform
        
        
        if ( contact.bodyA.categoryBitMask == BodyType.bullet.rawValue && contact.bodyB.categoryBitMask == BodyType.platform.rawValue){
            
            if let someBullet:Bullet = contact.bodyA.node as? Bullet{
                
                someBullet.explode()
                someBullet.position = contact.contactPoint
            }
            
            
            
        } else if ( contact.bodyA.categoryBitMask == BodyType.platform.rawValue && contact.bodyB.categoryBitMask == BodyType.bullet.rawValue){
            
            
            
            if let someBullet:Bullet = contact.bodyB.node as? Bullet{
                
                someBullet.explode()
                someBullet.position = contact.contactPoint
            }
            
            
            
        }
        //MARK:  Bullet with Bumper
        
        
        if ( contact.bodyA.categoryBitMask == BodyType.bullet.rawValue && contact.bodyB.categoryBitMask == BodyType.bumper.rawValue){
            
            if let someBullet:Bullet = contact.bodyA.node as? Bullet{
                
                someBullet.explode()
                someBullet.position = contact.contactPoint
            }
            
            
            
        } else if ( contact.bodyA.categoryBitMask == BodyType.bumper.rawValue && contact.bodyB.categoryBitMask == BodyType.bullet.rawValue){
            
            
            
            if let someBullet:Bullet = contact.bodyB.node as? Bullet{
                
                someBullet.explode()
                someBullet.position = contact.contactPoint
            }
            
            
            
        }
        //MARK:  Player with Bumper
        
        
        if ( contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.bumper.rawValue){
            
            if let somePlayer:Player = contact.bodyA.node as? Player{
                
                somePlayer.stopJump()
            }
            
            
            
        } else if ( contact.bodyA.categoryBitMask == BodyType.bumper.rawValue && contact.bodyB.categoryBitMask == BodyType.player.rawValue){
            
            
            
            if let somePlayer:Player = contact.bodyB.node as? Player{
                
                somePlayer.stopJump()
            }
            
            
        }
        
        
        //MARK:  Bullet with DeadZone
        
        
        if ( contact.bodyA.categoryBitMask == BodyType.bullet.rawValue && contact.bodyB.categoryBitMask == BodyType.deadZone.rawValue){
            
            if let someBullet:Bullet = contact.bodyA.node as? Bullet{
                
                someBullet.explode()
                someBullet.position = contact.contactPoint
            }
            
            
            
        } else if ( contact.bodyA.categoryBitMask == BodyType.deadZone.rawValue && contact.bodyB.categoryBitMask == BodyType.bullet.rawValue){
            
            
            
            if let someBullet:Bullet = contact.bodyB.node as? Bullet{
                
                someBullet.explode()
                someBullet.position = contact.contactPoint
            }
            
            
            
        }
        
        //MARK:  bumper with enemy
        
        
        if ( contact.bodyA.categoryBitMask == BodyType.enemy.rawValue && contact.bodyB.categoryBitMask == BodyType.enemybumper.rawValue){
            
            if let someEnemy:Enemy = contact.bodyA.node as? Enemy{
                
                
                someEnemy.reverse()
                
            }
            
            
            
        } else if ( contact.bodyA.categoryBitMask == BodyType.enemybumper.rawValue && contact.bodyB.categoryBitMask == BodyType.enemy.rawValue){
            
            
            if let someEnemy:Enemy = contact.bodyB.node as? Enemy{
                
                someEnemy.reverse()
                
            }
            
            
        }
        
        
        
        //MARK:  AMMO with Player
        
        
        if ( contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.ammo.rawValue){
            
            if let somePlayer:Player = contact.bodyA.node as? Player{
                
                if let someAmmo:Ammo = contact.bodyB.node as? Ammo{
                    
                    
                    
                    if ( someAmmo.canAward == true && someAmmo.awardsToBothPlayers == false){
                        
                        if (somePlayer == thePlayer && someAmmo.name == "Player1Ammo"){
                            
                            someAmmo.pickedUp()
                            addToBulletCount( somePlayer, amount: someAmmo.awardsHowMuch)
                            
                        } else if (somePlayer == thePlayer2 && someAmmo.name == "Player2Ammo"){
                            
                            someAmmo.pickedUp()
                            addToBulletCount( somePlayer, amount: someAmmo.awardsHowMuch)
                        }
                        
                    } else if ( someAmmo.canAward == true && someAmmo.awardsToBothPlayers == true){
                        
                        someAmmo.pickedUp()
                        addToBulletCount( somePlayer, amount: someAmmo.awardsHowMuch)
                        
                    }
                    
                    
                    
                }
                
            }
            
            
            
            
            
        } else if ( contact.bodyA.categoryBitMask == BodyType.ammo.rawValue && contact.bodyB.categoryBitMask == BodyType.player.rawValue){
            
            if let somePlayer:Player = contact.bodyB.node as? Player{
                
                if let someAmmo:Ammo = contact.bodyA.node as? Ammo{
                    
                    if ( someAmmo.canAward == true && someAmmo.awardsToBothPlayers == false){
                        
                        if (somePlayer == thePlayer && someAmmo.name == "Player1Ammo"){
                            
                            someAmmo.pickedUp()
                            addToBulletCount( somePlayer, amount: someAmmo.awardsHowMuch)
                            
                        } else if (somePlayer == thePlayer2 && someAmmo.name == "Player2Ammo"){
                            
                            someAmmo.pickedUp()
                            addToBulletCount( somePlayer, amount: someAmmo.awardsHowMuch)
                        }
                        
                        
                    } else if ( someAmmo.canAward == true && someAmmo.awardsToBothPlayers == true){
                        
                        someAmmo.pickedUp()
                        addToBulletCount( somePlayer, amount: someAmmo.awardsHowMuch)
                        
                    }
                    
                }
                
            }
            
            
            
        }
        
        ////////////// PLAYER with Coin Object
        
        
        if ( contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.coin.rawValue){
            
            if let somePlayer:Player = contact.bodyA.node as? Player{
                
                if let someCoin:Coin = contact.bodyB.node as? Coin{
                    
                    handleContactWithPlayerAndCoin(somePlayer, someCoin: someCoin)
                    
                }
                
            }
            
            
            
        } else if ( contact.bodyA.categoryBitMask == BodyType.coin.rawValue && contact.bodyB.categoryBitMask == BodyType.player.rawValue){
            
            if let somePlayer:Player = contact.bodyB.node as? Player{
                
                if let someCoin:Coin = contact.bodyA.node as? Coin{
                    
                    handleContactWithPlayerAndCoin(somePlayer, someCoin: someCoin)
                    
                }
                
            }
            
        }
        
        
        
    }
    
    func handleContactWithPlayerAndCoin(_ somePlayer:Player, someCoin:Coin){
        
        
        
        if ( somePlayer == thePlayer){
            
            addToScore("Player1", amount: someCoin.score)
            
        } else if ( somePlayer == thePlayer2){
            
            addToScore("Player2", amount: someCoin.score)
            
        }
        
        someCoin.score = 0
        playSound(someCoin.sound)
        someCoin.removeFromParent()
        
        
        
    }
    
    //v1.4
    func handleContactWithCustomPortal(_ somePortal:Portal, thePlayerEnteringPortal:Player){
        
        var allowPlayerToPass:Bool = false
        
        if ( somePortal.requiresEnemiesKilledOver > 0 ){
            
            if (enemiesKilled >= somePortal.requiresEnemiesKilledOver ){
                
                allowPlayerToPass = true
                
            }
            
            
            
        }
        
        if ( somePortal.requiresScoreOver > 0){
            
            if (combinedScore >= somePortal.requiresScoreOver ){
                
                
                allowPlayerToPass = true
                
            }
            
            
        }
        if ( somePortal.requiresEnemiesKilledOver == -1 && somePortal.requiresScoreOver == -1){
            
            //Portal does not require anything to enter
            
            allowPlayerToPass = true
            
        }
        
        if ( allowPlayerToPass == true){
            
            if ( somePortal.movesPlayerToNode == false){
                
                somePortal.changeTexture()
            
            loadSpecificLevel(somePortal.levelToLoad, theLevelsName: somePortal.levelsName, showLevelPassedImage: somePortal.showLevelPassedImage, addsToLevelsPassed: somePortal.addsToLevelsPassed)
                
            } else {
                
                //move player and possibly camera or other player around the current level
                
                if ( somePortal.oneTimeUse == true && somePortal.alreadyUsed == false){
                
                if ( self.childNode(withName: somePortal.nodeToMovePlayerTo) != nil){
                    
                    
                    if (somePortal.oneTimeUse == true ){
                        
                        somePortal.alreadyUsed = true
                    }
                    
                    somePortal.changeTexture()

                    let locationToGoTo:CGPoint = (self.childNode(withName: somePortal.nodeToMovePlayerTo)?.position)!
                    

                    let move:SKAction = SKAction.move(to: locationToGoTo, duration:0)
                    thePlayerEnteringPortal.run(move)
                    
                    if ( somePortal.movesBothPlayers == true && singlePlayerGame == false){
                        //move the other player
                        
                        if (thePlayerEnteringPortal == thePlayer){
                            
                            thePlayer2.run(move)
                            
                        } else {
                            
                            thePlayer.run(move)
                        }
                        
                    }
                    
                    if ( somePortal.nodeToMoveCameraTo != ""){
                        
                        if ( self.childNode(withName: somePortal.nodeToMoveCameraTo) != nil){
                            
                            let camLocationToGoTo:CGPoint = (self.childNode(withName: somePortal.nodeToMoveCameraTo)?.position)!
                            let moveCam:SKAction = SKAction.move(to: camLocationToGoTo, duration:0)
                            theCamera.run(moveCam)
                        }
                        
                        
                    }
                    
                    
                    
                }
                }
                
            }
            
            
        } else {
            
           // print("criteria not met to pass")
        }
        
    }
    
    
    func handleContactWithPlayerAndEnemy(_ somePlayer:Player, someEnemy:Enemy, contactPoint:CGPoint){
        
        
         if ( someEnemy.jumpOnToKill == true && somePlayer.playerIsDead == false) {
            
            
            
            
            if (  contactPoint.y + someEnemy.jumpThreshold < somePlayer.position.y  ) {
                
                somePlayer.cantBeHurt = true
                
                let wait:SKAction = SKAction.wait(forDuration: 0.5)
                let run:SKAction = SKAction.run{
                    
                    somePlayer.cantBeHurt = false
                    
                }
                self.run(SKAction.sequence([wait, run ]))
                
                if ( (somePlayer.physicsBody?.velocity.dy)! <= 0.0 ){
                    
                    somePlayer.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    somePlayer.physicsBody?.angularVelocity = 0
                    
                    
                    somePlayer.physicsBody?.applyImpulse(CGVector(dx: 0, dy: someEnemy.jumpOnBounceBack))
                    
                    somePlayer.playSound(somePlayer.soundBounce)
                    
                }
                
                
                someEnemy.shot()
                
                
                if (someEnemy.isDead == true){
                    
                    if (somePlayer == thePlayer){
                        
                        addToScore("Player1", amount: someEnemy.score)
                        someEnemy.score = 0
                        
                    } else if (somePlayer == thePlayer2){
                        
                        addToScore("Player2", amount: someEnemy.score)
                        someEnemy.score = 0
                    }
                    
                    addToEnemyKillCount(someEnemy.enemyKillCount)
                    someEnemy.enemyKillCount = 0
                    
                }
                
                
            } else {
                
                if (someEnemy.isDead == false && somePlayer.cantBeHurt == false){
                    
                    if ( someEnemy.soundEnemyAttack != "" && someEnemy.treatLikeBullet == true){
                        //won't play through enemy class if getting removed
                        self.playSound(someEnemy.soundEnemyAttack)
                        
                    } else {
                        
                        someEnemy.playSound(someEnemy.soundEnemyAttack)
                    }
                    
                    someEnemy.attack()
                    
                    killPlayer(somePlayer)
                    
                    if (someEnemy.treatLikeBullet == true){
                        
                        someEnemy.removeFromParent()
                    }
                    
                }
                
            }
            
            
            
        } else {
            
            
            if (someEnemy.isDead == false && somePlayer.cantBeHurt == false){
                
                if ( someEnemy.soundEnemyAttack != "" && someEnemy.treatLikeBullet == true){
                    //won't play through enemy class if getting removed
                    self.playSound(someEnemy.soundEnemyAttack)
                    
                } else {
                    
                    someEnemy.playSound(someEnemy.soundEnemyAttack)
                }
                
                //someEnemy.playSound(someEnemy.soundEnemyAttack)
                
                
                someEnemy.attack()
                killPlayer(somePlayer)
                
                if (someEnemy.treatLikeBullet == true){
                    
                    someEnemy.removeFromParent()
                }
            }
            
            
        }
        
    }
    func handleContactWithPlayerAndSimpleEnemy(_ somePlayer:Player, someEnemy:SimpleEnemy, contactPoint:CGPoint){
        
        if ( somePlayer.playerIsDead == false ) {
            
            
            
            
            if (  contactPoint.y  < somePlayer.position.y) {
                
                if ( (somePlayer.physicsBody?.velocity.dy)! <= 0.0 ){
                    
                    somePlayer.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    somePlayer.physicsBody?.angularVelocity = 0
                    
                    
                    somePlayer.physicsBody?.applyImpulse(CGVector(dx: 0, dy: someEnemy.jumpOnBounceBack))
                    
                    somePlayer.playSound(somePlayer.soundBounce)
                    
                }
                
                
                
                
                if (somePlayer == thePlayer){
                    
                    addToScore("Player1", amount: someEnemy.score)
                    someEnemy.score = 0
                    
                    
                    
                } else if (somePlayer == thePlayer2){
                    
                    addToScore("Player2", amount: someEnemy.score)
                    someEnemy.score = 0
                }
                
                addToEnemyKillCount(someEnemy.enemyKillCount)
                someEnemy.enemyKillCount = 0
                
                someEnemy.blinkOut()
                
                
            } else {
                
                if (someEnemy.isDead == false && somePlayer.cantBeHurt == false){
                    
                    
                    
                    killPlayer(somePlayer)
                }
                
            }
            
            
            
        } else {
            
            
            if (someEnemy.isDead == false && somePlayer.cantBeHurt == false){
                
                
                killPlayer(somePlayer)
            }
            
            
        }
        
    }
    
    
    
    @objc(didEndContact:) func didEnd(_ contact: SKPhysicsContact) {
        
        if ( contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.pole.rawValue){
            
            
            if let somePlayer:Player = contact.bodyA.node as? Player{
                
                if (somePlayer == thePlayer){
                    
                    thePlayer.onPole = false
                    
                    if (thePlayer.isClimbing == true){
                        
                        thePlayer.offPole()
                    }
                    
                    currentMovingPole = nil
                    
                    
                    
                } else if (somePlayer == thePlayer2){
                    
                    thePlayer2.onPole = false
                    
                    if (thePlayer2.isClimbing == true){
                        
                        thePlayer2.offPole()
                    }
                    
                    currentMovingPole2 = nil
                    
                }
                
                
            }
            
            
            
            
        } else if ( contact.bodyA.categoryBitMask == BodyType.pole.rawValue && contact.bodyB.categoryBitMask == BodyType.player.rawValue){
            
            if let somePlayer:Player = contact.bodyB.node as? Player{
                
                if (somePlayer == thePlayer){
                    
                    thePlayer.onPole = false
                    
                    if (thePlayer.isClimbing == true){
                        
                        thePlayer.offPole()
                    }
                    
                    currentMovingPole = nil
                    
                    
                    
                } else if (somePlayer == thePlayer2){
                    
                    thePlayer2.onPole = false
                    
                    if (thePlayer2.isClimbing == true){
                        
                        thePlayer2.offPole()
                    }
                    
                    currentMovingPole2 = nil
                    
                }
                
                
            }
        }
        
        
        ///// PLAYER and Platform
        
        if ( contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.platform.rawValue){
            
            if let somePlayer:Player = contact.bodyA.node as? Player{
                
                if (somePlayer == thePlayer){
                    
                    currentMovingPlatform = nil
                    
                    
                    
                } else if (somePlayer == thePlayer2){
                    
                    currentMovingPlatform2 = nil
                    
                    
                }
                
            }
            
            
            
            
        } else if ( contact.bodyA.categoryBitMask == BodyType.platform.rawValue && contact.bodyB.categoryBitMask == BodyType.player.rawValue){
            
            
            
            
            if let somePlayer:Player = contact.bodyB.node as? Player{
                
                if (somePlayer == thePlayer){
                    
                    currentMovingPlatform = nil
                    
                    
                } else if (somePlayer == thePlayer2){
                    
                    currentMovingPlatform2 = nil
                    
                    
                }
                
            }
            
        }
        
        
    }


}
