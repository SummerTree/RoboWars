//
//  GameScene.swift
//  SideScroller
//
//  Created by Justin Dike 2 on 10/20/15.
//  Copyright (c) 2015 CartoonSmart. All rights reserved.
//

import SpriteKit
import AVFoundation
import GameController

enum Direction:Int {
    
    case left, right, up, down, none 
    
}

enum BodyType:UInt32 {
    
    case player = 1
    case platform = 2
    case pole = 4
    case portal = 8
    case coin = 16
    case deadZone = 32
    case enemy = 64
    case bullet = 128
    case ammo = 256
    case bumper = 512
    case enemybumper = 1028
}





class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player1OutOfGame:Bool = false
    var player2OutOfGame:Bool = false
    
    
    var button1:SKSpriteNode = SKSpriteNode()
    var button2:SKSpriteNode = SKSpriteNode()
    var pauseButton:SKSpriteNode = SKSpriteNode()
    var base:SKSpriteNode = SKSpriteNode()
    var ball:SKSpriteNode = SKSpriteNode()
    var stickActive:Bool = false
    var isMadeForPad:Bool = false
    
    
    
    var respawnFollowsPlayerX:Bool = false
     var respawnFollowsPlayerY:Bool = false
    
    var disableContinue:Bool = false
    
    var maxDistanceBetweenPlayersX:CGFloat = 960
    var maxDistanceBetweenPlayersY:CGFloat = 800
    
    var levelsName:String = "Levels"
    var transitionInProgress:Bool = true
    var playerVersusPlayer:Bool = false
    
    var player2NotInUse:Bool = false
    var bgSoundPlaying:Bool = false
    
    
    var player1Heart1:SKSpriteNode?
    var player1Heart2:SKSpriteNode?
    var player1Heart3:SKSpriteNode?
    var player1Heart4:SKSpriteNode?
    
    var player2Heart1:SKSpriteNode?
    var player2Heart2:SKSpriteNode?
    var player2Heart3:SKSpriteNode?
    var player2Heart4:SKSpriteNode?
    
    var halfScreenWidth:CGFloat = 960
    
    var autoAdvanceLevelTime:TimeInterval = 0
    
    var heartBoxPlayer1:SKSpriteNode?
    var heartBoxPlayer2:SKSpriteNode?
    var bulletIconPlayer1:SKSpriteNode?
    var bulletIconPlayer2:SKSpriteNode?
    
    var selectionBox:SKSpriteNode?
    var resumeGame:SKSpriteNode?
    var mainMenu:SKSpriteNode?
    
    
    var cameraIcon1:SKSpriteNode?
    var cameraIcon2:SKSpriteNode?
    
    
    var cameraFollowsPlayerX:Bool = false
    var cameraFollowsPlayerY:Bool = false
    
    var cameraLastPosition:CGPoint = CGPoint.zero
    
    
    var cameraDonePanningToNewFollower:Bool = true
    var cameraBetweenPlayersX:Bool = false //whether or not the camera follows the distance between both players on X
    var cameraBetweenPlayersY:Bool = false //whether or not the camera follows the distance between both players on Y
    var cameraOffsetX:CGFloat = 0
    var cameraOffsetY:CGFloat = 0
    
    
    var pauseLocation:CGPoint = CGPoint.zero
    var resumeLocation:CGPoint = CGPoint.zero
    var mainMenuLocation:CGPoint = CGPoint.zero
    var controllerLocation:CGPoint = CGPoint.zero
    var transitionImageLocation:CGPoint = CGPoint.zero
    
    var highScore:Int = 0
  
    var playerIndex1InUse:Bool = false
    var playerIndex2InUse:Bool = false
    
    var stealHearts:Bool = false
    var playerOnPlayerBounceThreshold:CGFloat = 50
    var playerOnPlayerImpact:CGFloat = 150
    
    var player1HasMicroController:Bool = false
    var player2HasMicroController:Bool = false
    
    var hasPlayer1AmmoAlready:Bool = false
    var hasPlayer2AmmoAlready:Bool = false
    
    var thePlayerCameraFollows:Player?
    var thePlayer:Player = Player()
    var thePlayer2:Player = Player()
    
    var singlePlayerGame:Bool = false
    var player1PlaysAsPlayer2:Bool = false
    var onePlayerModeBasedOnControllers:Bool = false  //if true a player dropped out of the game
    
    
    var activePlayerInOnePlayerMode:Player?
    var enemyPlayerInOnePlayerMode:Player?

    var connectController:SKSpriteNode = SKSpriteNode()
    var pauseLabel:SKSpriteNode = SKSpriteNode()
    
    
    var player1WonImage:SKSpriteNode?
    var player2WonImage:SKSpriteNode?
    var levelPassedImage:SKSpriteNode?
    var levelFailedImage:SKSpriteNode?
    var timesUpImage:SKSpriteNode?
    
   var highScoreLabel:SKLabelNode = SKLabelNode()
    var respawnPointPlayer1:CGPoint = CGPoint.zero
    var respawnPointPlayer2:CGPoint = CGPoint.zero
    
    var levelResetsHearts:Bool = true
   
    var killCountLabel:SKLabelNode = SKLabelNode()
    var scoreLabelPlayer1:SKLabelNode = SKLabelNode()
    var scoreLabelPlayer2:SKLabelNode = SKLabelNode()
    var combinedScoreLabel:SKLabelNode = SKLabelNode()
    
    var winCount1:SKLabelNode = SKLabelNode()
    var winCount2:SKLabelNode = SKLabelNode()
    
    var bulletLabel1:SKLabelNode = SKLabelNode()
    var bulletLabel2:SKLabelNode = SKLabelNode()
    
    var bulletsToStart:Int = 25
    var maxBulletsToStart:Int = 100
    var keepExistingBulletCount:Bool = false
    
    var theCamera:SKCameraNode = SKCameraNode()
    
    
    
    
    let tapMenu = UITapGestureRecognizer()
    
    let tapGeneralSelection = UITapGestureRecognizer()
    let tapPlayPause = UITapGestureRecognizer()
    
    var currentMovingPole:MovingPole?
    
    var currentMovingPlatform:MovingPlatform?
    
    var currentMovingPole2:MovingPole?
    
    var currentMovingPlatform2:MovingPlatform?
    
    
    
    var currentLevel:Int = 0 //
    var levelsPassed:Int = 1 // this is used for multiplying goals. Will increment up with very stage passed
    
    let defaults:UserDefaults = UserDefaults.standard
    
    //var playerIsDead:Bool = false // moved to Player class
    
    var startLocation:CGPoint = CGPoint.zero
    var startLocation2:CGPoint = CGPoint.zero
    
    var spawnArray = [SKNode]()
    
    var heartsPlayer1:Int = 0
    var heartsPlayer2:Int = 0
    
    
   
    
    
    var boundaryFlip:Bool = false
    var resetToLevel:Int = -1
    var refreshLevelOnDeath:Bool = false
    
    
    var playerLastPosition:CGPoint = CGPoint.zero
    var playerLastPosition2:CGPoint = CGPoint.zero
    
    
    
    var theWinCount1:Int  = 0
    var theWinCount2:Int  = 0
    
    
    var bulletCountPlayer1:Int = 0
    var bulletCountPlayer2:Int = 0
    

    var unlimitedBullets:Bool = false
    

    
    var resumeGameSelected:Bool = true
    
    var maxLevels:Int  = 1
    
    
    var passLevelWithScoreOver:Int = 0
    var passLevelWithScore:Bool = false
    var halfGoalsToPassForOnePlayer:Bool = false
    var combinedScore:Int = 0
    var scorePlayer1:Int = 0
    var scorePlayer2:Int = 0
    var resetScore:Bool = true
    var combineScoresToPassLevel:Bool = true
    
    
    var passLevelWithEnemiesKilledOver:Int = 0
    var passLevelWithEnemiesKilled:Bool = false
    var enemiesKilled:Int = 0
    var goalMultipliedByLevelsPassed:Bool = false
    
    //ammo 
    
    var p1AmmoAwardsHowMuch:Int = 10
    var p1AmmoSpawnsHowOften:UInt32 = 30
    var p1AmmoSpawnsAtRandomTime:Bool = false
    var p1AmmoMinimumTimeBetweenSpawns:TimeInterval = 5
    var p1AwardsToBothPlayers:Bool = false
    var p1OnlyAllowOneAtATime:Bool = false
    var p1SoundAmmoCollect:String = ""
    var p1SoundAmmoDrop:String = ""
    
    var preloadedp1SoundAmmoCollect:SKAction?
    var preloadedp2SoundAmmoCollect:SKAction?
    
    var stealHeartsSound:String = ""
    
    var p2AmmoAwardsHowMuch:Int = 10
    var p2AmmoSpawnsHowOften:UInt32 = 30
    var p2AmmoSpawnsAtRandomTime:Bool = false
    var p2AmmoMinimumTimeBetweenSpawns:TimeInterval = 5
    var p2AwardsToBothPlayers:Bool = false
    var p2OnlyAllowOneAtATime:Bool = false
    var p2SoundAmmoCollect:String = ""
    var p2SoundAmmoDrop:String = ""
    
    var soundLevelBegin:String = ""
    var soundLevelFail:String = ""
    var soundLevelSucceed:String = ""
    var soundPlayer1Win:String = ""
    var soundPlayer2Win:String = ""
    var soundUnpaused:String = ""
    
    //v1.1
    
    var boundaryFlipEnemies:Bool = false
    var boundaryFlipPlayers:Bool = false
    var cameraXLimitRight:CGFloat = 0
    var cameraXLimitLeft:CGFloat = 0
    var restrictCameraX:Bool = false
    var minimumEnemiesToPass:Int = 0
    
    //v1.2
    var trackNum:Int = 0
    var mp3List = [String]()
    var justStartedNewTrack:Bool = false
    var trackPromptLabel:SKLabelNode = SKLabelNode()
    var trackCreditLabel:SKLabelNode = SKLabelNode()
    var trackPromptLocation:CGPoint = CGPoint.zero
    var trackCreditLocation:CGPoint = CGPoint.zero
    var lastChosenTrack:Int = -1
    
    
    //these only apply to an issue with Aspect Fit not working in Xcode 7.1.1
    //work around is to hard code for Aspect Fill
    var camPadAspectAdjustment:CGFloat = 330
    var baseAspectPosition:CGPoint = CGPoint(x: -641, y: -274)
    var ballAspectPosition:CGPoint =  CGPoint(x: -634, y: -281)
    var button1AspectPosition:CGPoint = CGPoint(x: 770, y: -50)
    var button2AspectPosition:CGPoint = CGPoint(x: 775, y: -325)
    var winCount1AspectPosition:CGPoint = CGPoint( x: 40, y: -480)
    var winCount2AspectPosition:CGPoint = CGPoint(x: 400, y: -480)
    var bulletLabel1AspectPosition:CGPoint = CGPoint(x: -290, y: -480)
    var bulletIcon1AspectPosition:CGPoint = CGPoint(x: -200, y: -460)
    var bulletLabel2AspectPosition:CGPoint = CGPoint(x: 620, y: -480)
    var bulletIcon2AspectPosition:CGPoint = CGPoint(x: 710, y: -460)
    var heartBox1AspectPosition:CGPoint = CGPoint(x: -220, y: 444)
    var player1Heart1AspectPosition:CGPoint = CGPoint(x: -364, y: 460)
    var player1Heart2AspectPosition:CGPoint = CGPoint(x: -271, y: 460)
    var player1Heart3AspectPosition:CGPoint = CGPoint(x: -184, y: 460)
    var player1Heart4AspectPosition:CGPoint = CGPoint(x: -99, y: 460)
    var heartBox2AspectPosition:CGPoint = CGPoint(x: 605, y: 447)
    var player2Heart1AspectPosition:CGPoint = CGPoint(x: 461, y: 465)
    var player2Heart2AspectPosition:CGPoint =  CGPoint(x: 549, y: 465)
    var player2Heart3AspectPosition:CGPoint = CGPoint(x: 636, y: 465)
    var player2Heart4AspectPosition:CGPoint =  CGPoint(x: 721, y: 465)
    var killCountAspectPosition:CGPoint = CGPoint(x: 150, y: 430)
    var killCountBoxAspectPosition:CGPoint = CGPoint(x: 190, y: 447)
    var scorePlayer1AspectPosition:CGPoint = CGPoint(x: -180, y: 340)
    var scorePlayer2AspectPosition:CGPoint = CGPoint(x: 600, y: 340)
    var highScoreAspectPosition:CGPoint = CGPoint(x: 240, y: -480)
    var combinedScoreAspectPosition:CGPoint = CGPoint(x: 240, y: 340)
    var pausePlaceholderAspectPosition:CGPoint = CGPoint(x: 240, y: 80)
    var mainMenuPlaceholderAspectPosition:CGPoint = CGPoint(x: 240, y: -260)
    var resumePlaceholderAspectPosition:CGPoint = CGPoint(x: 240, y: -120)
    var transitionPlaceholderAspectPosition:CGPoint = CGPoint(x: 240, y: 80)
    var controllerPlaceholderAspectPosition:CGPoint = CGPoint(x: 240, y: -447)
    var trackPromptPlaceholderAspectPosition:CGPoint = CGPoint(x: 240, y: -347)
    var trackCreditPlaceholderAspectPosition:CGPoint = CGPoint(x: 240, y: -405)
    
   
    //v1.3
    var pauseTint:SKSpriteNode?
    var prefersNoMusic:Bool = false
    
    
    //v 1.42
    
    var resetPlatformTime:TimeInterval = 0
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        
        maxLevels = Helpers.getMaxLevels(levelsName)
        
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        
        
        parsePropertyList()
        
        print("Loaded Item \(currentLevel - 1) in Array named \(levelsName)")
        
        
        if ( cameraBetweenPlayersX == true && singlePlayerGame == true && player2NotInUse == true){
            
            //one player game, no need for camera to split the difference between players
            
            cameraFollowsPlayerX = true
            cameraBetweenPlayersX = false
            
        }
        if ( cameraBetweenPlayersY == true && singlePlayerGame == true && player2NotInUse == true){
            
            //one player game, no need for camera to split the difference between players
            
            cameraFollowsPlayerY = true
            cameraBetweenPlayersY = false
            
        }
        
        
        
        
        if ( goalMultipliedByLevelsPassed == true ){
            
            if ( passLevelWithEnemiesKilled == true){
                
                passLevelWithEnemiesKilledOver = passLevelWithEnemiesKilledOver * levelsPassed
                
                
                
            }
            if ( passLevelWithScore == true){
                
                passLevelWithScoreOver = passLevelWithScoreOver * levelsPassed
                
            }
            
            
        }
        
        if ( passLevelWithEnemiesKilledOver < minimumEnemiesToPass){
            
            passLevelWithEnemiesKilledOver = minimumEnemiesToPass
        }
        
        
        highScore = defaults.integer(forKey: "HighScore")
        
        
        if ( keepExistingBulletCount == true) {
            
           
            
            bulletCountPlayer1 = defaults.integer(forKey: "BulletCountPlayer1")
            bulletCountPlayer2 = defaults.integer(forKey: "BulletCountPlayer2")
            
            if ( bulletCountPlayer1 < bulletsToStart) {
                
                bulletCountPlayer1 = bulletsToStart
            }
            if ( bulletCountPlayer2 < bulletsToStart) {
                
                bulletCountPlayer2 = bulletsToStart
            }
            
            
            if ( bulletCountPlayer1 > maxBulletsToStart){
                bulletCountPlayer1 = maxBulletsToStart
            }
            if ( bulletCountPlayer2 > maxBulletsToStart){
                bulletCountPlayer2 = maxBulletsToStart
            }
            
        } else {
            
            bulletCountPlayer1 = bulletsToStart
            bulletCountPlayer2 = bulletsToStart
            
        }
        
        
        if (singlePlayerGame == true && playerVersusPlayer == true){
            
            // makes it so the PVP CPU player can always fire
            
            print("CPU will start with 200 ammo")
            
            bulletCountPlayer2 = 200
        }
        
        
        
        
        
        self.enumerateChildNodes(withName: "//*") {
            node, stop in
            
            if (node.name == "CameraIcon1") {
                
                self.cameraIcon1 = node as? SKSpriteNode
               
                
            }
            else if (node.name == "CameraIcon2") {
                
                self.cameraIcon2 = node as? SKSpriteNode
                
            }
            
            else if (node.name == "Player1Heart1") {
                
                self.player1Heart1 = node as? SKSpriteNode
 
            } else if (node.name == "Player1Heart2") {
                
                self.player1Heart2 = node as? SKSpriteNode
                
            } else if (node.name == "Player1Heart3") {
                
                self.player1Heart3 = node as? SKSpriteNode
                
            } else if (node.name == "Player1Heart4") {
                
                self.player1Heart4 = node as? SKSpriteNode
                
            } else  if (node.name == "Player2Heart1") {
                
                self.player2Heart1 = node as? SKSpriteNode
                
            } else if (node.name == "Player2Heart2") {
                
                self.player2Heart2 = node as? SKSpriteNode
                
            } else if (node.name == "Player2Heart3") {
                
                self.player2Heart3 = node as? SKSpriteNode
                
            } else if (node.name == "Player2Heart4") {
                
                self.player2Heart4 = node as? SKSpriteNode
                
            }
            else if (node.name == "PauseTint") {
                //v1.3
                self.pauseTint = node as? SKSpriteNode
                
            }
            else if (node.name == "HeartBox1") {
                
                self.heartBoxPlayer1 = node as? SKSpriteNode
                
            }
            else if (node.name == "HeartBox2") {
                
                self.heartBoxPlayer2 = node as? SKSpriteNode
                
            }
            else if (node.name == "BulletIcon1") {
                
                self.bulletIconPlayer1 = node as? SKSpriteNode
                
            }
            else if (node.name == "BulletIcon2") {
                
                self.bulletIconPlayer2 = node as? SKSpriteNode
                
            }
            else if (node.name == "Player1Won") {
                
                self.player1WonImage = node as? SKSpriteNode
                self.player1WonImage?.isHidden = true
            }
            else if (node.name == "Player2Won") {
                
                self.player2WonImage = node as? SKSpriteNode
                self.player2WonImage?.isHidden = true
                
            }
            else if (node.name == "LevelPassed") {
                
                self.levelPassedImage = node as? SKSpriteNode
                self.levelPassedImage?.isHidden = true
            }
            else if (node.name == "LevelFailed") {
                
                self.levelFailedImage = node as? SKSpriteNode
                self.levelFailedImage?.isHidden = true
            }
            else if (node.name == "TimesUp") {
                
                self.timesUpImage = node as? SKSpriteNode
                self.timesUpImage?.isHidden = true
            }
            
            else if (node.name == "MainMenu") {
                
                self.mainMenu = node as? SKSpriteNode
                
            }
            else if (node.name == "ResumeGame") {
                
                self.resumeGame = node as? SKSpriteNode
                
            }
            else if (node.name == "SelectionBox") {
                
                self.selectionBox = node as? SKSpriteNode
                
            }
            else if (node.name == "MainMenuPlaceholder") {
                
                self.mainMenuLocation = node.position
                
            }
            else if (node.name == "TransitionPlaceholder") {
                
                self.transitionImageLocation = node.position
                
            }
            else if (node.name == "TrackPromptPlaceholder") {
                //v1.2
                self.trackPromptLocation = node.position
                
            }
            else if (node.name == "TrackCreditPlaceholder") {
                //v1.2
                self.trackCreditLocation = node.position
                
            }
            else if (node.name == "ResumePlaceholder") {
                
               self.resumeLocation = node.position
                
            }
            else if (node.name == "PausePlaceholder") {
                
                self.pauseLocation  = node.position
                
            }
            else if (node.name == "ControllerPlaceholder") {
                
                self.controllerLocation  = node.position
                
            }
            else if (node.name == "TrackPrompt"){
                //v1.2
                if let label:SKLabelNode = node as? SKLabelNode{
                    
                    self.trackPromptLabel = label
                    self.trackPromptLabel.isHidden = true
                }
                
                
            }
            else if (node.name == "TrackCredit"){
                //v1.2
                if let label:SKLabelNode = node as? SKLabelNode{
                    
                    self.trackCreditLabel = label
                    self.trackCreditLabel.isHidden = true
                }
                
                
            }
            else if (node.name == "HighScore"){
                
                if let label:SKLabelNode = node as? SKLabelNode{
                    
                    self.highScoreLabel = label
                    
                    self.highScoreLabel.text = "High Score: " + String(self.highScore)
                    
                }
                
                
            }
            else if (node.name == "KillCount") {
                
                self.killCountLabel = node as! SKLabelNode
                

                if ( self.player2NotInUse == true) {
                    
                    
                    if (self.halfGoalsToPassForOnePlayer == true && self.passLevelWithEnemiesKilled == true ){
                        
                        self.passLevelWithEnemiesKilledOver = self.passLevelWithEnemiesKilledOver / 2
                        self.killCountLabel.text =  String( self.enemiesKilled ) + " / " + String( self.passLevelWithEnemiesKilledOver )
                        
                    } else if (self.halfGoalsToPassForOnePlayer == false && self.passLevelWithEnemiesKilled == true ){
                        
                        self.killCountLabel.text =  String( self.enemiesKilled ) + " / " + String( self.passLevelWithEnemiesKilledOver )
                    } else if ( self.passLevelWithEnemiesKilled == false){
                        
                        self.killCountLabel.text =  String( self.enemiesKilled )
                    }
                    
                } else {
                    
                    if (self.passLevelWithEnemiesKilled == true ){
                        
                        self.killCountLabel.text =  String( self.enemiesKilled ) + " / " + String( self.passLevelWithEnemiesKilledOver )
                    } else {
                        
                        self.killCountLabel.text =  String( self.enemiesKilled )
                    }
                    
                    
                }
                
                
                
                
            }
            else if (node.name == "ScorePlayer1") {
                
                self.scoreLabelPlayer1 = node as! SKLabelNode
                self.scoreLabelPlayer1.text =  String(self.scorePlayer1 )
 
                
            }
            else if (node.name == "ScorePlayer2") {
                
                self.scoreLabelPlayer2 = node as! SKLabelNode
                self.scoreLabelPlayer2.text =  String(self.scorePlayer2 )
                
                
            }
            else if (node.name == "CombinedScore") {
                
                self.combinedScoreLabel = node as! SKLabelNode
                
                
                if ( self.player2NotInUse == true) {
                    
                    
                    if (self.halfGoalsToPassForOnePlayer == true && self.passLevelWithScore == true ){
                        
                        self.passLevelWithScoreOver = self.passLevelWithScoreOver / 2
                        self.combinedScoreLabel.text =  String( self.combinedScore ) + " / " + String( self.passLevelWithScoreOver )
                        
                    } else if (self.halfGoalsToPassForOnePlayer == false && self.passLevelWithScore == true ){
                        
                        self.combinedScoreLabel.text =  String( self.combinedScore ) + " / " + String( self.passLevelWithScoreOver )
                        
                    } else if ( self.passLevelWithScore == false){
                        
                        self.combinedScoreLabel.text =  String( self.combinedScore )
                    }
                    
                } else {
                    
                    if (self.passLevelWithScore == true ){
                        
                        self.combinedScoreLabel.text =  String( self.combinedScore ) + " / " + String( self.passLevelWithScoreOver )
                    } else {
                        
                        self.combinedScoreLabel.text =  String(self.combinedScore)
                    }
                    
                    
                }
                
                
                
                
            }
                
            else if (node.name == "BulletLabel1") {
                
                
                self.bulletLabel1 = node as! SKLabelNode
                self.bulletLabel1.text =  String(self.bulletCountPlayer1 )
                
                if ( self.unlimitedBullets == true) {
                    
                    self.bulletLabel1.isHidden = true
                }
                
            } else if (node.name == "BulletLabel2") {
                
                self.bulletLabel2 = node as! SKLabelNode
                self.bulletLabel2.text =  String(self.bulletCountPlayer2 )
                
                if ( self.unlimitedBullets == true) {
                    
                    self.bulletLabel2.isHidden = true
                }
                
                
            }else if (node.name == "BulletIcon1") {
                
                if ( self.unlimitedBullets == true) {
                    node.isHidden = true
                }
                
            }else if (node.name == "BulletIcon2") {
                
                if ( self.unlimitedBullets == true) {
                    node.isHidden = true
                }
                
            }else if (node.name == "PauseLabel") {
                
                self.pauseLabel = node as! SKSpriteNode
                
                self.pauseLabel.isHidden = true
                self.pauseLabel.position = self.pauseLocation
                
                
            } else if (node.name == "ConnectController") {
                
                self.connectController = node as! SKSpriteNode
                self.connectController.isHidden = true
                
                
            } else if (node.name == "WinCount1") {
                
                self.winCount1 = node as! SKLabelNode
                self.theWinCount1 = self.defaults.integer(forKey: "WinCount1")
                self.winCount1.text =  "WINS:" + String( self.theWinCount1 )
                
                if (self.playerVersusPlayer == false){
                    
                    self.winCount1.isHidden = true
                }
                
            } else if (node.name == "WinCount2") {
                
                self.winCount2 = node as! SKLabelNode
                self.theWinCount2 = self.defaults.integer(forKey: "WinCount2")
                self.winCount2.text =  "WINS:" + String( self.theWinCount2 )
                
                if (self.playerVersusPlayer == false){
                    
                    self.winCount2.isHidden = true
                }
                
            }  else if (node.name == "Base") {
                
                self.base = node as! SKSpriteNode
                self.base.alpha = 0.4
                
            } else if (node.name == "Ball") {
                
                self.ball = node as! SKSpriteNode
                self.ball.alpha = 0.4
                
            } else if (node.name == "Button1") {
                
                print("setup button1")
                
                 self.button1 = node as! SKSpriteNode
                self.button1.alpha = 0.4
                
            } else if (node.name == "Button2") {
                
                 self.button2 = node as! SKSpriteNode
                self.button2.alpha = 0.4
                
            } else if (node.name == "PauseButton") {
                
                self.pauseButton = node as! SKSpriteNode
                
                
            }
        
        }
        
        
        
        //switch heart textures v1.51
        
        if ( player1PlaysAsPlayer2 == true){
            
            let tempTexture:SKTexture = (self.player1Heart1?.texture)!
            
            self.player1Heart1?.texture = (self.player2Heart1?.texture)!
            self.player1Heart2?.texture = (self.player2Heart1?.texture)!
            self.player1Heart3?.texture = (self.player2Heart1?.texture)!
            self.player1Heart4?.texture = (self.player2Heart1?.texture)!
            
            self.player2Heart1?.texture = tempTexture
            self.player2Heart2?.texture = tempTexture
            self.player2Heart3?.texture = tempTexture
            self.player2Heart4?.texture = tempTexture
            
            
        }
        
        
    
        setUpControllerObservers()
        connectControllers()
        
        
        if ( disableContinue == false && levelsName != "VersusLevels"){
            
            if ( currentLevel > defaults.integer(forKey: "LastLevel")){
                
                defaults.set(currentLevel, forKey: "LastLevel")  // saves the current progress
                
            }

        }
        
        physicsWorld.contactDelegate = self
        
        
        if (self.childNode(withName: "Player1") != nil && player1PlaysAsPlayer2 == false) {
            
            thePlayer = self.childNode(withName: "Player1") as! Player
            
            thePlayer.currentLevel = currentLevel
            thePlayer.levelsName = levelsName
            thePlayer.setUpPlayer()
            
            
            
            thePlayerCameraFollows = thePlayer
            
            
            
            startLocation = thePlayer.position
            
            
        } else if (self.childNode(withName: "Player2") != nil && player1PlaysAsPlayer2 == true) {
            
            //switch Player1 for Player2
            
            thePlayer = self.childNode(withName: "Player2") as! Player
            
            thePlayer.currentLevel = currentLevel
            thePlayer.levelsName = levelsName
            thePlayer.setUpPlayer()
            
            
            
            thePlayerCameraFollows = thePlayer
            
            
            
            startLocation = thePlayer.position
        }
        
        if (self.childNode(withName: "Player2") != nil && player1PlaysAsPlayer2 == false) {
            
            
            
            thePlayer2 = self.childNode(withName: "Player2") as! Player
            thePlayer2.currentLevel = currentLevel
            thePlayer2.levelsName = levelsName
            thePlayer2.setUpPlayer()
            
            startLocation2 = thePlayer2.position
            
            
        } else if (self.childNode(withName: "Player1") != nil && player1PlaysAsPlayer2 == true) {
            
            
            //switch Player1 for Player2
            
            thePlayer2 = self.childNode(withName: "Player1") as! Player
            thePlayer2.currentLevel = currentLevel
            thePlayer2.levelsName = levelsName
            thePlayer2.setUpPlayer()
            
            startLocation2 = thePlayer2.position
        }
        
       
        
        if (self.childNode(withName: "TheCamera") != nil) {
            
            
            
            
                theCamera = self.childNode(withName: "TheCamera") as! SKCameraNode
                self.camera = theCamera
            
            
        }
        
       
        
       
            tapMenu.addTarget(self, action: #selector(GameScene.tappedMenu))
            tapMenu.allowedPressTypes = [NSNumber (value:  UIPressType.menu.rawValue)]
            self.view!.addGestureRecognizer(tapMenu)
            
            
        
        
        
        for node in self.children {
            
            if node.name == "SpawnPoint" {
                
                spawnArray.append(node)
                
            }
            else if node.name == "RespawnPlayer1" {
                
                respawnPointPlayer1 = node.position
                
            }
            else if node.name == "RespawnPlayer2" {
                
                respawnPointPlayer2 = node.position
                
            }
            
            
            else if let thePlatform:Platform = node as? Platform {
                
                    thePlatform.setUpPlatform()
                
            }
                
           
            else if let thePole:Pole = node as? Pole {
                
                thePole.setUpPole()
                
            }
            else if let theBumper:EnemyBumper = node as? EnemyBumper {
                
                theBumper.setUpBumper()
                
            }
            else if let theBumper:Bumper = node as? Bumper {
                
                theBumper.setUpBumper()
                
            }
            else if let thePortal:Portal = node as? Portal {
                
                thePortal.setUpPortal()
                
            }
            else if let theDeadZone:DeadZone = node as? DeadZone {
                
                theDeadZone.setUpDeadZone()
                
            }
            else if let theCoin:Coin = node as? Coin {
                
                theCoin.setUpCoin()
                
            }
            
           
            else if let theAmmo:Ammo = node as? Ammo {
                
                
                
                if (theAmmo.name == "Player1Ammo"){
                    
                    theAmmo.awardsHowMuch = p1AmmoAwardsHowMuch
                    theAmmo.spawnsAtRandomTime = p1AmmoSpawnsAtRandomTime
                    theAmmo.spawnsHowOften = p1AmmoSpawnsHowOften
                    theAmmo.minimumTimeBetweenSpawns = p1AmmoMinimumTimeBetweenSpawns
                    theAmmo.awardsToBothPlayers = p1AwardsToBothPlayers
                    theAmmo.onlyAllowOneAtATime = p1OnlyAllowOneAtATime
                    theAmmo.soundAmmoDrop = p1SoundAmmoDrop
                    theAmmo.soundAmmoCollect = p1SoundAmmoCollect
                    preloadedp1SoundAmmoCollect = SKAction.playSoundFileNamed(p1SoundAmmoCollect, waitForCompletion: false)
                    
                } else if (theAmmo.name == "Player2Ammo"){
                    
                    theAmmo.awardsHowMuch = p2AmmoAwardsHowMuch
                    theAmmo.spawnsAtRandomTime = p2AmmoSpawnsAtRandomTime
                    theAmmo.spawnsHowOften = p2AmmoSpawnsHowOften
                    theAmmo.minimumTimeBetweenSpawns = p2AmmoMinimumTimeBetweenSpawns
                    theAmmo.onlyAllowOneAtATime = p2OnlyAllowOneAtATime
                    theAmmo.soundAmmoDrop = p2SoundAmmoDrop
                    theAmmo.soundAmmoCollect = p2SoundAmmoCollect
                    preloadedp2SoundAmmoCollect = SKAction.playSoundFileNamed(p2SoundAmmoCollect, waitForCompletion: false)
                }
                
                theAmmo.setUp()
                
            }
            else if let theEnemy:SimpleEnemy = node as? SimpleEnemy {
                

                theEnemy.setUp()
                
               
                
            }

        }
        
        
        if ( resetScore == true){
            
            scorePlayer1 = 0
            scorePlayer2 = 0
            scorePlayer1 = defaults.integer(forKey: "ScorePlayer1")
            scorePlayer2 = defaults.integer(forKey: "ScorePlayer2")
            combinedScore = 0
            
            
            
        } else {

           scorePlayer1 = defaults.integer(forKey: "ScorePlayer1")
           scorePlayer2 = defaults.integer(forKey: "ScorePlayer2")
           combinedScore = scorePlayer1 + scorePlayer2
            
            self.scoreLabelPlayer1.text =  String(self.scorePlayer1 )
            self.scoreLabelPlayer2.text =  String(self.scorePlayer2 )
            
            if (self.passLevelWithScore == true ){
                
                self.combinedScoreLabel.text =  String( self.combinedScore ) + " / " + String( self.passLevelWithScoreOver )
            } else {
                
                self.combinedScoreLabel.text =  String(self.combinedScore)
            }

            

        }
        
        
       
        if (levelResetsHearts == true){
            
            heartsPlayer1 = 4
            heartsPlayer2 = 4
            defaults.set(heartsPlayer1, forKey: "HeartsPlayer1")
            defaults.set(heartsPlayer2, forKey: "HeartsPlayer2")
            
            
        } else {
            
            
            if (defaults.integer(forKey: "HeartsPlayer1") <= 0){
                
                //player 1 is dead
                thePlayer.playerIsDead = true
                thePlayer.isHidden = true
                
            } else {
                
                heartsPlayer1 = defaults.integer(forKey: "HeartsPlayer1")
                
            }
            
            
            if (defaults.integer(forKey: "HeartsPlayer2") <= 0){
                
                //player 2 is dead
                thePlayer2.playerIsDead = true
                thePlayer2.isHidden = true
                
            } else {
                
                heartsPlayer2 = defaults.integer(forKey: "HeartsPlayer2")
                
            }
            
        }
        
        
        tallyHearts()
        
        
       
        
        let wait:SKAction = SKAction.wait(forDuration: 1/60)
        let run:SKAction = SKAction.run {
            
            self.afterDidMoveToView()
            
        }
        let seq:SKAction = SKAction.sequence( [wait, run] )
        self.run(seq)
        
        
        
       /*
        
        let wait2:SKAction = SKAction.waitForDuration(2)
        let repeatShoot:SKAction = SKAction.runBlock{
        
            self.shoot(self.thePlayer);
            
        }
        let seq2:SKAction = SKAction.sequence( [wait2, repeatShoot] )
        let repeatAction:SKAction = SKAction.repeatActionForever(seq2)
        self.runAction(repeatAction)
        
      
        */
        
        if (player2NotInUse == true){
            
            
            
            playerVersusPlayer = false
            thePlayer2.removeFromParent()
            enemyPlayerInOnePlayerMode = nil
            
            player2Heart1?.isHidden = true
            player2Heart2?.isHidden = true
            player2Heart3?.isHidden = true
            player2Heart4?.isHidden = true
            
            winCount1.isHidden = true
            winCount2.isHidden = true 
            bulletLabel2.isHidden = true
            scoreLabelPlayer2.isHidden = true
            bulletIconPlayer2?.isHidden = true
            heartBoxPlayer2?.isHidden = true
            
            
            
            for node in self.children {
                
                if node.name == "Player2Ammo" {
                    
                    node.removeFromParent()
                    
                }
                
            }
            
        }
        
        
        
        if ( isMadeForPad == true){
            
            halfScreenWidth = 512
            
        }
        
        
        
          if (UIDevice.current.userInterfaceIdiom == .pad && isMadeForPad == false && scene?.scaleMode == .aspectFit){
            
            //Xcode 7.1.1 changed the behavior of Aspect Fit, so this won't run (until they fix this issue)
            
           offsetCameraItemsOnPadWithAspectFit()
            
          } else if (UIDevice.current.userInterfaceIdiom == .pad && isMadeForPad == false && scene?.scaleMode == .aspectFill){
            
            //Xcode 7.1.1 changed the behavior of Aspect Fit, so we will compensate for Fill instead
            
            offsetCameraItemsOnPadWithAspectFill()
        }
        
        
        
        
    }
    
    
    func offsetCameraItemsOnPadWithAspectFill(){
        
       
        
        
        var baseAspectOffset:CGPoint = CGPoint.zero
        var ballAspectOffset:CGPoint =  CGPoint.zero
        var button1AspectOffset:CGPoint = CGPoint.zero
        var button2AspectOffset:CGPoint = CGPoint.zero
        var winCount1AspectOffset:CGPoint = CGPoint.zero
        var winCount2AspectOffset:CGPoint = CGPoint.zero
        var bulletLabel1AspectOffset:CGPoint = CGPoint.zero
        var bulletIcon1AspectOffset:CGPoint = CGPoint.zero
        var bulletLabel2AspectOffset:CGPoint = CGPoint.zero
        var bulletIcon2AspectOffset:CGPoint = CGPoint.zero
        var heartBox1AspectOffset:CGPoint = CGPoint.zero
        var player1Heart1AspectOffset:CGPoint = CGPoint.zero
        var player1Heart2AspectOffset:CGPoint = CGPoint.zero
        var player1Heart3AspectOffset:CGPoint = CGPoint.zero
        var player1Heart4AspectOffset:CGPoint = CGPoint.zero
        var heartBox2AspectOffset:CGPoint = CGPoint.zero
        var player2Heart1AspectOffset:CGPoint = CGPoint.zero
        var player2Heart2AspectOffset:CGPoint =  CGPoint.zero
        var player2Heart3AspectOffset:CGPoint = CGPoint.zero
        var player2Heart4AspectOffset:CGPoint =  CGPoint.zero
        var killCountAspectOffset:CGPoint = CGPoint.zero
        var killCountBoxAspectOffset:CGPoint = CGPoint.zero
        var scorePlayer1AspectOffset:CGPoint = CGPoint.zero
        var scorePlayer2AspectOffset:CGPoint = CGPoint.zero
        var highScoreAspectOffset:CGPoint = CGPoint.zero
        var combinedScoreAspectOffset:CGPoint = CGPoint.zero
        var pausePlaceholderAspectOffset:CGPoint = CGPoint.zero
        var mainMenuPlaceholderAspectOffset:CGPoint = CGPoint.zero
        var resumePlaceholderAspectOffset:CGPoint = CGPoint.zero
        var transitionPlaceholderAspectOffset:CGPoint = CGPoint.zero
        var controllerPlaceholderAspectOffset:CGPoint = CGPoint.zero
        var trackPromptPlaceholderAspectOffset:CGPoint = CGPoint.zero
        var trackCreditPlaceholderAspectOffset:CGPoint = CGPoint.zero
        
        let path = Bundle.main.path(forResource: "LevelData", ofType: "plist")
        
        let dict:NSDictionary = NSDictionary(contentsOfFile: path!)!
        
        
        
        
        if (dict.object(forKey: "iPadAdjustments") != nil) {
            
            
            
            if let adjustmentData = dict.object(forKey: "iPadAdjustments") as? [String : AnyObject] {
                
                for (key, value) in adjustmentData{
                    
                    if ( key == "Base"){
                        
                        if ( value is String ){
                        
                            baseAspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    } else if ( key == "Ball"){
                        
                        if ( value is String ){
                            
                            ballAspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    } else if ( key == "Button1"){
                        
                        if ( value is String ){
                            
                            button1AspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    } else if ( key == "Button2"){
                        
                        if ( value is String ){
                            
                            button2AspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    } else if ( key == "HeartBox1"){
                        
                        if ( value is String ){
                            
                            heartBox1AspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    } else if ( key == "Player1Heart1"){
                        
                        if ( value is String ){
                            
                            player1Heart1AspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    } else if ( key == "Player1Heart2"){
                        
                        if ( value is String ){
                            
                            player1Heart2AspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    } else if ( key == "Player1Heart3"){
                        
                        if ( value is String ){
                            
                            player1Heart3AspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    } else if ( key == "Player1Heart4"){
                        
                        if ( value is String ){
                            
                            player1Heart4AspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    } else if ( key == "HeartBox2"){
                        
                        if ( value is String ){
                            
                            heartBox2AspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    } else if ( key == "Player2Heart1"){
                        
                        if ( value is String ){
                            
                            player2Heart1AspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    } else if ( key == "Player2Heart2"){
                        
                        if ( value is String ){
                            
                            player2Heart2AspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    } else if ( key == "Player2Heart3"){
                        
                        if ( value is String ){
                            
                            player2Heart3AspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    } else if ( key == "Player2Heart4"){
                        
                        if ( value is String ){
                            
                            player2Heart4AspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    }  else if ( key == "WinCount1"){
                        
                        if ( value is String ){
                            
                            winCount1AspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    } else if ( key == "WinCount2"){
                        
                        if ( value is String ){
                            
                            winCount2AspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    } else if ( key == "BulletIcon1"){
                        
                        if ( value is String ){
                            
                            bulletIcon1AspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    } else if ( key == "BulletIcon2"){
                        
                        if ( value is String ){
                            
                            bulletIcon2AspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    }
                    else if ( key == "BulletLabel1"){
                        
                        if ( value is String ){
                            
                            bulletLabel1AspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    }
                    else if ( key == "BulletLabel2"){
                        
                        if ( value is String ){
                            
                            bulletLabel2AspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    }
                    else if ( key == "KillCount"){
                        
                        if ( value is String ){
                            
                            killCountAspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    }
                    else if ( key == "KillCountBox"){
                        
                        if ( value is String ){
                            
                            killCountBoxAspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    }
                    else if ( key == "ScorePlayer1"){
                        
                        if ( value is String ){
                            
                            scorePlayer1AspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    }
                    else if ( key == "ScorePlayer2"){
                        
                        if ( value is String ){
                            
                            scorePlayer2AspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    }
                    else if ( key == "HighScore"){
                        
                        if ( value is String ){
                            
                            highScoreAspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    }
                    else if ( key == "CombinedScore"){
                        
                        if ( value is String ){
                            
                            combinedScoreAspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    }
                    else if ( key == "PausePlaceholder"){
                        
                        if ( value is String ){
                            
                            pausePlaceholderAspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    }
                    else if ( key == "ResumePlaceholder"){
                        
                        if ( value is String ){
                            
                            resumePlaceholderAspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    }else if ( key == "MainMenuPlaceholder"){
                        
                        if ( value is String ){
                            
                            mainMenuPlaceholderAspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    }else if ( key == "TransitionPlaceholder"){
                        
                        if ( value is String ){
                            
                            transitionPlaceholderAspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    }else if ( key == "ControllerPlaceholder"){
                        
                        if ( value is String ){
                            
                            controllerPlaceholderAspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    }else if ( key == "TrackPromptPlaceholder"){
                        
                        if ( value is String ){
                            
                            trackPromptPlaceholderAspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    }else if ( key == "TrackCreditPlaceholder"){
                        
                        if ( value is String ){
                            
                            trackCreditPlaceholderAspectOffset = CGPointFromString(value as! String)
                            
                        }
                        
                        
                    }



                    
                    
                }
                
                
                
            }
            
        }
        
        
        //v1.2
        
       
        theCamera.xScale = 1.3
        theCamera.yScale = 1.3
        
        theCamera.position = CGPoint(x: theCamera.position.x - camPadAspectAdjustment , y: theCamera.position.y)
        
        theCamera.enumerateChildNodes(withName: "*") {
            node, stop in
            
           
            
            if ( node.position.y < 0){
                
                node.position = CGPoint(x: node.position.x, y: node.position.y * 0.9)
                
            }

            
        }
        
        
        
        
        
        
        theCamera.enumerateChildNodes(withName: "*") {
            node, stop in
            
            
            if (node.name == "Base") {
                
                node.position = self.baseAspectPosition
                node.position = CGPoint(x: node.position.x + baseAspectOffset.x, y: node.position.y + baseAspectOffset.y)
                
            }
            else  if (node.name == "Ball") {
                
                node.position = self.ballAspectPosition
                node.position = CGPoint(x: node.position.x + ballAspectOffset.x, y: node.position.y + ballAspectOffset.y)
                
            }
            else  if (node.name == "Button1") {
                
                node.position = self.button1AspectPosition
                node.position = CGPoint(x: node.position.x + button1AspectOffset.x, y: node.position.y + button1AspectOffset.y)
                
            }
            else  if (node.name == "Button2") {
                
                node.position = self.button2AspectPosition
                node.position = CGPoint(x: node.position.x + button2AspectOffset.x, y: node.position.y + button2AspectOffset.y)
                
            }
            else if (node.name == "WinCount1") {
                
                node.position = self.winCount1AspectPosition
                node.position = CGPoint(x: node.position.x + winCount1AspectOffset.x, y: node.position.y + winCount1AspectOffset.y)
                
            }
            else if (node.name == "WinCount2") {
                
                node.position = self.winCount2AspectPosition
                node.position = CGPoint(x: node.position.x + winCount2AspectOffset.x, y: node.position.y + winCount2AspectOffset.y)
                
            }
            
            
            else if (node.name == "BulletLabel1") {
                
                node.position = self.bulletLabel1AspectPosition
                node.position = CGPoint(x: node.position.x + bulletLabel1AspectOffset.x, y: node.position.y + bulletLabel1AspectOffset.y)
                
            }
            else if (node.name == "BulletIcon1") {
                
                node.position = self.bulletIcon1AspectPosition
                node.position = CGPoint(x: node.position.x + bulletIcon1AspectOffset.x, y: node.position.y + bulletIcon1AspectOffset.y)
                
            }
            else if (node.name == "BulletLabel2") {
                
                node.position = self.bulletLabel2AspectPosition
                node.position = CGPoint(x: node.position.x + bulletLabel2AspectOffset.x, y: node.position.y + bulletLabel2AspectOffset.y)
                
            }
            else if (node.name == "BulletIcon2") {
                
                node.position = self.bulletIcon2AspectPosition
                node.position = CGPoint(x: node.position.x + bulletIcon2AspectOffset.x, y: node.position.y + bulletIcon2AspectOffset.y)
                
            }
                
            else if (node.name == "HeartBox1") {
                
                node.position = self.heartBox1AspectPosition
                node.position = CGPoint(x: node.position.x + heartBox1AspectOffset.x, y: node.position.y + heartBox1AspectOffset.y)
                
            }
            else if (node.name == "Player1Heart1") {
                
                node.position = self.player1Heart1AspectPosition
                node.position = CGPoint(x: node.position.x + player1Heart1AspectOffset.x, y: node.position.y + player1Heart1AspectOffset.y)
                
            }
            else if (node.name == "Player1Heart2") {
                
                node.position = self.player1Heart2AspectPosition
                node.position = CGPoint(x: node.position.x + player1Heart2AspectOffset.x, y: node.position.y + player1Heart2AspectOffset.y)
                
            }
            else if (node.name == "Player1Heart3") {
                node.position = self.player1Heart3AspectPosition
                node.position = CGPoint(x: node.position.x + player1Heart3AspectOffset.x, y: node.position.y + player1Heart3AspectOffset.y)
                
                
            }
            else if (node.name == "Player1Heart4") {
                
                node.position = self.player1Heart4AspectPosition
                node.position = CGPoint(x: node.position.x + player1Heart4AspectOffset.x, y: node.position.y + player1Heart4AspectOffset.y)
                
            }
                
                
            else if (node.name == "HeartBox2") {
                
                node.position = self.heartBox2AspectPosition
                node.position = CGPoint(x: node.position.x + heartBox2AspectOffset.x, y: node.position.y + heartBox2AspectOffset.y)
                
            }
            else if (node.name == "Player2Heart1") {
                
                node.position = self.player2Heart1AspectPosition
                node.position = CGPoint(x: node.position.x + player2Heart1AspectOffset.x, y: node.position.y + player2Heart1AspectOffset.y)
                
            }
            else if (node.name == "Player2Heart2") {
                
                node.position = self.player2Heart2AspectPosition
                node.position = CGPoint(x: node.position.x + player2Heart2AspectOffset.x, y: node.position.y + player2Heart2AspectOffset.y)
                
            }
            else if (node.name == "Player2Heart3") {
                
                node.position = self.player2Heart3AspectPosition
                node.position = CGPoint(x: node.position.x + player2Heart3AspectOffset.x, y: node.position.y + player2Heart3AspectOffset.y)
                
            }
            else if (node.name == "Player2Heart4") {
                
                node.position = self.player2Heart4AspectPosition
                node.position = CGPoint(x: node.position.x + player2Heart4AspectOffset.x, y: node.position.y + player2Heart4AspectOffset.y)
                
            }

            else if (node.name == "KillCount") {
                
                node.position = self.killCountAspectPosition
                node.position = CGPoint(x: node.position.x + killCountAspectOffset.x, y: node.position.y + killCountAspectOffset.y)
                
            }
            else if (node.name == "KillCountBox") {
                
                node.position = self.killCountBoxAspectPosition
                node.position = CGPoint(x: node.position.x + killCountBoxAspectOffset.x, y: node.position.y + killCountBoxAspectOffset.y)
                
            }
            else if (node.name == "ScorePlayer1") {
                
                 node.position = self.scorePlayer1AspectPosition
                node.position = CGPoint(x: node.position.x + scorePlayer1AspectOffset.x, y: node.position.y + scorePlayer1AspectOffset.y)
                
            }
            else if (node.name == "ScorePlayer2") {
                
                node.position = self.scorePlayer2AspectPosition
                node.position = CGPoint(x: node.position.x + scorePlayer2AspectOffset.x, y: node.position.y + scorePlayer2AspectOffset.y)
                
            }
            else if (node.name == "HighScore") {
                
                node.position = self.highScoreAspectPosition
                node.position = CGPoint(x: node.position.x + highScoreAspectOffset.x, y: node.position.y + highScoreAspectOffset.y)
                
            }
            else if (node.name == "CombinedScore") {
                
                node.position = self.combinedScoreAspectPosition
                node.position = CGPoint(x: node.position.x + combinedScoreAspectOffset.x, y: node.position.y + combinedScoreAspectOffset.y)
                
            }
            else if (node.name == "PausePlaceholder") {
                node.position = self.pausePlaceholderAspectPosition
                node.position = CGPoint(x: node.position.x + pausePlaceholderAspectOffset.x, y: node.position.y + pausePlaceholderAspectOffset.y)
                self.pauseLocation  = node.position
                
            }
            else if (node.name == "ResumePlaceholder") {
                node.position = self.resumePlaceholderAspectPosition
                node.position = CGPoint(x: node.position.x + resumePlaceholderAspectOffset.x, y: node.position.y + resumePlaceholderAspectOffset.y)
                self.resumeLocation = node.position
                
            }
            
            
            else if (node.name == "MainMenuPlaceholder") {
                
                node.position = self.mainMenuPlaceholderAspectPosition
                node.position = CGPoint(x: node.position.x + mainMenuPlaceholderAspectOffset.x, y: node.position.y + mainMenuPlaceholderAspectOffset.y)
                self.mainMenuLocation = node.position
                
            }
            else if (node.name == "TransitionPlaceholder") {
                node.position = self.transitionPlaceholderAspectPosition
                node.position = CGPoint(x: node.position.x + transitionPlaceholderAspectOffset.x, y: node.position.y + transitionPlaceholderAspectOffset.y)
                self.transitionImageLocation = node.position
                
            }
            
            
            else if (node.name == "ControllerPlaceholder") {
                node.position = self.controllerPlaceholderAspectPosition
                node.position = CGPoint(x: node.position.x + controllerPlaceholderAspectOffset.x, y: node.position.y + controllerPlaceholderAspectOffset.y)
                self.controllerLocation  = node.position
                
            }
            else if (node.name == "TrackPromptPlaceholder") {
                node.position = self.trackPromptPlaceholderAspectPosition
                node.position = CGPoint(x: node.position.x + trackPromptPlaceholderAspectOffset.x, y: node.position.y + trackPromptPlaceholderAspectOffset.y)
                self.trackPromptLocation  = node.position
                
            }
            else if (node.name == "TrackCreditPlaceholder") {
                node.position = self.trackCreditPlaceholderAspectPosition
                node.position = CGPoint(x: node.position.x + trackCreditPlaceholderAspectOffset.x, y: node.position.y + trackCreditPlaceholderAspectOffset.y)
                self.trackCreditLocation  = node.position
                
            }
            
        }
        
        
        
    }
    
    func offsetCameraItemsOnPadWithAspectFit(){
        
        
     
            
        theCamera.position = CGPoint(x: theCamera.position.x, y: theCamera.position.y +  150)
        
        
        
        theCamera.enumerateChildNodes(withName: "*") {
            node, stop in
            
            if ( node.position.y < 0){
                
                node.position = CGPoint(x: node.position.x, y: node.position.y - 300)
                //print ("moving down \(node.name)")
            }
            
            
            
        }
        
        theCamera.enumerateChildNodes(withName: "*") {
            node, stop in

            if (node.name == "MainMenuPlaceholder") {
                
                self.mainMenuLocation = node.position
                
            }
            else if (node.name == "TransitionPlaceholder") {
                
                self.transitionImageLocation = node.position
                
            }
            else if (node.name == "ResumePlaceholder") {
                
                self.resumeLocation = node.position
                
            }
            else if (node.name == "PausePlaceholder") {
                
                self.pauseLocation  = node.position
                
            }
            else if (node.name == "ControllerPlaceholder") {
                
                self.controllerLocation  = node.position
                
            }
            else if (node.name == "TrackPromptPlaceholder") {
                
                self.trackPromptLocation  = node.position
                
            }
            else if (node.name == "TrackCreditPlaceholder") {
                
                self.trackCreditLocation  = node.position
                
            }
            
        }
        
        
        
        
        
    }
    
    
    
    func afterDidMoveToView(){
        
        
        playSound(soundLevelBegin)
        
        pauseLabel.isHidden = true;

        selectionBox?.isHidden = true;
        resumeGame?.isHidden = true;
        mainMenu?.isHidden = true;
        cameraIcon2?.isHidden = true;
        

        
            if ( singlePlayerGame == true) {
            
               
                hideControllerLabel()
                
                if ( player2NotInUse == false){
                    
                    
                    activePlayerInOnePlayerMode = thePlayer
                    enemyPlayerInOnePlayerMode = thePlayer2
                    setUpLoopsForOnePlayerMode()
                }
            
            } else if ( onePlayerModeBasedOnControllers == true) {
            
                // check who is still playing
                checkWhoIsPlayingInOnePlayerMode()
                setUpLoopsForOnePlayerMode()
                showControllerLabel()
                
                print("one Player ModeBasedOnControllers ")
                
                //player 2 might jump in so don't half goals
            
            }
       
        
        let wait:SKAction = SKAction.wait(forDuration: 1)
        let run:SKAction = SKAction.run {
            
            
            self.transitionInProgress = false;
            
        }
        
        let seq:SKAction = SKAction.sequence([wait, run])
        self.run(seq)
        
        
    }
    
    

    func pauseScene(){
        
       
        
        resumeGameSelected = true
        
        
        self.isPaused = true
        pauseLabel.isHidden = false
        pauseLabel.position = pauseLocation
        
        resumeGame?.isHidden = false
        resumeGame?.position = resumeLocation
        
        mainMenu?.isHidden = false
        mainMenu?.position = mainMenuLocation
        
        selectionBox?.isHidden = false
        selectionBox?.position = resumeLocation
        
        //v1.2
        
       
        
        trackPromptLabel.isHidden = false
        trackPromptLabel.position = trackPromptLocation
            
        
        //v1.2
        
        
        
        trackCreditLabel.isHidden = false
        trackCreditLabel.position = trackCreditLocation
        
        
        //v1.3
        if ( pauseTint != nil){
            
            pauseTint?.isHidden = false
            pauseTint?.position = CGPoint.zero
        }
        
        
    }
    
    func unpauseScene(){
        
        self.isPaused = false
        pauseLabel.isHidden = true
       
        
        resumeGame?.isHidden = true
        mainMenu?.isHidden = true
        selectionBox?.isHidden = true
        trackPromptLabel.isHidden = true  //v1.2
        trackCreditLabel.isHidden = true //v1.2
        
        playSound(soundUnpaused)
        
        //v1.3
        if ( pauseTint != nil){
            
            pauseTint?.isHidden = true
            
        }
       
        
    }
    
    func selectResumeGame(){
        
        resumeGameSelected = true
        selectionBox?.position = (resumeGame?.position)!
    }
    
    func selectMainMenu(){
        
        resumeGameSelected = false
        selectionBox?.position = (mainMenu?.position)!
    }
    
    func menuSelectionMade(){
        
        if (resumeGameSelected == true ){
            
            print("unpause")
            
            unpauseScene()
            
        } else {
            
            print("unpause")
            
            goBackToMainMenu()
        }
        
        
    }
    
    func goBackToMainMenu(){
        
        
        
        
        cleanUpScene()
        
        
        
        
        let sksNameToLoad:String = "Home"
        var fullSKSNameToLoad:String = sksNameToLoad
        
        
        if (UIDevice.current.userInterfaceIdiom == .pad ){
            
            if let _ = GameScene(fileNamed: sksNameToLoad + "Pad") {
                
                fullSKSNameToLoad = sksNameToLoad + "Pad"
                
            }
        } else  if (UIDevice.current.userInterfaceIdiom == .phone ){
            
            if let _ = GameScene(fileNamed: sksNameToLoad + "Phone") {
                
                fullSKSNameToLoad = sksNameToLoad + "Phone"
                
            }
        }
        
        
        
        
        if let scene = Home(fileNamed: fullSKSNameToLoad) {
            
           
                scene.propertyListData = sksNameToLoad
                scene.scaleMode = .aspectFill
            
       
            
            self.view?.presentScene(scene, transition: SKTransition.fade(with: SKColor.white, duration: 2) )
            
        }
        
        
        
    }
    
    func cleanUpScene(){
        
        if ( bgSoundPlaying == true){
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "StopBackgroundSound"), object: self)
            
            bgSoundPlaying = false
            
        }
        
        
        
        if let recognizers = self.view!.gestureRecognizers {
            
            for recognizer in recognizers {
                
                self.view!.removeGestureRecognizer(recognizer as UIGestureRecognizer)
                
            }
            
        }
        
        
        //self.removeAllActions()
        
        for node in self.children {
            
            node.removeAllActions()
            
            
        }
        
        for controller in GCController.controllers(){
            
            
            if (controller.extendedGamepad != nil ){
                
                controller.extendedGamepad?.valueChangedHandler = nil
                
                
            } else if (controller.gamepad != nil){
                
                
                controller.gamepad?.valueChangedHandler = nil
                
                
            }             
            
        }
        
        
        let wait:SKAction = SKAction.wait(forDuration: 1.98)
        let run:SKAction = SKAction.run {
            
            self.removeAllChildren()
        }
        
        self.run( SKAction.sequence( [wait, run] ))

        
        
        
    }
    
    
    func parsePropertyList()  {
        
    

        let path = Bundle.main.path(forResource: "LevelData", ofType: "plist")
        
        let dict:NSDictionary = NSDictionary(contentsOfFile: path!)!
        
        //v1.2
        if (dict.object(forKey: "MP3List") != nil) {
            
            if (dict.object(forKey: "MP3List") is [String]){
                
                mp3List = dict.object(forKey: "MP3List") as! [String]
                
                
            }
            
        }
        
        
        if (dict.object(forKey: levelsName) != nil) {
            
            if let levelData = dict.object(forKey: levelsName) as? [AnyObject] {
                
                var counter:Int = 1
                
                for theDictionary in levelData {
                    
                    if (currentLevel == counter) {
                        
                        // this is the current level we are interested in
                        
                        if (theDictionary is [String : AnyObject]) {
                            
                            if let currentDictionary:[String : AnyObject] = theDictionary as? [String : AnyObject] {
                                
                                
                                for (theKey, theValue) in currentDictionary {
                                    
                                    if (theKey.lowercased() == "CameraBetweenPlayersX".lowercased() ) {
                                        
                                        
                                        if (theValue is Bool){
                                            
                                            cameraBetweenPlayersX = theValue as! Bool
                                            
                                            
                                        }
                                        
                                    } else if (theKey.lowercased() == "CameraBetweenPlayersY".lowercased() ) {
                                        
                                        
                                        if (theValue is Bool){
                                            
                                            cameraBetweenPlayersY = theValue as! Bool
                                            
                                            
                                        }
                                        
                                    } else if (theKey.lowercased() == "CameraFollowsPlayerX".lowercased()) {
                                        
                                        
                                        if (theValue is Bool){
                                            
                                            cameraFollowsPlayerX = theValue as! Bool
                                            
                                            
                                        }
                                        
                                    } else if (theKey.lowercased() == "CameraXLimitRight".lowercased()) {
                                        
                                        
                                        if (theValue is CGFloat){
                                            
                                            cameraXLimitRight = theValue as! CGFloat
                                            
                                            restrictCameraX = true
                                        }
                                        
                                    }else if (theKey.lowercased() == "CameraXLimitLeft".lowercased()) {
                                        
                                        
                                        if (theValue is CGFloat){
                                            
                                            cameraXLimitLeft = theValue as! CGFloat
                                            
                                            restrictCameraX = true
                                        }
                                        
                                    }  else if (theKey.lowercased() == "CameraFollowsPlayerY".lowercased()) {
                                        
                                        
                                        if (theValue is Bool){
                                            
                                            cameraFollowsPlayerY = theValue as! Bool
                                            
                                            
                                        }
                                        
                                    } else if (theKey.lowercased() == "CameraOffsetX".lowercased()) {
                                        
                                        
                                        if (theValue is CGFloat){
                                            
                                            cameraOffsetX = theValue as! CGFloat
                                            
                                            
                                        }
                                        
                                    } else if (theKey.lowercased() == "CameraOffsetY".lowercased()) {
                                        
                                        
                                        if (theValue is CGFloat){
                                            
                                            cameraOffsetY = theValue as! CGFloat
                                            
                                            
                                        }
                                        
                                    }  else if (theKey == "RespawnFollowsPlayerX") {
                                        
                                        
                                        if (theValue is Bool){
                                            
                                            respawnFollowsPlayerX = theValue as! Bool
                                            
                                            
                                        }
                                        
                                    }  else if (theKey == "RespawnFollowsPlayerY") {
                                        
                                        
                                        if (theValue is Bool){
                                            
                                            respawnFollowsPlayerY = theValue as! Bool
                                            
                                            
                                        }
                                        
                                    } else if (theKey == "ResetPlatformTime") {
                                        
                                        
                                        if (theValue is TimeInterval){
                                            
                                            resetPlatformTime = theValue as! TimeInterval
                                            
                                            
                                        }
                                        
                                    }    else if (theKey == "MP3Loop") {
                                        
                                        
                                        if (theValue is String){
                                            
                                            
                                            
                                            let theFileName:String  = theValue as! String
                                            let theFileNameWithNoMp3:String  = theFileName.replacingOccurrences(of: ".mp3", with: "", options:String.CompareOptions.caseInsensitive , range: nil)
                                            
                                            
                                            
                                            let dictToSend: [String: String] = ["fileToPlay":theFileNameWithNoMp3 ]
                                            
                                            NotificationCenter.default.post(name: Notification.Name(rawValue: "PlayBackgroundSound"), object: self, userInfo:dictToSend)
                                            
                                            bgSoundPlaying = true
                                            
                                        }
                                        
                                        
                                    }
                                    else if (theKey.lowercased() == "PlayMp3FromList".lowercased()) {
                                        //v1.2
                                        
                                        if ( bgSoundPlaying == true){
                                            
                                            self.stopMusicByGoingLeft()
                                        }
                                        
                                        if (theValue is Int){
                                            
                                            trackNum = theValue as! Int
                                            
                                            if ( mp3List.count > 0 ){
                                                
                                                
                                                if ( trackNum >= mp3List.count){
                                                    
                                                    trackNum = 0
                                                }
                                                
                                                if ( lastChosenTrack != -1){
                                                    print("user chose a different track, playing this level before, keep playing it.  ")
                                                    trackNum = lastChosenTrack
                                                }
                                                
                                                
                                                
                                                let theFileName:String  = mp3List[trackNum]
                                                let theFileNameWithNoMp3:String  = theFileName.replacingOccurrences(of: ".mp3", with: "", options:String.CompareOptions.caseInsensitive , range: nil)
                                                
                                                
                                                
                                                let dictToSend: [String: String] = ["fileToPlay":theFileNameWithNoMp3 ]
                                                
                                                NotificationCenter.default.post(name: Notification.Name(rawValue: "PlayBackgroundSound"), object: self, userInfo:dictToSend)
                                                
                                                bgSoundPlaying = true
                                                
                                                
                                                
                                                
                                            }
                                            
                                        }
                                        
                                        
                                    }
                                    else if (theKey == "AutoAdvanceLevelTime") {
                                        
                                        
                                        if (theValue is TimeInterval){
                                            
                                            autoAdvanceLevelTime = theValue as! TimeInterval
                                            
                                            startAutoAdvance()
                                            
                                        }
                                        
                                    }
                                    else if (theKey == "SoundLevelBegin") {
                                        
                                        
                                        if (theValue is String){
                                            
                                            soundLevelBegin = theValue as! String
                                            
                                            
                                        }
                                        
                                    }
                                    else if (theKey == "StealHeartsSound") {
                                        
                                        
                                        if (theValue is String){
                                            
                                            stealHeartsSound = theValue as! String
                                            
                                            
                                        }
                                        
                                    }
                                    else if (theKey == "SoundLevelFail") {
                                        
                                        
                                        if (theValue is String){
                                            
                                            soundLevelFail = theValue as! String
                                            
                                            
                                        }
                                        
                                    }
                                    else if (theKey == "SoundLevelSucceed") {
                                        
                                        
                                        if (theValue is String){
                                            
                                            soundLevelSucceed = theValue as! String
                                            
                                            
                                        }
                                        
                                    }
                                    else if (theKey == "SoundPlayer1Win") {
                                        
                                        
                                        if (theValue is String){
                                            
                                            soundPlayer1Win = theValue as! String
                                            
                                            
                                        }
                                        
                                    }
                                    else if (theKey == "SoundPlayer2Win") {
                                        
                                        
                                        if (theValue is String){
                                            
                                            soundPlayer2Win = theValue as! String
                                            
                                            
                                        }
                                        
                                    }
                                    else if (theKey == "SoundUnpaused") {
                                        
                                        
                                        if (theValue is String){
                                            
                                            soundUnpaused = theValue as! String
                                            
                                            
                                        }
                                        
                                    } else if (theKey == "DisableContinue") {
                                        
                                        
                                        if (theValue is Bool){
                                            
                                            disableContinue = theValue as! Bool
                                            
                                        }
                                        
                                    }
                                      
                                    else if (theKey == "UnlimitedBullets") {
                                        
                                        
                                        if (theValue is Bool){
                                            
                                            unlimitedBullets = theValue as! Bool
                                            
                                        }
                                        
                                    }
                                    else if (theKey == "MaxDistanceBetweenPlayersX") {
                                        
                                        
                                        if (theValue is CGFloat){
                                            
                                            maxDistanceBetweenPlayersX = theValue as! CGFloat
                                            
                                        }
                                        
                                    }
                                    else if (theKey == "MaxDistanceBetweenPlayersY") {
                                        
                                        
                                        if (theValue is CGFloat){
                                            
                                            maxDistanceBetweenPlayersY = theValue as! CGFloat
                                            
                                        }
                                        
                                    }
                                    else if (theKey == "PlayerVersusPlayer") {
                                        
                                        
                                        if (theValue is Bool){
                                            
                                            playerVersusPlayer = theValue as! Bool
                                            
                                        }
                                        
                                    }
                                    else if (theKey == "StealHearts") {
                                        
                                        
                                        if (theValue is Bool){
                                            
                                            stealHearts = theValue as! Bool
                                            
                                        }
                                        
                                    }
                                    else if (theKey == "KeepExistingBulletCount") {
                                        
                                        
                                        if (theValue is Bool){
                                            
                                            keepExistingBulletCount = theValue as! Bool
                                            
                                        }
                                        
                                    }
                                    
                                    else if (theKey == "BoundaryFlip") {
                                        
                                        
                                        if (theValue is Bool){
                                            
                                            boundaryFlip = theValue as! Bool
                                            
                                        }
                                        
                                    }
                                    else if (theKey.lowercased() == "BoundaryFlipEnemies".lowercased()) {
                                        
                                        
                                        if (theValue is Bool){
                                            
                                            boundaryFlipEnemies = theValue as! Bool
                                            
                                        }
                                        
                                    }
                                    else if (theKey.lowercased() == "BoundaryFlipPlayers".lowercased()) {
                                        
                                        
                                        if (theValue is Bool){
                                            
                                            boundaryFlipPlayers = theValue as! Bool
                                            
                                        }
                                        
                                    }
                                        
                                    else if (theKey == "LevelResetsHearts") {
                                        
                                        
                                        if (theValue is Bool){
                                            
                                            levelResetsHearts = theValue as! Bool
                                            
                                        }
                                        
                                    }
                                    
                                    else if (theKey == "RefreshLevelOnDeath") {
                                        
                                        
                                        if (theValue is Bool){
                                            
                                            refreshLevelOnDeath = theValue as! Bool
                                            
                                           
                                            
                                        }
                                        
                                    }
                                    
                                    else if (theKey == "ResetScore") {
                                        
                                        
                                        if (theValue is Bool ){
                                            
                                            resetScore =  theValue as! Bool
                                            
                                        }
                                        
                                    }
                                    else if (theKey == "CombineScoresToPassLevel") {
                                        
                                        
                                        if (theValue is Bool ){
                                            
                                            combineScoresToPassLevel =  theValue as! Bool
                                            
                                        }
                                        
                                    }
                                    else if (theKey == "PassLevelWithScoreOver") {
                                        
                                        
                                        if (theValue is Int){
                                            
                                            
                                            passLevelWithScoreOver =  theValue as! Int
                                            passLevelWithScore = true
                                            
                                        }
                                        
                                    }
                                    else if (theKey == "PassLevelWithEnemiesKilled") {
                                        
                                        
                                        if (theValue is Int){
                                            
                                            
                                            passLevelWithEnemiesKilledOver =  theValue as! Int
                                            passLevelWithEnemiesKilled = true
                                            
                                        }
                                        
                                    }
                                    else if (theKey.lowercased() == "MinimumEnemiesToPass".lowercased()) {
                                        
                                        
                                        if (theValue is Int){
                                            
                                            
                                            minimumEnemiesToPass =  theValue as! Int
                                            
                                            
                                        }
                                        
                                    }
                                    else if (theKey == "GoalMultipliedByLevelsPassed") {
                                        
                                        
                                        if (theValue is Bool){
                                            
                                            
                                            goalMultipliedByLevelsPassed =  theValue as! Bool
                                            
                                            
                                        }
                                        
                                    }
                                    
                                    else if (theKey == "HalfGoalsToPassForOnePlayer") {
                                        
                                        
                                        if (theValue is Bool ){
                                            
                                            halfGoalsToPassForOnePlayer =  theValue as! Bool

                                        }
                                        
                                    }
                                    else if (theKey == "BulletsToStart") {
                                        
                                        
                                        if (theValue is Int){
                                            
                                            bulletsToStart = theValue as! Int
                                            
                                            
                                        }
                                        
                                    }
                                    else if (theKey == "MaxBulletsToStart") {
                                        
                                        
                                        if (theValue is Int){
                                            
                                            maxBulletsToStart = theValue as! Int
                                            
                                            
                                        }
                                        
                                    }
                                    else if (theKey == "PlayerOnPlayerBounceThreshold") {
                                        
                                        
                                        if (theValue is CGFloat){
                                            
                                            playerOnPlayerBounceThreshold = theValue as! CGFloat
                                            
                                            
                                        }
                                        
                                    }
                                    else if (theKey == "PlayerOnPlayerImpact") {
                                        
                                        
                                        if (theValue is CGFloat){
                                            
                                            playerOnPlayerImpact = theValue as! CGFloat
                                            
                                            
                                        }
                                        
                                    }
                                        
                                    else if (theKey == "Player1Ammo") {
                                        
                                        if let ammoDict:Dictionary = theValue as? [String : AnyObject ] {
                                            
                                            for (ammoKey, ammoValue) in ammoDict{
                                            
                                                if (ammoKey == "AwardsHowMuch"){
                                                    
                                                    if (ammoValue is Int){
                                                        
                                                        p1AmmoAwardsHowMuch = ammoValue as! Int
                                                        
                                                    }
                                                    
                                                    
                                                    
                                                } else if (ammoKey == "SpawnsHowOften"){
                                                    
                                                    if (ammoValue is Int){
                                                        
                                                        p1AmmoSpawnsHowOften = UInt32( ammoValue as! Int )
                                                        
                                                    }
                                                    
                                                    
                                                } else if (ammoKey == "SpawnsAtRandomTime"){
                                                    
                                                    if (ammoValue is Bool){
                                                        
                                                        p1AmmoSpawnsAtRandomTime = ammoValue as! Bool
                                                        
                                                    }
                                                    
                                                    
                                                } else if (ammoKey == "AwardsToBothPlayers"){
                                                    
                                                    if (ammoValue is Bool){
                                                        
                                                        p1AwardsToBothPlayers = ammoValue as! Bool
                                                        
                                                    }
                                                    
                                                    
                                                }  else if (ammoKey == "OnlyAllowOneAtATime"){
                                                    
                                                    if (ammoValue is Bool){
                                                        
                                                        p1OnlyAllowOneAtATime = ammoValue as! Bool
                                                        
                                                    }
                                                    
                                                    
                                                }  else if (ammoKey == "SoundAmmoCollect"){
                                                    
                                                    if (ammoValue is String){
                                                        
                                                        p1SoundAmmoCollect = ammoValue as! String
                                                        
                                                    }
                                                    
                                                    
                                                } else if (ammoKey == "SoundAmmoDrop"){
                                                    
                                                    if (ammoValue is String){
                                                        
                                                        p1SoundAmmoDrop = ammoValue as! String
                                                        
                                                    }
                                                    
                                                    
                                                }  else if (ammoKey == "MinimumTimeBetweenSpawns"){
                                                    
                                                    if (ammoValue is TimeInterval){
                                                        
                                                        p1AmmoMinimumTimeBetweenSpawns = ammoValue as! TimeInterval
                                                        
                                                    }
                                                    
                                                    
                                                }


                                                
                                            }
                                            
                                        }
                                        
                                        
                                        
                                    }
                                    else if (theKey == "Player2Ammo") {
                                        
                                        if let ammoDict:Dictionary = theValue as? [String : AnyObject ] {
                                            
                                            for (ammoKey, ammoValue) in ammoDict{
                                                
                                                if (ammoKey == "AwardsHowMuch"){
                                                    
                                                    if (ammoValue is Int){
                                                        
                                                        p2AmmoAwardsHowMuch = ammoValue as! Int
                                                        
                                                    }
                                                    
                                                    
                                                    
                                                } else if (ammoKey == "SpawnsHowOften"){
                                                    
                                                    if (ammoValue is Int){
                                                        
                                                        p2AmmoSpawnsHowOften = UInt32( ammoValue as! Int )
                                                        
                                                    }
                                                    
                                                    
                                                } else if (ammoKey == "SpawnsAtRandomTime"){
                                                    
                                                    if (ammoValue is Bool){
                                                        
                                                        p2AmmoSpawnsAtRandomTime = ammoValue as! Bool
                                                        
                                                    }
                                                    
                                                    
                                                } else if (ammoKey == "AwardsToBothPlayers"){
                                                    
                                                    if (ammoValue is Bool){
                                                        
                                                        p2AwardsToBothPlayers = ammoValue as! Bool
                                                        
                                                    }
                                                    
                                                    
                                                } else if (ammoKey == "OnlyAllowOneAtATime"){
                                                    
                                                    if (ammoValue is Bool){
                                                        
                                                        p2OnlyAllowOneAtATime = ammoValue as! Bool
                                                        
                                                    }
                                                    
                                                    
                                                } else if (ammoKey == "SoundAmmoCollect"){
                                                    
                                                    if (ammoValue is String){
                                                        
                                                        p2SoundAmmoCollect = ammoValue as! String
                                                        
                                                    }
                                                    
                                                    
                                                } else if (ammoKey == "SoundAmmoDrop"){
                                                    
                                                    if (ammoValue is String){
                                                        
                                                        p2SoundAmmoDrop = ammoValue as! String
                                                        
                                                    }
                                                    
                                                    
                                                }else if (ammoKey == "MinimumTimeBetweenSpawns"){
                                                    
                                                    if (ammoValue is TimeInterval){
                                                        
                                                        p2AmmoMinimumTimeBetweenSpawns = ammoValue as! TimeInterval
                                                        
                                                    }
                                                    
                                                    
                                                }
                                                
                                                
                                                
                                            }
                                            
                                        }
                                        
                                        
                                        
                                    }
                                        //v1.4
                                    else if (theKey == "Portals") {
                                        
                                        if let portalDict = theValue as? [String : AnyObject] {
                                            
                                            
                                            for (keyName, valueName) in portalDict {
                                                
                                                
                                                if let portalDictionary:Dictionary = valueName as? [String : AnyObject ] {
                                                    
                                                    setUpPortalWithDict(portalDictionary, nameOfPortal: keyName )
                                                    
                                                }
                                                
                                                
                                            }
                                            
                                        }
                                        
                                        
                                    }
                                    else if (theKey == "SpringBoards") {
                                        
                                        if let springDict = theValue as? [String : AnyObject] {
                                            
                                            
                                            for (keyName, valueName) in springDict {
                                                
                                                
                                                if let springDictionary:Dictionary = valueName as? [String : AnyObject ] {
                                                    
                                                    setUpSpringBoardWithDict(springDictionary, nameOfSpring: keyName )
                                                    
                                                }
                                                
                                                
                                            }
                                            
                                        }
                                        
                                        
                                    }
                                    
                                    else if (theKey == "Enemies") {
                                        
                                        if let enemyArray = theValue as? Array<AnyObject> {
                                            
                                            
                                            for item in enemyArray {
                                                
                                                
                                                if let enemyDictionary:Dictionary = item as? [String : AnyObject ] {
                                                    
                                                    createEnemyLoop(enemyDictionary)
                                                    
                                                }
                                                
                                                
                                            }
                                            
                                        } else if let enemyDict = theValue as? [String : AnyObject] {
                                            
                                            
                                            for (_, valueName) in enemyDict {
                                                
                                                
                                                if let enemyDictionary:Dictionary = valueName as? [String : AnyObject ] {
                                                    
                                                    createEnemyLoop(enemyDictionary)
                                                    
                                                }
                                                
                                                
                                            }
                                            
                                        }

                                        
                                    }
                                    
                                    
                                }
                                
                            }
                        }
                        
                        break
                        
                    }
                    
                    counter += 1
                }
            }
        }
        
  
    }
    
    func setUpSpringBoardWithDict (_ springDictionary:[String : AnyObject ], nameOfSpring:String) {
        
        
        self.enumerateChildNodes(withName: "//*") {
            node, stop in
            
            
            if ( node.name == nameOfSpring){
                
                if let someSpring :SpringBoard = node as? SpringBoard{
                    
                    someSpring.setUpWithDict (springDictionary)
                    
                    
                }
                
            }
            
            
        }
        
    }

    
    //v1.4
    func setUpPortalWithDict(_ portalDictionary:[String : AnyObject ], nameOfPortal:String){
        
        
        
        
        
        var theLevelToLoad:Int = 1
        var theLevelsName:String = "Levels"
        var requiresScoreOver:Int = -1
        var requiresEnemiesKilledOver:Int = -1
        var showLevelPassedImage:Bool = false
        var addsToLevelsPassed:Bool = false
        var nodeToMovePlayerTo:String = ""
        var nodeToMoveCameraTo:String = ""
        var oneTimeUse:Bool = false
        var movesBothPlayers:Bool = false
        var textureAfterUse:String = ""
        
        for (theKey, theValue) in portalDictionary {
            
            if (theKey == "LevelToLoad"){
                
                if (theValue is Int){
                    
                    theLevelToLoad = theValue as! Int
                    
                }
                
            }
            else if (theKey == "Levels"){
                
                if (theValue is String){
                    
                    theLevelsName = theValue as! String
                    
                }
                
            }
            else if (theKey == "RequiresScoreOver"){
                
                if (theValue is Int){
                    
                    requiresScoreOver = theValue as! Int
                    
                }
                
            }
            else if (theKey == "RequiresEnemiesKilledOver"){
                
                if (theValue is Int){
                    
                    requiresEnemiesKilledOver = theValue as! Int
                    
                }
                
            }
            else if (theKey == "ShowLevelPassedImage"){
                
                if (theValue is Bool){
                    
                    showLevelPassedImage = theValue as! Bool
                    
                }
                
            }
            else if (theKey == "AddsToLevelsPassed"){
                
                if (theValue is Bool){
                    
                    addsToLevelsPassed = theValue as! Bool
                    
                }
                
            }
            else if (theKey == "NodeToMovePlayerTo"){
                
                if (theValue is String){
                    
                    nodeToMovePlayerTo = theValue as! String
                    
                }
                
            }
            else if (theKey == "TextureAfterUse"){
                
                if (theValue is String){
                    
                    textureAfterUse = theValue as! String
                    
                }
                
            }
            else if (theKey == "NodeToMoveCameraTo"){
                
                if (theValue is String){
                    
                    nodeToMoveCameraTo = theValue as! String
                    
                }
                
            }
            else if (theKey == "OneTimeUse"){
                
                if (theValue is Bool){
                    
                    oneTimeUse = theValue as! Bool
                    
                }
                
            }
            else if (theKey == "MovesBothPlayers"){
                
                if (theValue is Bool){
                    
                    movesBothPlayers = theValue as! Bool
                    
                }
                
            }
            
        }
        
        
        
        self.enumerateChildNodes(withName: "//*") {
            node, stop in
            
            
            if ( node.name == nameOfPortal){
                
                if let somePortal :Portal = node as? Portal{
                    
                    somePortal.goesToSpecificLevel = true
                    somePortal.levelsName = theLevelsName
                    somePortal.levelToLoad = theLevelToLoad
                    somePortal.requiresEnemiesKilledOver = requiresEnemiesKilledOver
                    somePortal.requiresScoreOver = requiresScoreOver
                    somePortal.showLevelPassedImage = showLevelPassedImage
                    somePortal.addsToLevelsPassed = addsToLevelsPassed
                    somePortal.textureAfterUse = textureAfterUse
                    
                    if ( nodeToMovePlayerTo != ""){
                        
                        somePortal.goesToSpecificLevel = false
                        somePortal.movesPlayerToNode = true
                        somePortal.nodeToMovePlayerTo = nodeToMovePlayerTo
                        somePortal.oneTimeUse = oneTimeUse
                        somePortal.nodeToMoveCameraTo = nodeToMoveCameraTo
                        somePortal.movesBothPlayers = movesBothPlayers
                    }
                    
                }
                
            }
        }
        
    }
    

    
    
    
    func createEnemyLoop(_ enemyDictionary:[String : AnyObject ]){
        
        var initialDelay:TimeInterval = 0
        var totalToSpawn:Int = 0
        var spawnFrequency:TimeInterval = 0
        
        for (theKey, theValue) in enemyDictionary {
            
            if (theKey == "InitialDelay"){
                
               
                if (theValue is TimeInterval){
                    
                    initialDelay = theValue as! TimeInterval
                    
                }
                
            }
            if (theKey == "TotalToSpawn"){
                
                
                if (theValue is Int){
                    
                    totalToSpawn =  theValue as! Int
                    
                }
                
            }
            
            if (theKey == "SpawnFrequency"){
                
                if (theValue is TimeInterval){
                    
                    spawnFrequency = theValue as! TimeInterval
                    
                }
                
            }
            
        }
        
        let wait:SKAction = SKAction.wait(forDuration: initialDelay)
        let run:SKAction = SKAction.run {
            
            self.createEnemy(enemyDictionary, theTotal:totalToSpawn, waitTime: spawnFrequency )
        }
        
        self.run( SKAction.sequence( [wait, run] ))
        
        
        
        
        
        
        
        
        
        
    }
    func createEnemy(_ enemyDictionary:[String : AnyObject ], theTotal:Int, waitTime:TimeInterval ){
        
        //vars for the loop controlling respawning
        
        var totalLeftToSpawn:Int = theTotal
        
        var respawnForever:Bool = false
        
        if (theTotal == 0){
            
            respawnForever = true
        }
        
        //// for the enemy being spawned
        
        var spawnNode:String = ""
        var reviveTime:TimeInterval = 0
        var reviveCount:Int = 0
        var speedAfterRevive:CGFloat = 0
        var theSpeed:CGFloat = 0
        var radiusDivider:CGFloat = 2
        var depth:CGFloat = 0
        var atlasName:String = ""
        var baseFrame:String = ""
        var treatLikeBullet:Bool = false
        var explodeAsBullet:Bool = false //1.62
        var walkFrames = [String]()
        var deadFrames = [String]()
        var hurtFrames = [String]()
        var angryWalkFrames = [String]()
        var shootFrames = [String]()
        var angryShootFrames = [String]()
        var attackFrames = [String]()
        var angryAttackFrames = [String]()
        
        var hurtFPS:TimeInterval = 10
        var shootFPS:TimeInterval = 10
        var angryShootFPS:TimeInterval = 10
        var angryWalkFPS:TimeInterval = 30
        var deadFPS:TimeInterval = 10
        var walkFPS:TimeInterval = 10
        var attackFPS:TimeInterval = 10
        var angryAttackFPS:TimeInterval = 20
        
        var spawnOffset:CGPoint = CGPoint.zero
        
        var moveUpAndDownAmount:CGFloat = 20
        var moveUpAndDownTime:TimeInterval = 0.5
        var moveUpAndDown:Bool = false
        var bodyType:String = "Alpha"
        var bodyOffset:CGPoint = CGPoint.zero
        var bodySize:CGSize = CGSize(width: 50, height: 50)
        var xScale:CGFloat = 1
        var blinkToDeath:Bool = false
        var jumpOnToKill:Bool = false
        var jumpThreshold:CGFloat = 50
        var score:Int = 0
        var jumpOnBounceBack:CGFloat = 500
        var soundEnemyHurt:String = ""
        var soundEnemyDie:String = ""
        var soundEnemyAttack:String = ""
        var soundEnemyEnter:String = ""
        var theName:String = "SomeEnemy"
        var removeOutsideBoundary:Bool = false
        var allowsRotation:Bool = false
        var affectedByGravity:Bool = true
        
        
        
        for (theKey, theValue) in enemyDictionary {
            
            
            if (theKey == "ReviveTime"){
                
                if (theValue is TimeInterval){
                    
                    reviveTime = theValue as! TimeInterval
                    
                }
                
            } else  if (theKey == "MoveUpAndDownAmount"){
                
                if (theValue is CGFloat){
                    
                    moveUpAndDown = true
                    moveUpAndDownAmount = theValue as! CGFloat
                    
                }
                
            }
            else  if (theKey == "MoveUpAndDownTime"){
                
                if (theValue is TimeInterval){
                    
                    moveUpAndDown = true
                    
                    moveUpAndDownTime = theValue as! TimeInterval
                    
                }
                
            }
            else if (theKey == "HurtFPS"){
                
                if (theValue is TimeInterval){
                    
                    hurtFPS = theValue as! TimeInterval
                    
                }
                
            }
            else if (theKey == "ShootFPS"){
                
                if (theValue is TimeInterval){
                    
                    shootFPS = theValue as! TimeInterval
                    
                }
                
            }
            else if (theKey == "WalkFPS"){
                
                if (theValue is TimeInterval){
                    
                    walkFPS = theValue as! TimeInterval
                    
                }
                
            }else if (theKey == "AttackFPS"){
                
                if (theValue is TimeInterval){
                    
                    attackFPS = theValue as! TimeInterval
                    
                }
                
            }else if (theKey == "AngryAttackFPS"){
                
                if (theValue is TimeInterval){
                    
                    angryAttackFPS = theValue as! TimeInterval
                    
                }
                
            }else if (theKey == "AngryWalkFPS"){
                
                if (theValue is TimeInterval){
                    
                    angryWalkFPS = theValue as! TimeInterval
                    
                }
                
            }else if (theKey == "AngryShootFPS"){
                
                if (theValue is TimeInterval){
                    
                    angryShootFPS = theValue as! TimeInterval
                    
                }
                
            }else if (theKey == "DeadFPS"){
                
                if (theValue is TimeInterval){
                    
                    deadFPS = theValue as! TimeInterval
                    
                }
                
            }
            else if (theKey == "SpeedAfterRevive"){
                
                if (theValue is CGFloat){
                    
                    speedAfterRevive = theValue as! CGFloat
                    
                }
                
            }
            else if (theKey == "ReviveCount"){
                
                if (theValue is Int){
                    
                    reviveCount = theValue as! Int
                    
                }
                
            }
            else if (theKey == "Score"){
                
                if (theValue is Int){
                    
                    score  = theValue as! Int
                    
                }
                
            }
            else if (theKey == "Name"){
                
                if (theValue is String){
                    
                    theName = theValue as! String
                    
                }
                
            }
            else if (theKey == "SpawnOffset"){
                
                if (theValue is String){
                    
                    spawnOffset = CGPointFromString( theValue as! String )
                    
                }
                
            }
            else if (theKey == "BaseFrame"){
                
                if (theValue is String){
                    
                    baseFrame = theValue as! String
                    
                }
                
            }
            else if (theKey == "JumpThreshold"){
                
                if (theValue is CGFloat){
                    
                    jumpThreshold = theValue as! CGFloat
                    
                }
                
            }
            else if (theKey == "Depth"){
                
                if (theValue is CGFloat){
                    
                    depth = theValue as! CGFloat
                    
                }
                
            }
            else if (theKey == "BlinkToDeath"){
                
                if (theValue is Bool ){
                    
                    blinkToDeath = theValue as! Bool
                    
                }
                
            }
            else if (theKey == "TreatLikeBullet"){
                
                if (theValue is Bool ){
                    
                    
                    
                    treatLikeBullet = theValue as! Bool
                    
                }
                
            }
                //1.62
            else if (theKey == "ExplodeAsBullet"){
                
                if (theValue is Bool){
                    
                    explodeAsBullet =  theValue as! Bool
                    
                }
                
            }

            else if (theKey == "JumpOnToKill"){
                
                if (theValue is Bool ){
                    
                    jumpOnToKill = theValue as! Bool
                    
                }
                
            }
            else if (theKey == "AllowsRotation"){
                
                if (theValue is Bool ){
                    
                    allowsRotation = theValue as! Bool
                    
                }
                
            }
            else if (theKey == "AffectedByGravity"){
                
                if (theValue is Bool ){
                    
                    affectedByGravity = theValue as! Bool
                    
                }
                
            }
            else if (theKey == "JumpOnBounceBack"){
                
                if (theValue is CGFloat){
                    
                    jumpOnBounceBack = theValue as! CGFloat
                    
                }
                
            }
            else if (theKey == "Speed"){
                
                if (theValue is CGFloat){
                    
                    theSpeed = theValue as! CGFloat
                    
                }
                
            }
            else if (theKey == "RadiusDivider"){
                
                
                if (theValue is CGFloat){
                    
                    radiusDivider = theValue as! CGFloat
                    
                }
                
            }
            else if (theKey == "XScale"){
                
                
                if (theValue is CGFloat){
                    
                    xScale = theValue as! CGFloat
                    
                }
                
            }
            else if (theKey == "SpawnNode"){
                
                if (theValue is String){
                    
                    spawnNode = theValue as! String
                    
                    
                }
                
            }
            else if (theKey == "Atlas"){
                
                if (theValue is String){
                    
                    atlasName =  theValue as! String
                    
                }
                
            }
            else if (theKey == "BodyType"){
                
                if (theValue is String){
                    
                    bodyType =  theValue as! String
                    
                }
                
            }
            else if (theKey == "BodyOffset"){
                
                if (theValue is String){
                    
                    bodyOffset =  CGPointFromString(  theValue as! String )
                    
                }
                
            }
            else if (theKey == "BodySize"){
                
                if (theValue is String){
                    
                    bodySize =  CGSizeFromString(  theValue as! String )
                    
                }
                
            }
            else if (theKey == "WalkFrames"){
                
                if (theValue is [String]){
                    
                    walkFrames =  theValue as! [String]
                    
                }
                
            }
            else if (theKey == "AttackFrames"){
                
                if (theValue is [String]){
                    
                    attackFrames =  theValue as! [String]
                    
                }
                
            }
            else if (theKey == "AngryAttackFrames"){
                
                if (theValue is [String]){
                    
                    angryAttackFrames =  theValue as! [String]
                    
                }
                
            }
            else if (theKey == "ShootFrames"){
                
                if (theValue is [String]){
                    
                    shootFrames =  theValue as! [String]
                    
                }
                
            }
            else if (theKey == "AngryWalkFrames"){
                
                if (theValue is [String]){
                    
                    angryWalkFrames =  theValue as! [String]
                    
                }
                
            }
            else if (theKey == "AngryShootFrames"){
                
                if (theValue is [String]){
                    
                    angryShootFrames =  theValue as! [String]
                    
                }
                
            }
            else if (theKey == "DeadFrames"){
                
                if (theValue is [String]){
                    
                    deadFrames =  theValue as! [String]
                    
                }
                
            }
            else if (theKey == "HurtFrames"){
                
                if (theValue is [String]){
                    
                    hurtFrames =  theValue as! [String]
                    
                }
                
            }
            else if (theKey == "SoundEnemyHurt"){
                
                if (theValue is String){
                    
                    soundEnemyHurt =  theValue as! String
                    
                }
                
            }
            else if (theKey == "SoundEnemyDie"){
                
                if (theValue is String){
                    
                    soundEnemyDie =  theValue as! String
                    
                }
                
            }
            else if (theKey == "SoundEnemyAttack"){
                
                if (theValue is String){
                    
                    soundEnemyAttack =  theValue as! String
                    
                }
                
            }
            else if (theKey == "SoundEnemyEnter"){
                
                if (theValue is String){
                    
                    soundEnemyEnter =  theValue as! String
                    
                }
                
            } else if (theKey == "RemoveOutsideBoundary"){
                
                if (theValue is Bool){
                    
                    removeOutsideBoundary =  theValue as! Bool
                    
                }
                
            }
            
            
        }
        
        
        
        
        self.enumerateChildNodes(withName: "//*") {
            node, stop in
            
            
            if ( node.name == spawnNode){
                
                
                
                if let spawnSprite :Enemy = node as? Enemy{
                    
                    if (spawnSprite.isDown == false && spawnSprite.isDead == false){
                        
                        if (spawnSprite.position.x < self.theCamera.position.x + (960 + 250) && spawnSprite.position.x > self.theCamera.position.x - (960 + 250) ){
                            
                            
                            
                            totalLeftToSpawn = totalLeftToSpawn - 1
                            
                            let newEnemy:Enemy = Enemy.init(image: baseFrame, theBodyType:bodyType, theBodyOffset:bodyOffset, radiusDivider:radiusDivider, bodySize: bodySize)
                            newEnemy.name = theName
                            newEnemy.zPosition = depth
                            newEnemy.position = spawnSprite.position
                            
                            if ( spawnOffset != CGPoint.zero){
                                
                                if (spawnSprite.xScale == 1){
                                    
                                    newEnemy.position = CGPoint(x: newEnemy.position.x + spawnOffset.x, y: newEnemy.position.y + spawnOffset.y)
                                    
                                } else if (spawnSprite.xScale == -1){
                                    
                                    newEnemy.position = CGPoint(x: newEnemy.position.x - spawnOffset.x, y: newEnemy.position.y + spawnOffset.y)
                                    
                                }
                                
                            }
                            
                            
                            newEnemy.theSpeed = theSpeed
                            
                            if (newEnemy.theSpeed <= spawnSprite.theSpeed){
                                
                                newEnemy.theSpeed = spawnSprite.theSpeed +  newEnemy.theSpeed
                            }
                            
                            newEnemy.reviveTime = reviveTime
                            newEnemy.speedAfterRevive = speedAfterRevive
                            newEnemy.reviveCount = reviveCount
                            newEnemy.atlasName = atlasName
                            newEnemy.walkFrames = walkFrames
                            newEnemy.shootFrames = shootFrames
                            newEnemy.angryWalkFrames = angryWalkFrames
                            newEnemy.angryShootFrames = angryShootFrames
                            newEnemy.angryAttackFrames = angryAttackFrames
                            newEnemy.attackFrames = attackFrames
                            newEnemy.deadFrames = deadFrames
                            newEnemy.hurtFrames = hurtFrames
                            newEnemy.blinkToDeath = blinkToDeath
                            newEnemy.jumpOnToKill = jumpOnToKill
                            newEnemy.jumpThreshold = jumpThreshold
                            newEnemy.jumpOnBounceBack = jumpOnBounceBack
                            newEnemy.soundEnemyAttack = soundEnemyAttack
                            newEnemy.soundEnemyDie = soundEnemyDie
                            newEnemy.soundEnemyEnter = soundEnemyEnter
                            newEnemy.soundEnemyHurt = soundEnemyHurt
                            newEnemy.walkFPS = walkFPS
                            newEnemy.angryWalkFPS = angryWalkFPS
                            newEnemy.angryShootFPS = angryShootFPS
                            newEnemy.attackFPS = attackFPS
                            newEnemy.angryAttackFPS = angryAttackFPS
                            newEnemy.deadFPS = deadFPS
                            newEnemy.hurtFPS = hurtFPS
                            newEnemy.shootFPS = shootFPS
                            newEnemy.xScale = xScale
                            newEnemy.score = score
                            newEnemy.moveUpAndDown = moveUpAndDown
                            newEnemy.moveUpAndDownAmount = moveUpAndDownAmount
                            newEnemy.moveUpAndDownTime = moveUpAndDownTime
                            newEnemy.treatLikeBullet = treatLikeBullet
                            newEnemy.explodeAsBullet = explodeAsBullet //1.62
                            newEnemy.removeOutsideBoundary = removeOutsideBoundary
                            newEnemy.physicsBody?.allowsRotation = allowsRotation
                            newEnemy.physicsBody?.affectedByGravity = affectedByGravity
                            
                            
                            
                            newEnemy.makeAdjustments()
                            newEnemy.setUpAnimations()
                            newEnemy.preloadSounds()
                            
                            
                            newEnemy.xScale = spawnSprite.xScale
                            
                            
                            
                            spawnSprite.enemyShoot()
                            
                            newEnemy.playSound(newEnemy.soundEnemyEnter)
                            
                            
                            
                            self.addChild(newEnemy)
                        }
                    }
                    
                }  else {
                    
                    //v1.1
                    //let convertedLocation:CGPoint = self.convertPoint(location, fromNode: theCamera)
                    
                    var enemySpawnPoint:CGPoint = CGPoint.zero
                    var spawnPointInCamera:CGPoint = CGPoint.zero
                    
                    //look in the camera for the  placeholder spawn point
                    
                    var spawnPointFound:Bool = false
                    var spawnPointFoundInCamera:Bool = false
                    
                    self.theCamera.enumerateChildNodes(withName: "*") {
                        node, stop in
                        
                        
                        
                        if ( node.name == spawnNode){
                            
                            //print("found spawn point in camera")
                            
                            spawnPointFound = true
                            spawnPointFoundInCamera = true
                            spawnPointInCamera = node.position
                            
                            stop.pointee = true
                        }
                        
                        
                        
                    }
                    
                    if ( spawnPointFound == true ){
                        
                        //convert it
                        enemySpawnPoint = self.convert(spawnPointInCamera, from: self.theCamera)
                        
                        
                    } else {
                        //look in the scene for the  placeholder spawn point
                        
                        self.enumerateChildNodes(withName: "*") {
                            node, stop in
                            
                            if ( node.name == spawnNode){
                                
                                spawnPointFound = true
                                enemySpawnPoint = node.position
                            }
                            
                            
                            
                        }
                        
                    }
                    
                    
                    
                    if (spawnPointFoundInCamera == true || ( spawnPointFound == true && enemySpawnPoint.x < self.theCamera.position.x + (self.halfScreenWidth + 50) && enemySpawnPoint.x > self.theCamera.position.x - (self.halfScreenWidth + 50)) ){
                        
                        
                        
                        
                        totalLeftToSpawn = totalLeftToSpawn - 1
                        
                        let newEnemy:Enemy = Enemy.init(image: baseFrame, theBodyType:bodyType, theBodyOffset:bodyOffset, radiusDivider:radiusDivider, bodySize: bodySize)
                        newEnemy.name = theName
                        newEnemy.zPosition = depth
                        newEnemy.position = enemySpawnPoint
                        
                        newEnemy.theSpeed = theSpeed
                        newEnemy.reviveTime = reviveTime
                        newEnemy.speedAfterRevive = speedAfterRevive
                        newEnemy.reviveCount = reviveCount
                        newEnemy.atlasName = atlasName
                        newEnemy.walkFrames = walkFrames
                        newEnemy.shootFrames = shootFrames
                        newEnemy.angryWalkFrames = angryWalkFrames
                        newEnemy.deadFrames = deadFrames
                        newEnemy.hurtFrames = hurtFrames
                        newEnemy.angryShootFrames = angryShootFrames
                        newEnemy.angryAttackFrames = angryAttackFrames
                        newEnemy.attackFrames = attackFrames
                        newEnemy.blinkToDeath = blinkToDeath
                        newEnemy.jumpOnToKill = jumpOnToKill
                        newEnemy.jumpThreshold = jumpThreshold
                        newEnemy.jumpOnBounceBack = jumpOnBounceBack
                        newEnemy.soundEnemyAttack = soundEnemyAttack
                        newEnemy.soundEnemyDie = soundEnemyDie
                        newEnemy.soundEnemyEnter = soundEnemyEnter
                        newEnemy.soundEnemyHurt = soundEnemyHurt
                        newEnemy.walkFPS = walkFPS
                        newEnemy.angryWalkFPS = angryWalkFPS
                        newEnemy.deadFPS = deadFPS
                        newEnemy.hurtFPS = hurtFPS
                        newEnemy.shootFPS = shootFPS
                        newEnemy.angryShootFPS = angryShootFPS
                        newEnemy.attackFPS = attackFPS
                        newEnemy.angryAttackFPS = angryAttackFPS
                        
                        
                        
                        //1.62 bug fix
                        
                        if ( spawnNode == "Player1"){
                            
                            
                            
                            if ( self.thePlayer.xScale == 1){
                                
                                newEnemy.xScale = -1
                                
                            } else {
                                
                                newEnemy.xScale = 1
                                
                            }
                            
                        } else if ( spawnNode == "Player2"){
                            
                            if ( self.thePlayer2.xScale == 1){
                                
                                newEnemy.xScale = -1
                                
                            } else {
                                
                                newEnemy.xScale = 1
                            }
                            
                        } else {
                            
                            newEnemy.xScale = xScale
                            
                        }
                        
                        
                        
                        if ( spawnOffset != CGPoint.zero){
                            
                            if (newEnemy.xScale == 1){
                                
                                newEnemy.position = CGPoint(x:newEnemy.position.x - spawnOffset.x,y: newEnemy.position.y + spawnOffset.y)
                                
                            } else if (newEnemy.xScale == -1){
                                
                                newEnemy.position = CGPoint(x:newEnemy.position.x + spawnOffset.x, y:newEnemy.position.y + spawnOffset.y)
                                
                            }
                            
                        }
                        
                        //end 1.62 bug fix
                        
                        
                        newEnemy.score = score
                        newEnemy.moveUpAndDown = moveUpAndDown
                        newEnemy.moveUpAndDownAmount = moveUpAndDownAmount
                        newEnemy.moveUpAndDownTime = moveUpAndDownTime
                        newEnemy.removeOutsideBoundary = removeOutsideBoundary
                        newEnemy.treatLikeBullet = treatLikeBullet
                        newEnemy.explodeAsBullet = explodeAsBullet //1.62
                        newEnemy.physicsBody?.allowsRotation = allowsRotation
                        newEnemy.physicsBody?.affectedByGravity = affectedByGravity
                        newEnemy.makeAdjustments()
                        newEnemy.setUpAnimations()
                        newEnemy.preloadSounds()
                        
                        
                        newEnemy.playSound(newEnemy.soundEnemyEnter)
                        
                        //v1.1
                        //for some reason we have to add a millisecond delay before adding this enemy
                        // after it was made possible to put spawn locations inside of the camera
                        let wait:SKAction = SKAction.wait(forDuration: 1/60)
                        let run:SKAction = SKAction.run{
                            
                            self.addChild(newEnemy)
                        }
                        self.run(SKAction.sequence([wait, run ]))
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                }
                
                
                
                
                
            }
            
            
        }
        
        
        if ( respawnForever == true ){
            
            
            let wait:SKAction = SKAction.wait(forDuration: waitTime)
            let run:SKAction = SKAction.run {
                
                self.createEnemy(enemyDictionary, theTotal:0, waitTime: waitTime )
            }
            
            self.run( SKAction.sequence( [wait, run] ))
            
            
        } else if (totalLeftToSpawn > 0){
            
            let wait:SKAction = SKAction.wait(forDuration: waitTime)
            let run:SKAction = SKAction.run {
                
                self.createEnemy(enemyDictionary, theTotal:totalLeftToSpawn, waitTime: waitTime )
            }
            
            self.run( SKAction.sequence( [wait, run] ))
            
        }
        
        
    }
    
    func shoot(_ fromWho:Player) {
        
       
 
        
        if ( fromWho == thePlayer && thePlayer.playerIsDead == false){
            
            if (bulletCountPlayer1 > 0 || unlimitedBullets == true) {
            

                bulletCountPlayer1 = bulletCountPlayer1 - 1
        
                defaults.set(bulletCountPlayer1, forKey: "BulletCountPlayer1")
        
                bulletLabel1.text = String(bulletCountPlayer1)
        
                if ( bulletCountPlayer1 <= 0) {
            
                    bulletLabel1.text = "0"
                }
                
                thePlayer.playSound(thePlayer.soundShoot)
                
                thePlayer.shoot()
                
                
                let wait:SKAction = SKAction.wait(  forDuration: TimeInterval (fromWho.weaponDelay) )
                let run:SKAction = SKAction.run {
                    
                    let newBullet:Bullet = Bullet.init()
                    
                    newBullet.weaponRotationSpeed = fromWho.weaponRotationSpeed
                    newBullet.soundBulletImpact = fromWho.soundBulletImpact
                    newBullet.theSpeed = CGFloat(fromWho.weaponSpeed)
                    newBullet.whoFired = "Player1"
                    newBullet.setUpBulletWithName(fromWho.weaponImage )
                    
                    
                    
                    //newBullet.texture = SKTexture(imageNamed: fromWho.weaponImage )
                    
                    self.addChild(newBullet)
                    
                    if (fromWho.xScale == 1) {
                        
                        newBullet.position = CGPoint(x: fromWho.position.x + fromWho.weaponOffset.x, y: fromWho.position.y + fromWho.weaponOffset.y) //adjust as needed
                        
                    } else {
                        
                        newBullet.position = CGPoint(x: fromWho.position.x -  fromWho.weaponOffset.x, y: fromWho.position.y + fromWho.weaponOffset.y) //adjust as needed
                        
                    }
                    
                    newBullet.xScale = fromWho.xScale
                    
                    
                    
                }
                self.run(SKAction.sequence( [wait, run ]))
                
                
                
                
            } else {
                
                fromWho.playSound(fromWho.soundNoAmmo)
            }
            
            
        }  else if ( fromWho == thePlayer2 && thePlayer2.playerIsDead == false){
    
            
             if (bulletCountPlayer2 > 0 || unlimitedBullets == true) {

            
            
                bulletCountPlayer2 = bulletCountPlayer2 - 1
                
                defaults.set(bulletCountPlayer2, forKey: "BulletCountPlayer2")
                
                bulletLabel2.text = String(bulletCountPlayer2)
                
                if ( bulletCountPlayer2 <= 0) {
                    
                    bulletLabel2.text = "0"
                }
                
                
                
                thePlayer2.playSound(thePlayer2.soundShoot)
                thePlayer2.shoot()
                
                
                let wait:SKAction = SKAction.wait(  forDuration: TimeInterval (fromWho.weaponDelay) )
                let run:SKAction = SKAction.run {
                    
                    let newBullet:Bullet = Bullet.init()
                    
                    newBullet.weaponRotationSpeed = fromWho.weaponRotationSpeed
                    newBullet.theSpeed = CGFloat(fromWho.weaponSpeed)
                    newBullet.soundBulletImpact = fromWho.soundBulletImpact
                    newBullet.whoFired = "Player2"
                    newBullet.setUpBulletWithName(fromWho.weaponImage )
                    
                    
                    
                    //newBullet.texture = SKTexture(imageNamed: fromWho.weaponImage )
                    
                    self.addChild(newBullet)
                    
                    if (fromWho.xScale == 1) {
                        
                        newBullet.position = CGPoint(x: fromWho.position.x + fromWho.weaponOffset.x, y: fromWho.position.y + fromWho.weaponOffset.y) //adjust as needed
                        
                    } else {
                        
                        newBullet.position = CGPoint(x: fromWho.position.x -  fromWho.weaponOffset.x, y: fromWho.position.y + fromWho.weaponOffset.y) //adjust as needed
                        
                    }
                    
                    newBullet.xScale = fromWho.xScale
                    
                    
                    
                }
                self.run(SKAction.sequence( [wait, run ]))
                
                
                
             } else {
                
                fromWho.playSound(fromWho.soundNoAmmo)
            }
    
    
            
        }
    

    }
    
  
    

    func pressedShoot( _ playerBeingControlled:Player ){
        
        if ( transitionInProgress == false){
        
        if ( playerBeingControlled == thePlayer){
            
            if (thePlayer.canFireAgain == true){
                
                shoot(thePlayer)
            }
            
            
            
        } else if ( playerBeingControlled == thePlayer2){
            
            if (thePlayer2.canFireAgain == true){
                
                shoot(thePlayer2)
            }
            
            
        }
        }
        
        
    }

    func tappedMenu(){
        
        if (self.isPaused == true){
            
            unpauseScene()
            
        } else {
            
           pauseScene()
        }
        
        
        
    }
    
    
    

    func pressedJump( _ playerBeingControlled:Player ){
        
        if ( transitionInProgress == false){
        
        if(playerBeingControlled.onPole == false){
            
            if (playerBeingControlled.isJumping == false) {
                
                playerBeingControlled.jump()
                
                /*
                
                if (playerBeingControlled.currentDirection == .Up || playerBeingControlled.currentDirection == .None ){
                    
                    playerBeingControlled.jump()
                    
                } else if (playerBeingControlled.xScale == 1){
                        
                        playerBeingControlled.currentDirection = .Right
                        playerBeingControlled.jump()
                        
                } else {
                        
                        playerBeingControlled.currentDirection = .Left
                        playerBeingControlled.jump()
                        
                }
                */
                
                
            } else {
                
                playerBeingControlled.doubleJump()
                
            }
            
        }
        }
    }
    
    func swipedRight(){
        
        thePlayer.goRight()
        
    }
    
    func swipedLeft(){
        
        thePlayer.goLeft()
        
    }
    
    func swipedUp(){
        
        
        if (thePlayer.onPole == false){
        
            if (thePlayer.isJumping == false) {
                
                thePlayer.jump()
                
            } else {
                
                thePlayer.doubleJump()
                
            }
            
            
            
        } else {
            
            thePlayer.goUpPole()
            
        }
        
    }
    
    func swipedDown(){
        
        
         if (thePlayer.onPole == false){
        
            thePlayer.stopJump()
            
         } else {
            
            thePlayer.goDownPole()
            
        }
        
    }
    
    
    
   
    
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        if (transitionInProgress == false){
            
            thePlayer.update()
            thePlayer2.update()
            
            
            if ( respawnFollowsPlayerX == true){
                
                if ( respawnPointPlayer1 != CGPoint.zero) {
                    //at non-zero means respawnPointPlayer1 is in use
                    respawnPointPlayer1 = CGPoint(x: thePlayer.position.x, y: respawnPointPlayer1.y)
                }
                if ( respawnPointPlayer2 != CGPoint.zero) {
                    //at non-zero means respawnPointPlayer2 is in use
                    respawnPointPlayer2 = CGPoint(x: thePlayer2.position.x, y: respawnPointPlayer2.y)
                }
                
            }
            if ( respawnFollowsPlayerY == true){
                
                if ( respawnPointPlayer1 != CGPoint.zero) {
                    //at non-zero means respawnPointPlayer1 is in use
                    respawnPointPlayer1 = CGPoint(x: respawnPointPlayer1.x, y: thePlayer.position.y)
                }
                if ( respawnPointPlayer2 != CGPoint.zero) {
                    //at non-zero means respawnPointPlayer2 is in use
                    respawnPointPlayer2 = CGPoint(x: respawnPointPlayer2.x, y: thePlayer2.position.y)
                }
                
            }
            
            
            if (playerVersusPlayer == true) {
                
                if (onePlayerModeBasedOnControllers == true || singlePlayerGame == true){
                    
                    if ( (activePlayerInOnePlayerMode?.position.x)! > (enemyPlayerInOnePlayerMode?.position.x)!){
                        
                        enemyPlayerInOnePlayerMode?.xScale = 1
                        
                    } else {
                        
                        enemyPlayerInOnePlayerMode?.xScale = -1
                        
                    }
                    
                }
                
            }
            
            
            
            //DEAL WITH CAMERA ON X
            
            if ( cameraBetweenPlayersX == true && cameraDonePanningToNewFollower == true){
                
                var doParallax:Bool = true
                
                let xDiff:CGFloat = abs( thePlayer.position.x - thePlayer2.position.x  ) / 2
                
                if (thePlayer.position.x < thePlayer2.position.x) {
                    
                    theCamera.position = CGPoint( x: thePlayer.position.x + xDiff + cameraOffsetX, y: theCamera.position.y )
                    
                    
                } else {
                    
                    theCamera.position = CGPoint( x: thePlayer2.position.x + xDiff + cameraOffsetX, y: theCamera.position.y )
                    
                }
                
                
                adjustCamForAspectIssue()
                
                
                
                if ( restrictCameraX == true ){
                    
                    if ( theCamera.position.x <= cameraXLimitLeft){
                        
                        
                        theCamera.position = CGPoint(x: cameraXLimitLeft, y: theCamera.position.y)
                        
                        doParallax = false
                    } else if ( theCamera.position.x >= cameraXLimitRight){
                        
                        theCamera.position = CGPoint(x: cameraXLimitRight, y: theCamera.position.y)
                        doParallax = false
                    }
                    
                }
                
                if (cameraLastPosition != CGPoint.zero &&  doParallax == true) {
                    
                    let xDifference:CGFloat = theCamera.position.x - cameraLastPosition.x
                    
                    self.enumerateChildNodes(withName: "//*") {
                        node, stop in
                        
                        if (node.name == "Parallax1") {
                            
                            node.position = CGPoint(x: node.position.x + (xDifference * 0.3), y: node.position.y)
                            
                        } else if (node.name == "Parallax2") {
                            
                            node.position = CGPoint(x: node.position.x + (xDifference * 0.4), y: node.position.y)
                            
                        } else if (node.name == "Parallax3") {
                            
                            node.position = CGPoint(x: node.position.x + (xDifference * 0.5), y: node.position.y)
                            
                        }
                        
                        
                        
                    }
                    
                    
                }
                cameraLastPosition = theCamera.position
                
                
            } else if ( cameraFollowsPlayerX == true && cameraDonePanningToNewFollower == true){
                
                var doParallax:Bool = true
                
                
                if (  abs(thePlayer.position.x - thePlayer2.position.x ) < maxDistanceBetweenPlayersX  || player2NotInUse == true || player1OutOfGame == true || player2OutOfGame == true){
                    
                    
                    theCamera.position = CGPoint(x: (thePlayerCameraFollows?.position.x)! + cameraOffsetX, y: theCamera.position.y)
                    
                    
                    adjustCamForAspectIssue()
                    
                    
                    if ( restrictCameraX == true ){
                        
                        if ( theCamera.position.x <= cameraXLimitLeft){
                            
                            theCamera.position = CGPoint(x: cameraXLimitLeft, y: theCamera.position.y)
                            doParallax = false
                            
                        } else if ( theCamera.position.x >= cameraXLimitRight){
                            
                            theCamera.position = CGPoint(x: cameraXLimitRight, y: theCamera.position.y)
                            doParallax = false
                        }
                        
                    }
                    
                    
                    if (playerLastPosition != CGPoint.zero && doParallax == true) {
                        
                        let xDiff:CGFloat = thePlayerCameraFollows!.position.x - playerLastPosition.x
                        
                        self.enumerateChildNodes(withName: "//*") {
                            node, stop in
                            
                            if (node.name == "Parallax1") {
                                
                                node.position = CGPoint(x: node.position.x + (xDiff * 0.3), y: node.position.y)
                                
                            } else if (node.name == "Parallax2") {
                                
                                node.position = CGPoint(x: node.position.x + (xDiff * 0.4), y: node.position.y)
                                
                            } else if (node.name == "Parallax3") {
                                
                                node.position = CGPoint(x: node.position.x + (xDiff * 0.5), y: node.position.y)
                                
                            }
                            
                            
                            
                        }
                        
                        
                    }
                    
                    playerLastPosition = thePlayerCameraFollows!.position
                    
                }
                
                
                
            }
            
            //DEAL WITH CAMERA ON Y
            
            if ( cameraBetweenPlayersY == true && cameraDonePanningToNewFollower == true){
                
                
                let yDiff:CGFloat = abs( thePlayer.position.y - thePlayer2.position.y  ) / 2
                
                if (thePlayer.position.y < thePlayer2.position.y) {
                    
                    theCamera.position = CGPoint( x: theCamera.position.x, y: thePlayer.position.y + yDiff  + cameraOffsetY)
                    
                    
                } else {
                    
                    theCamera.position = CGPoint(  x: theCamera.position.x, y: thePlayer2.position.y + yDiff + cameraOffsetY )
                    
                }
                
                if (cameraLastPosition != CGPoint.zero) {
                    
                    let yDifference:CGFloat = theCamera.position.y - cameraLastPosition.y
                    
                    self.enumerateChildNodes(withName: "//*") {
                        node, stop in
                        
                        if (node.name == "Parallax1") {
                            
                            node.position = CGPoint(x: node.position.x, y: node.position.y  + (yDifference * 0.3))
                            
                        } else if (node.name == "Parallax2") {
                            
                            node.position = CGPoint(x: node.position.x , y: node.position.y + (yDifference * 0.4))
                            
                        } else if (node.name == "Parallax3") {
                            
                            node.position = CGPoint(x: node.position.x, y: node.position.y  + (yDifference * 0.5))
                            
                        }
                        
                        
                        
                    }
                    
                    
                }
                cameraLastPosition = theCamera.position
                
                
            } else if ( cameraFollowsPlayerY == true && cameraDonePanningToNewFollower == true){
                
                
                
                
                if (  abs(thePlayer.position.y - thePlayer2.position.y ) < maxDistanceBetweenPlayersY  || player2NotInUse == true || player1OutOfGame == true || player2OutOfGame == true){
                    
                    
                    theCamera.position = CGPoint(  x: theCamera.position.x, y: (thePlayerCameraFollows?.position.y)! + cameraOffsetY)
                    
                    if (playerLastPosition != CGPoint.zero) {
                        
                        let yDiff:CGFloat = thePlayerCameraFollows!.position.y - playerLastPosition.y
                        
                        self.enumerateChildNodes(withName: "//*") {
                            node, stop in
                            
                            if (node.name == "Parallax1") {
                                
                                node.position = CGPoint(x: node.position.x , y: node.position.y + (yDiff * 0.3))
                                
                            } else if (node.name == "Parallax2") {
                                
                                node.position = CGPoint(x: node.position.x , y: node.position.y + (yDiff * 0.4))
                                
                            } else if (node.name == "Parallax3") {
                                
                                node.position = CGPoint(x: node.position.x , y: node.position.y + (yDiff * 0.5))
                                
                            }
                            
                            
                            
                        }
                        
                        
                    }
                    
                    playerLastPosition = thePlayerCameraFollows!.position
                    
                }
                
                
                
            }
            
            
            for node in self.children {
                
                
                if (node is Player ){
                    
                    if let somePlayer = node as? Player {
                        
                        //v1.1
                        
                        if (boundaryFlip == true || boundaryFlipPlayers == true){
                            
                            checkBoundary(somePlayer)
                        }
                        
                    }
                    
                    
                }
                else if (node is Ammo ){
                    
                    if let someAmmo = node as? Ammo {
                        
                       
                        
                        if (someAmmo.position.y < 0){
                            
                            if ( someAmmo.name == "Player1Ammo" ){
                                
                                self.hasPlayer1AmmoAlready = false
                                
                            } else  if ( someAmmo.name == "Player2Ammo" ){
                                
                                self.hasPlayer2AmmoAlready = false
                            }
                            
                            someAmmo.removeFromParent()
                        }
                        
                    }
                    
                    
                }
                else if (node is Coin ){
                    
                    if let someCoin = node as? Coin {
                        
                       
                        if (someCoin.position.y < 0){
                            someCoin.removeFromParent()
                        }
                        
                    }
                    
                    
                }
                    
                else if (node is MovingPole){
                    
                    if let theMovingPole = node as? MovingPole {
                        
                        theMovingPole.update()
                        
                    }
                    
                    
                }
                else if (node is MovingPlatform){
                    
                    if let theMovingPlatform = node as? MovingPlatform {
                        
                        theMovingPlatform.update()
                        
                        
                    }
                    
                    
                }
                    
                    
                 else if (node is Bullet){
                    
                    if let theBullet:Bullet = node as? Bullet {
                        
                        theBullet.update()
                        
                        if (UIDevice.current.userInterfaceIdiom == .pad && isMadeForPad == false && scene?.scaleMode == .aspectFill){
                            
                            let rect:CGRect = CGRect(x: theCamera.position.x - ((1920 / 2) - camPadAspectAdjustment), y: theCamera.position.y - (1080 / 2), width: 1920, height: 1080)
                            
                            if ( rect.contains(theBullet.position)) {
                                
                                
                                
                            } else {
                                
                                theBullet.removeFromParent()
                                
                            }
                            
                            
                        } else {
                            
                            let rect:CGRect = CGRect(x: theCamera.position.x - (1920 / 2), y: theCamera.position.y - (1080 / 2), width: 1920, height: 1080)
                            
                            if ( rect.contains(theBullet.position)) {
                                
                                
                                
                            } else {
                                
                                theBullet.removeFromParent()
                                
                            }
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                } else if (node is Enemy){
                    
                    if let theEnemy:Enemy = node as? Enemy {
                        
                        theEnemy.update()
                        
                        
                        
                        checkBoundaryForEnemy(theEnemy)
                        
                        
                        if (theEnemy.position.y < 0 && cameraBetweenPlayersY == false && cameraFollowsPlayerY == false){
                            
                            
                            theEnemy.removeFromParent()
                        }
                        
                    }
                    
                    
                }
                
                
            }
            
            
            
            
            //////////
            
            
            if (currentMovingPole != nil) {
                
                
                
                if (thePlayer.currentDirection == .up || thePlayer.currentDirection == .down ){
                    
                    
                    thePlayer.position = CGPoint( x: thePlayer.position.x + (currentMovingPole?.moveAmount)!, y: thePlayer.position.y)
                    
                }
                
                
            }
            
            if (currentMovingPlatform != nil) {
                
                
                thePlayer.position = CGPoint( x: thePlayer.position.x + (currentMovingPlatform?.moveAmountX)!, y: thePlayer.position.y  + (currentMovingPlatform?.moveAmountY)!)
                
            }
            
            
            //////PLAYER 2
            
            if (currentMovingPole2 != nil) {
                
                if (thePlayer2.currentDirection == .up || thePlayer2.currentDirection == .down ){
                    
                    thePlayer2.position = CGPoint( x: thePlayer2.position.x + (currentMovingPole2?.moveAmount)!, y: thePlayer2.position.y)
                }
            }
            
            if (currentMovingPlatform2 != nil) {
                
                
                thePlayer2.position = CGPoint( x: thePlayer2.position.x + (currentMovingPlatform2?.moveAmountX)!, y: thePlayer2.position.y  + (currentMovingPlatform2?.moveAmountY)!)
                
            }
            
            
            
            
            //
            
        }//closes transitionInProgress
        
        
    }
    
    func adjustCamForAspectIssue(){
        
        if (UIDevice.current.userInterfaceIdiom == .pad && isMadeForPad == false && scene?.scaleMode == .aspectFill){
            
            //Xcode 7.1.1 changed the behavior of offsetting, so don't do this
            
           theCamera.position = CGPoint(x: theCamera.position.x - camPadAspectAdjustment, y: theCamera.position.y)
        }
        
    }
    
    
    func checkBoundary(_ node:SKNode){
        
       
        if (UIDevice.current.userInterfaceIdiom == .pad && isMadeForPad == false && scene?.scaleMode == .aspectFill){
            
            
            if (node.position.x <  ((theCamera.position.x  - halfScreenWidth) - 65) + camPadAspectAdjustment) {
                
                node.position = CGPoint( x: ((theCamera.position.x  + halfScreenWidth) + 50) + camPadAspectAdjustment, y: node.position.y)
                
            } else if (node.position.x > ((theCamera.position.x  + halfScreenWidth) + 51) + camPadAspectAdjustment ){
                
                node.position = CGPoint( x: ((theCamera.position.x - halfScreenWidth) - 64) + camPadAspectAdjustment, y: node.position.y)
                
            }
            
            
            
        } else {
            
            
            if (node.position.x <  (theCamera.position.x - halfScreenWidth) - 35){
                
                node.position = CGPoint(x: (theCamera.position.x + halfScreenWidth) + 20, y: node.position.y)
                
            } else if (node.position.x > (theCamera.position.x + halfScreenWidth) + 21){
                
                node.position = CGPoint(x: (theCamera.position.x - halfScreenWidth) - 34, y: node.position.y)
                
            }
            
        }
        
        
        
    }
    func checkBoundaryForEnemy(_ theEnemy:Enemy){
        
        if (UIDevice.current.userInterfaceIdiom == .pad && isMadeForPad == false && scene?.scaleMode == .aspectFill){
            
            
            if (theEnemy.position.x <  ((theCamera.position.x - halfScreenWidth) - 35) + camPadAspectAdjustment ){
                
                if ( theEnemy.removeOutsideBoundary == true){
                    
                    theEnemy.removeFromParent()
                    
                    
                } else if ( boundaryFlip == true || boundaryFlipEnemies == true){ //v1.1
                    
                    theEnemy.position = CGPoint(x: ((theCamera.position.x + halfScreenWidth) + 20) + camPadAspectAdjustment, y: theEnemy.position.y)
                }
                
            } else if (theEnemy.position.x > ((theCamera.position.x + halfScreenWidth) + 21) + camPadAspectAdjustment ){
                
                if ( theEnemy.removeOutsideBoundary == true){
                    
                    theEnemy.removeFromParent()
                    
                    
                } else if ( boundaryFlip == true || boundaryFlipEnemies == true){ //v1.1
                    
                    theEnemy.position = CGPoint( x: ((theCamera.position.x - halfScreenWidth) - 34) + camPadAspectAdjustment, y: theEnemy.position.y)
                }
                
            }
            
            
        
            
            
            
        } else {
            
        
        if (theEnemy.position.x <  (theCamera.position.x - halfScreenWidth) - 35){
            
            if ( theEnemy.removeOutsideBoundary == true){
                
                theEnemy.removeFromParent()
                
                
            } else if ( boundaryFlip == true || boundaryFlipEnemies == true){ //v1.1
                
                theEnemy.position = CGPoint(x: (theCamera.position.x + halfScreenWidth) + 20, y: theEnemy.position.y)
            }
            
        } else if (theEnemy.position.x > (theCamera.position.x + halfScreenWidth) + 21){
            
            if ( theEnemy.removeOutsideBoundary == true){
                
                theEnemy.removeFromParent()
                
                
            } else if ( boundaryFlip == true || boundaryFlipEnemies == true){ //v1.1
                
                theEnemy.position = CGPoint(x: (theCamera.position.x - halfScreenWidth) - 34, y: theEnemy.position.y)
            }
            
        }
        
        
        }
        
        
        
    }
    
       
        
    
}












