//
//  GameScene_Operations.swift
//  SideScrolleriOS
//
//  Created by Justin Dike 2 on 12/8/15.
//  Copyright © 2015 CartoonSmart. All rights reserved.
//

import Foundation
import SpriteKit


extension GameScene {

    func addToBulletCount(_ playerBeingControlled:Player, amount:Int  ){
        
        
        
        if (playerBeingControlled == thePlayer){
            
            
            
            
            bulletCountPlayer1 = bulletCountPlayer1 + amount
            
            defaults.set(bulletCountPlayer1, forKey: "BulletCountPlayer1")
            
            bulletLabel1.text = String(self.bulletCountPlayer1 )
            
            
            
            
        } else if (playerBeingControlled == thePlayer2){
            
            
            
            bulletCountPlayer2 = bulletCountPlayer2 + amount
            
            defaults.set(bulletCountPlayer2, forKey: "BulletCountPlayer2")
            
            bulletLabel2.text = String(self.bulletCountPlayer2 )
            
            
            
            
            
        }
        
        
        
        
        
    }
    
    func addToScore(_ firedFromWho:String, amount:Int  ){
        
        
        
        if (firedFromWho == "Player1"){
            
            scorePlayer1 = scorePlayer1 + amount
            
            defaults.set(scorePlayer1, forKey: "ScorePlayer1")
            
            scoreLabelPlayer1.text = String(scorePlayer1 )
            
            
        } else if (firedFromWho == "Player2"){
            
            scorePlayer2 = scorePlayer2 + amount
            
            defaults.set(scorePlayer2, forKey: "ScorePlayer2")
            
            scoreLabelPlayer2.text = String(scorePlayer2 )
            
            
        }
        
        
        combinedScore = scorePlayer2 + scorePlayer1
        
        if ( combinedScore > highScore ){
            
            
            defaults.set(combinedScore, forKey: "HighScore")
            
            highScoreLabel.text = "High Score: " + String(combinedScore)
            
            
        }
        
        
        if (self.passLevelWithScore == true ){
            
            self.combinedScoreLabel.text =  String( self.combinedScore ) + " / " + String( self.passLevelWithScoreOver )
        } else {
            
            self.combinedScoreLabel.text =  String(self.combinedScore)
        }
        
        
        
        
        
        if ( playerVersusPlayer == false){
            
            checkScoreForWin()
            
        }
        
        
    }
    
    
    func addToEnemyKillCount(_ amount:Int){
        
        if ( amount > 0){
            
            enemiesKilled = enemiesKilled + amount
            
            if (self.passLevelWithEnemiesKilled == true){
                
                self.killCountLabel.text =  String( enemiesKilled ) + " / " + String( passLevelWithEnemiesKilledOver )
                
                if (enemiesKilled >= passLevelWithEnemiesKilledOver){
                    
                    levelsPassed = levelsPassed + 1
                    
                    loadAnotherLevel(currentLevel + 1 , transitionImage: "LevelPassed" )
                    
                    
                }
                
                
            } else {
                
                self.killCountLabel.text =  String( self.enemiesKilled )
            }
            
        }
        
        
        
        
        
    }
    
    func checkScoreForWin(){
        
        
        if ( passLevelWithScore == true ) {
            
            
            if (combineScoresToPassLevel == true){
                
                
                if (combinedScore >= passLevelWithScoreOver) {
                    
                    levelsPassed = levelsPassed + 1
                    
                    loadAnotherLevel(currentLevel + 1 , transitionImage: "LevelPassed" )
                    
                    
                }
                
                
            } else if (scorePlayer1 >= passLevelWithScoreOver) {
                
                levelsPassed = levelsPassed + 1
                
                loadAnotherLevel(currentLevel + 1 , transitionImage: "LevelPassed" )
                
            } else if (scorePlayer2 >= passLevelWithScoreOver) {
                
                levelsPassed = levelsPassed + 1
                
                loadAnotherLevel(currentLevel + 1, transitionImage: "LevelPassed" )
                
            }
            
        }
        
        
        
    }
    
    
    
    func removeGestures(){
        
        if let recognizers = self.view!.gestureRecognizers {
            
            for recognizer in recognizers {
                
                self.view!.removeGestureRecognizer(recognizer as UIGestureRecognizer)
            }
            
        }
        
        
    }
    
    
    func startAutoAdvance(){
        
        let wait:SKAction = SKAction.wait(forDuration: autoAdvanceLevelTime)
        let run:SKAction = SKAction.run{
            
            
            
            self.loadAnotherLevel(self.currentLevel + 1, transitionImage: "TimesUp")
        }
        let seq:SKAction = SKAction.sequence( [ wait, run ] )
        self.run(seq)
        
    }
    
    
    func loadAnotherLevel( _ levelToLoad:Int, transitionImage:String ) {
        
        var theLevelToLoad:Int = levelToLoad  //Swift 2.2 change
        
        if (transitionInProgress == false){
            
            
            let scale:SKAction = SKAction.scale(to: 0, duration: 0.0)
            let unhide:SKAction = SKAction.unhide()
            let scaleUp:SKAction = SKAction.scale(to: 1, duration: 0.5)
            
            
            if (transitionImage == "Player1Won"){
                
                playSound(soundPlayer1Win)
                
                if ( player1WonImage != nil) {
                    
                    player1WonImage?.position = transitionImageLocation
                    player1WonImage!.run(SKAction.sequence( [scale, unhide, scaleUp ]  ))
                    
                }
                
            } else if (transitionImage == "Player2Won"){
                
                if ( player2WonImage != nil) {
                    
                    playSound(soundPlayer2Win)
                    
                    player2WonImage?.position = transitionImageLocation
                    player2WonImage!.run(SKAction.sequence( [scale, unhide, scaleUp ]  ))
                    
                }
                
                
            } else if (transitionImage == "LevelPassed"){
                
                if ( levelPassedImage != nil) {
                    
                    playSound(soundLevelSucceed)
                    
                    levelPassedImage?.position = transitionImageLocation
                    
                    levelPassedImage!.run(SKAction.sequence( [scale, unhide, scaleUp ]  ))
                    
                }
                
                
            } else if (transitionImage == "LevelFailed"){
                
                if ( levelFailedImage != nil) {
                    
                    playSound(soundLevelFail)
                    
                    levelFailedImage?.position = transitionImageLocation
                    levelFailedImage!.run(SKAction.sequence( [scale, unhide, scaleUp ]  ))
                    
                }
                
                
            } else if (transitionImage == "TimesUp"){
                
                if ( timesUpImage != nil) {
                    
                    playSound(soundLevelSucceed)
                    
                    timesUpImage?.position = transitionImageLocation
                    timesUpImage!.run(SKAction.sequence( [scale, unhide, scaleUp ]  ))
                    
                }
                
                
            }
            
            
            
            
            removeGestures()
            cleanUpScene()
            
            transitionInProgress = true
            
            
            
            
            let wait:SKAction = SKAction.wait(forDuration: 3)
            let run:SKAction = SKAction.run{
                
                
                if (theLevelToLoad > self.maxLevels){
                    
                    theLevelToLoad = 1
                }
                
                let sksNameToLoad:String = Helpers.parsePropertyListForLevelToLoad(theLevelToLoad, levelsName:self.levelsName)
                
                
                
                var isMadeForPad:Bool = false
                var fullSKSNameToLoad:String = sksNameToLoad
                
                
                if (UIDevice.current.userInterfaceIdiom == .pad ){
                    
                    if let _ = GameScene(fileNamed: sksNameToLoad + "Pad") {
                        
                        fullSKSNameToLoad = sksNameToLoad + "Pad"
                        isMadeForPad = true
                    }
                } else  if (UIDevice.current.userInterfaceIdiom == .phone ){
                    
                    if let _ = GameScene(fileNamed: sksNameToLoad + "Phone") {
                        
                        fullSKSNameToLoad = sksNameToLoad + "Phone"
                        
                    }
                }
                
                
                
                
                
                
                
                if let scene = GameScene(fileNamed: fullSKSNameToLoad) {
                    
                    scene.currentLevel = theLevelToLoad
                    scene.player1PlaysAsPlayer2 = self.player1PlaysAsPlayer2
                    scene.playerVersusPlayer = self.playerVersusPlayer
                    scene.singlePlayerGame = self.singlePlayerGame // or false
                    scene.player2NotInUse = self.player2NotInUse
                    scene.levelsName = self.levelsName
                    
                    //v1.2
                    if ( self.currentLevel == scene.currentLevel){
                        print ("failed must be replaying same level")
                        scene.lastChosenTrack = self.lastChosenTrack
                        
                    }
                    
                    
                    if ( isMadeForPad == false){
                        
                        if (UIDevice.current.userInterfaceIdiom == .pad ){
                            //adjustments will be made in the scene to account for Aspect Fit deing used
                            
                            //as of 7.1.1 th behavior of AspectFill has changd, so using Fill here too 
                            scene.scaleMode = .aspectFill
                            
                            
                        } else {
                            //preferred Aspect Mode for scenes sized for their device
                            scene.scaleMode = .aspectFill
                        }
                        
                        
                    } else if ( isMadeForPad == true){
                        //preferred Aspect Mode for scenes sized for their device
                        scene.scaleMode = .aspectFill
                        scene.isMadeForPad = true
                    }
                    
                    
                    
                    
                    
                    if ( self.levelsPassed > self.defaults.integer(forKey: "LevelsPassed") ){
                        
                        self.defaults.set(self.levelsPassed, forKey: "LevelsPassed")
                        
                    }
                    
                    scene.levelsPassed = self.levelsPassed
                    
                    
                    
                    self.view?.presentScene(scene, transition:SKTransition.fade(with: SKColor.black, duration: 2))
                    
                }
                
                
                
                
            }
            let seq:SKAction = SKAction.sequence( [ wait, run ] )
            self.run(seq)
            
            
        }
        
        
        
    }
    
    //v1.4  entire function added
    
    func loadSpecificLevel(_ theLevelToLoad:Int, theLevelsName:String, showLevelPassedImage:Bool, addsToLevelsPassed:Bool   ) {
        
        var waitTime:TimeInterval = 1
        
        if (transitionInProgress == false){
            
            if ( showLevelPassedImage == true ){
                
                
                waitTime = 3
                let scale:SKAction = SKAction.scale(to: 0, duration: 0.0)
                let unhide:SKAction = SKAction.unhide()
                let scaleUp:SKAction = SKAction.scale(to: 1, duration: 0.5)
                
                
                
                if ( levelPassedImage != nil) {
                    
                    playSound(soundLevelSucceed)
                    
                    levelPassedImage?.position = transitionImageLocation
                    
                    levelPassedImage!.run(SKAction.sequence( [scale, unhide, scaleUp ]  ))
                    
                }
                
            }
            
            
            if (addsToLevelsPassed == true  ){
                
                // whether to save to the defaults the overall number of levels passed has increased. Only set this to true if the Portal is going to the next level in main "Levels" array, leave this false for Bonus / Secret Levels.
                
                levelsPassed = levelsPassed + 1
                
                if ( levelsPassed > self.defaults.integer(forKey: "LevelsPassed") ){
                    
                    self.defaults.set(levelsPassed, forKey: "LevelsPassed")
                    
                }
            }
            
            
            
            removeGestures()
            cleanUpScene()
            
            transitionInProgress = true
            
            let wait:SKAction = SKAction.wait(forDuration: waitTime)
            let run:SKAction = SKAction.run{
                
                let sksNameToLoad:String = Helpers.parsePropertyListForLevelToLoad(theLevelToLoad, levelsName:theLevelsName)
                
                
                var isMadeForPad:Bool = false
                var fullSKSNameToLoad:String = sksNameToLoad
                
                
                if (UIDevice.current.userInterfaceIdiom == .pad ){
                    
                    if let _ = GameScene(fileNamed: sksNameToLoad + "Pad") {
                        
                        fullSKSNameToLoad = sksNameToLoad + "Pad"
                        isMadeForPad = true
                    }
                } else  if (UIDevice.current.userInterfaceIdiom == .phone ){
                    
                    if let _ = GameScene(fileNamed: sksNameToLoad + "Phone") {
                        
                        fullSKSNameToLoad = sksNameToLoad + "Phone"
                        
                    }
                }
                
                
                
                
                if let scene = GameScene(fileNamed: fullSKSNameToLoad) {
                    
                    scene.currentLevel = theLevelToLoad
                    scene.player1PlaysAsPlayer2 = self.player1PlaysAsPlayer2
                    scene.playerVersusPlayer = self.playerVersusPlayer
                    scene.singlePlayerGame = self.singlePlayerGame // or false
                    scene.player2NotInUse = self.player2NotInUse
                    scene.levelsName = theLevelsName
                    scene.prefersNoMusic = self.prefersNoMusic
                    
                    if ( isMadeForPad == false){
                        
                        if (UIDevice.current.userInterfaceIdiom == .pad ){
                            //adjustments will be made in the scene to account for Aspect Fit deing used
                            
                            //as of 7.1.1 th behavior of AspectFill has changd, so using Fill here too
                            scene.scaleMode = .aspectFill
                            
                            
                        } else {
                            //preferred Aspect Mode for scenes sized for their device
                            scene.scaleMode = .aspectFill
                        }
                        
                        
                    } else if ( isMadeForPad == true){
                        //preferred Aspect Mode for scenes sized for their device
                        scene.scaleMode = .aspectFill
                        scene.isMadeForPad = true
                    }
                    
                    
                    
                    self.view?.presentScene(scene, transition:SKTransition.fade(with: SKColor.black, duration: 2))
                    
                }
                
                
                
            }
            let seq:SKAction = SKAction.sequence( [ wait, run ] )
            self.run(seq)
            
            
        }
        
        
        
    }

    
    
    
    func killPlayer(_ somePlayer:Player){
        
        if (somePlayer.playerIsDead == false) {
            
            somePlayer.playerIsDead = true
            
            somePlayer.die()
            
            
            self.loseLife(somePlayer);
            
            //v 1.42
            
            if ( resetPlatformTime > 0){
            
            resetPlatforms()
                
            }
            
        }
        
    }
    
    
    //v 1.42
    
    func resetPlatforms(){
        
        
        
        self.enumerateChildNodes(withName: "*") {
            node, stop in
            
            if let somePlatform:Platform = node as? Platform {
                
                somePlatform.resetPlatform(self.resetPlatformTime)
                
                
                
            }
            
        }
        
        
        
    }
    
    
    
    
    
    
    func loseLife(_ somePlayer:Player){
        
        
        var currentHearts:Int = 0
        
        if (somePlayer == thePlayer){
            
            heartsPlayer1 = heartsPlayer1 - 1
            
            defaults.set(heartsPlayer1, forKey: "HeartsPlayer1")
            
            currentHearts = heartsPlayer1
            
            
            
            currentMovingPole = nil
            
            currentMovingPlatform = nil
            
            thePlayer.isClimbing = false
            thePlayer.cantBeHurt = false
            
        } else if (somePlayer == thePlayer2){
            
            
            heartsPlayer2 = heartsPlayer2 - 1
            
            defaults.set(heartsPlayer2, forKey: "HeartsPlayer2")
            
            currentHearts = heartsPlayer2
            
            
            currentMovingPole2 = nil
            
            currentMovingPlatform2 = nil
            
            thePlayer2.isClimbing = false
            thePlayer2.cantBeHurt = false
        }
        
        
        
        tallyHearts()
        
        
        
        
        if ( currentHearts >= 1 ) {
            
            //PLAYER is still Alive
            
            somePlayer.playSound(somePlayer.soundLoseHeart)
            
            
            somePlayer.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            
            
            somePlayer.currentDirection = .none
            //somePlayer.removeAllActions()
            
            var startBackToLocation:CGPoint = CGPoint.zero
            
            if (somePlayer == thePlayer) {
                
                
                
                if ( respawnPointPlayer1 != CGPoint.zero) {
                    
                    startBackToLocation = respawnPointPlayer1
                    
                } else {
                    
                    startBackToLocation = getClosestSpawnLocationTo(thePlayer2)
                    startBackToLocation = CGPoint(x: startBackToLocation.x + 10, y: startBackToLocation.y)
                    
                }
                
                
                
                playerLastPosition = CGPoint.zero
                
                if ( player2NotInUse == true || player2OutOfGame == true){
                    
                    thePlayerCameraFollows = thePlayer
                }
                    
                else if ( onePlayerModeBasedOnControllers == false ){
                    
                    thePlayerCameraFollows = thePlayer2
                    
                    
                    self.cameraIcon2?.isHidden = false
                    self.cameraIcon1?.isHidden = true
                    
                    if (cameraFollowsPlayerX == true || cameraFollowsPlayerY == true ) {
                        
                        cameraDonePanningToNewFollower = false
                        
                        if ( cameraFollowsPlayerX == true ){
                            
                            let move:SKAction = SKAction.moveTo(x: (thePlayerCameraFollows?.position.x)!, duration: 1)
                            move.timingMode = .easeOut
                            
                            let run:SKAction = SKAction.run{
                                
                                self.cameraDonePanningToNewFollower = true
                            }
                            theCamera.run(SKAction.sequence([move, run ]))
                            
                        }
                        
                        if ( cameraFollowsPlayerY == true ){
                            
                            let move:SKAction = SKAction.moveTo(y: (thePlayerCameraFollows?.position.y)!, duration: 1)
                            move.timingMode = .easeOut
                            
                            let run:SKAction = SKAction.run{
                                
                                self.cameraDonePanningToNewFollower = true
                            }
                            theCamera.run(SKAction.sequence([move, run ]))
                            
                        }
                        
                        
                        
                    } else if (cameraBetweenPlayersX == true || cameraBetweenPlayersY == true) {
                        
                        cameraDonePanningToNewFollower = false
                        
                        if ( cameraBetweenPlayersX == true ){
                            
                            var newCentralLocation:CGPoint = CGPoint.zero
                            
                            let xDiff:CGFloat = abs( startBackToLocation.x - thePlayer2.position.x  ) / 2
                            
                            if (startBackToLocation.x < thePlayer2.position.x) {
                                
                                newCentralLocation = CGPoint( x: startBackToLocation.x + xDiff, y: theCamera.position.y )
                                
                                
                            } else {
                                
                                newCentralLocation = CGPoint( x: thePlayer2.position.x + xDiff, y: theCamera.position.y )
                                
                            }
                            
                            
                            
                            
                            let move:SKAction = SKAction.moveTo(x: newCentralLocation.x, duration: 1)
                            move.timingMode = .easeOut
                            
                            let run:SKAction = SKAction.run{
                                
                                self.cameraDonePanningToNewFollower = true
                            }
                            theCamera.run(SKAction.sequence([move, run ]))
                        }
                        
                        
                        
                        if ( cameraBetweenPlayersY == true ){
                            
                            var newCentralLocation:CGPoint = CGPoint.zero
                            
                            let yDiff:CGFloat = abs( startBackToLocation.y - thePlayer2.position.y  ) / 2
                            
                            if (startBackToLocation.y < thePlayer2.position.y) {
                                
                                newCentralLocation = CGPoint( x: theCamera.position.x, y: startBackToLocation.y + yDiff )
                                
                                
                            } else {
                                
                                newCentralLocation = CGPoint( x: theCamera.position.x, y: thePlayer2.position.y + yDiff  )
                                
                            }
                            
                            
                            
                            
                            let move:SKAction = SKAction.moveTo(y: newCentralLocation.y, duration: 1)
                            move.timingMode = .easeOut
                            
                            let run:SKAction = SKAction.run{
                                
                                self.cameraDonePanningToNewFollower = true
                            }
                            theCamera.run(SKAction.sequence([move, run ]))
                        }
                    }
                    
                    
                    
                }
                
            } else if (somePlayer == thePlayer2) {
                
                if ( respawnPointPlayer2 != CGPoint.zero){
                    
                    startBackToLocation = respawnPointPlayer2
                    
                } else {
                    
                    startBackToLocation = getClosestSpawnLocationTo(thePlayer)
                    startBackToLocation = CGPoint(x: startBackToLocation.x - 10, y: startBackToLocation.y)
                    
                }
                
                playerLastPosition = CGPoint.zero
                
                if (singlePlayerGame == true){
                    
                    //dont swap cameras
                    
                    thePlayerCameraFollows = thePlayer
                    
                } else if (player1OutOfGame == true ) {
                    
                    // player is totally out of the game
                    
                    thePlayerCameraFollows = thePlayer2
                    
                } else if ( onePlayerModeBasedOnControllers == false){
                    
                    thePlayerCameraFollows = thePlayer
                    
                    self.cameraIcon2?.isHidden = true
                    self.cameraIcon1?.isHidden = false
                    
                    if (cameraFollowsPlayerX == true || cameraFollowsPlayerY == true) {
                        
                        cameraDonePanningToNewFollower = false
                        
                        if ( cameraFollowsPlayerX == true ){
                            
                            let move:SKAction = SKAction.moveTo(x: (thePlayerCameraFollows?.position.x)!, duration: 1)
                            move.timingMode = .easeOut
                            
                            let run:SKAction = SKAction.run{
                                
                                self.cameraDonePanningToNewFollower = true
                            }
                            theCamera.run(SKAction.sequence([move, run ]))
                            
                        }
                        
                        if ( cameraFollowsPlayerY == true ){
                            
                            let move:SKAction = SKAction.moveTo(y: (thePlayerCameraFollows?.position.y)!, duration: 1)
                            move.timingMode = .easeOut
                            
                            let run:SKAction = SKAction.run{
                                
                                self.cameraDonePanningToNewFollower = true
                            }
                            theCamera.run(SKAction.sequence([move, run ]))
                            
                        }
                        
                    } else if (cameraBetweenPlayersX == true || cameraBetweenPlayersY == true ) {
                        
                        cameraDonePanningToNewFollower = false
                        
                        
                        if ( cameraBetweenPlayersX == true){
                            
                            var newCentralLocation:CGPoint = CGPoint.zero
                            
                            let xDiff:CGFloat = abs( startBackToLocation.x - thePlayer.position.x  ) / 2
                            
                            if (startBackToLocation.x < thePlayer.position.x) {
                                
                                newCentralLocation = CGPoint( x: startBackToLocation.x + xDiff, y: theCamera.position.y )
                                
                                
                            } else {
                                
                                newCentralLocation = CGPoint( x: thePlayer.position.x + xDiff, y: theCamera.position.y )
                                
                            }
                            
                            
                            
                            
                            let move:SKAction = SKAction.moveTo(x: newCentralLocation.x, duration: 1)
                            move.timingMode = .easeOut
                            
                            let run:SKAction = SKAction.run{
                                
                                self.cameraDonePanningToNewFollower = true
                            }
                            theCamera.run(SKAction.sequence([move, run ]))
                            
                        }
                        
                        
                        if ( cameraBetweenPlayersY == true ){
                            
                            var newCentralLocation:CGPoint = CGPoint.zero
                            
                            let yDiff:CGFloat = abs( startBackToLocation.y - thePlayer2.position.y  ) / 2
                            
                            if (startBackToLocation.y < thePlayer2.position.y) {
                                
                                newCentralLocation = CGPoint( x: theCamera.position.x, y: startBackToLocation.y + yDiff )
                                
                                
                            } else {
                                
                                newCentralLocation = CGPoint( x: theCamera.position.x, y: thePlayer2.position.y + yDiff  )
                                
                            }
                            
                            
                            
                            
                            let move:SKAction = SKAction.moveTo(y: newCentralLocation.y, duration: 1)
                            move.timingMode = .easeOut
                            
                            let run:SKAction = SKAction.run{
                                
                                self.cameraDonePanningToNewFollower = true
                            }
                            theCamera.run(SKAction.sequence([move, run ]))
                        }
                        
                    }
                    
                }
                
            }
            
            let wait:SKAction = SKAction.wait(forDuration: somePlayer.reviveTime)
            let move:SKAction = SKAction.move(to: startBackToLocation, duration:0)
            let run:SKAction = SKAction.run {
                
                
                somePlayer.playerIsDead = false;
                somePlayer.revive()
            }
            
            let seq:SKAction = SKAction.sequence([wait, move, wait, run])
            somePlayer.run(seq)
            
            
            
            
        } else if ( currentHearts <= 0 ) {
            
            //PLayer is dead
            
            somePlayer.playSound(somePlayer.soundDead)
            
            
            if (playerVersusPlayer == true) {
                
                //Not Co-Op Mode
                
                defaults.set(0, forKey: "ScorePlayer1")
                defaults.set(0, forKey: "ScorePlayer2")
                
                // will reload the next level to battle aain
                
                if (somePlayer == thePlayer) {
                    
                    theWinCount2 += 1
                    defaults.set(theWinCount2, forKey: "WinCount2")
                    levelsPassed = levelsPassed + 1
                    
                    loadAnotherLevel(currentLevel + 1, transitionImage:"Player2Won"  )
                    
                } else {
                    
                    theWinCount1 += 1
                    defaults.set(theWinCount1, forKey: "WinCount1")
                    
                    levelsPassed = levelsPassed + 1
                    
                    loadAnotherLevel(currentLevel + 1, transitionImage:"Player1Won"  )
                }
                
                
                
                
            } else {
                
                //in Co-Op Mode
                
                
                let wait:SKAction = SKAction.wait(forDuration: somePlayer.reviveTime)
                let run:SKAction = SKAction.run {
                    
                    somePlayer.removeFromParent()
                    
                    if (self.cameraBetweenPlayersX == true || self.cameraBetweenPlayersY == true){
                        
                        print("switching camera mode to follow remaining player ")
                        // switch to camera following a single player instead of between both
                        // if one player has died
                        self.cameraDonePanningToNewFollower = true
                        self.cameraBetweenPlayersX = false
                        self.cameraFollowsPlayerX = true
                        self.cameraBetweenPlayersY = false
                        self.cameraFollowsPlayerY = true
                        
                        if ( somePlayer == self.thePlayer){
                            
                            print("player 1 died, switched to player 2")
                            self.player1OutOfGame = true
                            self.thePlayerCameraFollows = self.thePlayer2
                            self.playerLastPosition  = self.thePlayer2.position
                            
                        } else if ( somePlayer == self.thePlayer2) {
                            self.player2OutOfGame = true
                            print("player 2 died, switch camera to player 1 ")
                            self.thePlayerCameraFollows =  self.thePlayer
                            self.playerLastPosition  = self.thePlayer.position
                            
                        }
                        
                    }
                    
                }
                self.run(SKAction.sequence([wait, run ]))
                
                
                
                
                
                
                
                if ( singlePlayerGame == true){
                    
                    if ( somePlayer == thePlayer){
                        //player 1 died in single player game,
                        
                        
                        decideHowToEndFailedGame()
                        
                        
                    } else if ( somePlayer == thePlayer2){
                        
                        cancelOnePlayerLoops()
                        
                    }
                    
                }else if ( heartsPlayer2 <= 0 && heartsPlayer1 <= 0) {
                    
                    //both players are dead
                    
                    decideHowToEndFailedGame()
                    
                }
                
                
                
            }
            
        }
        
        
        
        
    }
    func decideHowToEndFailedGame(){
        
        defaults.set(0, forKey: "ScorePlayer1")
        defaults.set(0, forKey: "ScorePlayer2")
        
        
        defaults.set(bulletsToStart, forKey: "BulletCountPlayer1")
        defaults.set(bulletsToStart, forKey: "BulletCountPlayer2")
        
        
        if ( refreshLevelOnDeath == true){
            
            //play the same level again
            
            
            loadAnotherLevel(currentLevel, transitionImage: "LevelFailed")
            
            
        } else {
            
            
            //go back to the main menu
            
            goBackToMainMenu()
            
        }
        
    }
    
    
    
    func getClosestSpawnLocationTo(_ playerToCheck:Player) -> CGPoint {
        
        var theLocation:CGPoint = CGPoint.zero
        
        var leastXDistance:CGFloat = 0
        
        for node in spawnArray {
            
            if (leastXDistance == 0){
                
                //set an initial value
                
                leastXDistance = abs(playerToCheck.position.x - node.position.x)
                
                theLocation = node.position
                
            } else {
                
                //check if the current node is closer
                
                let xDiff:CGFloat = abs(playerToCheck.position.x - node.position.x)
                
                if (xDiff < leastXDistance) {
                    
                    leastXDistance = xDiff
                    theLocation = node.position
                    
                }
                
                
            }
            
            
            
        }
        
        
        
        return theLocation
        
    }
    
    
    
    func addLife( _ playerBeingControlled:Player ){
        
        if ( playerBeingControlled == thePlayer){
            
            heartsPlayer1 = heartsPlayer1 + 1
            
            if (heartsPlayer1 > 4){
                
                heartsPlayer1 = 4
            }
            
            
        } else {
            
            heartsPlayer2 = heartsPlayer2 + 1
            
            if (heartsPlayer2 > 4){
                
                heartsPlayer2 = 4
            }
            
        }
        
        tallyHearts()
        
        
        
    }
    
    func stealLife( _ playerBeingControlled:Player ){
        
        playSound(stealHeartsSound)
        
        if ( playerBeingControlled == thePlayer){
            
            heartsPlayer1 = heartsPlayer1 - 1
            
            
            
            
        } else {
            
            heartsPlayer2 = heartsPlayer2 + 1
            
            
            
        }
        
        tallyHearts()
        
        
        
        
        
    }
    
    func tallyHearts(){
        
        
        if (heartsPlayer1 == 4){
            
            player1Heart1?.isHidden = false
            player1Heart2?.isHidden = false
            player1Heart3?.isHidden = false
            player1Heart4?.isHidden = false
            
            
        } else if (heartsPlayer1 == 3){
            
            player1Heart1?.isHidden = false
            player1Heart2?.isHidden = false
            player1Heart3?.isHidden = false
            player1Heart4?.isHidden = true
            
        } else if (heartsPlayer1 == 2){
            
            player1Heart1?.isHidden = false
            player1Heart2?.isHidden = false
            player1Heart3?.isHidden = true
            player1Heart4?.isHidden = true
            
            
        } else if (heartsPlayer1 == 1){
            
            player1Heart1?.isHidden = false
            player1Heart2?.isHidden = true
            player1Heart3?.isHidden = true
            player1Heart4?.isHidden = true
            
            
        } else if (heartsPlayer1 == 0){
            
            player1Heart1?.isHidden = true
            player1Heart2?.isHidden = true
            player1Heart3?.isHidden = true
            player1Heart4?.isHidden = true
            
            
        }
        
        
        
        //////////
        
        
        if ( player2NotInUse == false) {
            
            
            if (heartsPlayer2 == 4){
                
                player2Heart1?.isHidden = false
                player2Heart2?.isHidden = false
                player2Heart3?.isHidden = false
                player2Heart4?.isHidden = false
                
                
            } else if (heartsPlayer2 == 3){
                
                player2Heart1?.isHidden = false
                player2Heart2?.isHidden = false
                player2Heart3?.isHidden = false
                player2Heart4?.isHidden = true
                
            } else if (heartsPlayer2 == 2){
                
                player2Heart1?.isHidden = false
                player2Heart2?.isHidden = false
                player2Heart3?.isHidden = true
                player2Heart4?.isHidden = true
                
                
            } else if (heartsPlayer2 == 1){
                
                player2Heart1?.isHidden = false
                player2Heart2?.isHidden = true
                player2Heart3?.isHidden = true
                player2Heart4?.isHidden = true
                
            } else if (heartsPlayer2 == 0){
                
                player2Heart1?.isHidden = true
                player2Heart2?.isHidden = true
                player2Heart3?.isHidden = true
                player2Heart4?.isHidden = true
                
            }
            
        }
        
    }
    
    
    
    func playSound(_ theSound:String ){
        
        if (theSound != ""){
            
            //print(theSound)
            
            if ( theSound == p1SoundAmmoCollect){
                
                self.run(preloadedp1SoundAmmoCollect!)
                
            } else if ( theSound == p2SoundAmmoCollect){
                
                self.run(preloadedp2SoundAmmoCollect!)
                
            } else {
                
                
                
                let sound:SKAction = SKAction.playSoundFileNamed(theSound, waitForCompletion: true)
                self.run(sound)
                
            }
            
        }
        
    }



}
