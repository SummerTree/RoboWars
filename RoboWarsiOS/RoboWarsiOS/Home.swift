//
//  Home.swift
//
//
//  Created by Justin Dike 2 on 10/6/15.
//  Copyright © 2015 CartoonSmart. All rights reserved.
//

import SpriteKit
import GameController
import AVFoundation

import GameKit
import StoreKit


class Home: SKScene, GKGameCenterControllerDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    
    var enableGameCenter:Bool = false
    var canSelect:Bool = true 
    var selectionOrder = [Button]()
    var selectedIndex:Int = -1
    var maxIndex:Int = -1
    var selectionColumns:Int = 1
    var selectedButton:Button?
    
    var highScore:Int = 0
  
    var bgSoundPlaying:Bool = false
    
    var wrapAroundSelection:Bool = true
    
    var playerIndexInUse1:Bool = false
    var playerIndexInUse2:Bool = false
    
    var singlePlayerGame:Bool = true // 
    var player1PlaysAsPlayer2:Bool = false
    var player2NotInUse:Bool = false
    var playerVersusPlayer:Bool = false
    
    var currentLevel:Int = 0
    var sksNameToLoad:String = "Level1"  //refers to the .sks file that will get loaded for the GameScene class
    var propertyListData:String = "Home" // refers to the name of the dictionary to look up in the property list. By default is "Home" but will get overridden when a new Home scene is created. This should match the SKS file's base name, for example when loading Home.sks, this value should be "Home"    
    
   
    
    var newGameLocation:CGPoint = CGPoint.zero
    var chooseLocation:CGPoint = CGPoint.zero
    
    var transitionInProgress:Bool = true

    let tapGeneralSelection = UITapGestureRecognizer()
  
    
    let swipeUp = UISwipeGestureRecognizer()
    let swipeDown = UISwipeGestureRecognizer()
    let swipeRight = UISwipeGestureRecognizer()
    let swipeLeft = UISwipeGestureRecognizer()

    var defaults:UserDefaults =  UserDefaults.standard
    
    var highScoreLabel:SKLabelNode = SKLabelNode()
     var leaderBoardID:String = "HighScore" // will change based on property list
    
    var continueGame:Bool = false
    
    var allowGCtoShow:Bool = true
    var allowScorePosting:Bool = true
    
    
    var productIdentifiers =  Set<String>()
    var product: SKProduct?
    var productsArray = [SKProduct]()
    var restoreSilently:Bool = true
    var request:SKProductsRequest?
    var purchasingEnabled:Bool = false  // used in the Home_Store.swift file to check whether purchasing can be done
    
    var debugMode:Bool = true
    
   
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
         try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        
        
        
            
        highScore = defaults.integer(forKey: "HighScore")
            
        
        checkToSeeIfGameCenterShouldBeEnabled()
        
        if (enableGameCenter == true){
            
            print("Game center will be enabled")
        }
        
        parsePropertyList()
        
        
        if ( Helpers.loggedIntoGC == true){
            
            saveHighScore(leaderBoardID, score: highScore)
            
        }
        
        
        
        self.enumerateChildNodes(withName: "//*") {
            node, stop in

            if let someButton:Button = node as? Button {
                
                someButton.createButton()
               
            }
            
            if (node.name == "HighScore"){
                
                if let label:SKLabelNode = node as? SKLabelNode{
                    
                    self.highScoreLabel = label
                    
                    self.highScoreLabel.text = "High Score: " + String(self.highScore)
                    
                }
                
                
            }
            
            
        }
        
        if ( selectionOrder.count > 0){
        
            selectedIndex = 0
            selectedButton = selectionOrder[selectedIndex]
            selectedButton?.select()
            
            maxIndex = selectionOrder.count - 1
            
        }
        
        
        
       setUpControllerObservers()
       connectControllers()
        
        
        
        tapGeneralSelection.addTarget(self, action: #selector(Home.pressedSelect))
        tapGeneralSelection.numberOfTapsRequired = 1
        tapGeneralSelection.numberOfTouchesRequired = 1
        self.view!.addGestureRecognizer(tapGeneralSelection)
        
        
        swipeRight.addTarget(self, action: #selector(Home.swipedRight))
        swipeRight.direction = .right
        self.view!.addGestureRecognizer(swipeRight)
        
        swipeLeft.addTarget(self, action: #selector(Home.swipedLeft))
        swipeLeft.direction = .left
        self.view!.addGestureRecognizer(swipeLeft)
        
        swipeUp.addTarget(self, action: #selector(Home.swipedUp))
        swipeUp.direction = .up
        self.view!.addGestureRecognizer(swipeUp)
        
        swipeDown.addTarget(self, action: #selector(Home.swipedDown))
        swipeDown.direction = .down
        self.view!.addGestureRecognizer(swipeDown)
        

        
        let wait:SKAction = SKAction.wait(forDuration: 1)
        let run:SKAction = SKAction.run {
            
            
            self.transitionInProgress = false;
           
        }
        
        let seq:SKAction = SKAction.sequence([wait, run])
        self.run(seq)
        
        
        lockOrUnlockButtonsThatRequireProducts()
        
      
    }
    
    
    func checkToSeeIfGameCenterShouldBeEnabled(){
        
        
        
        let path = Bundle.main.path(forResource: "LevelData", ofType: "plist")
        
        let dict:NSDictionary = NSDictionary(contentsOfFile: path!)!
        
        if (dict.object(forKey: "EnableGameCenter") != nil) {
            
            if (dict.object(forKey: "EnableGameCenter") is Bool){
                
                enableGameCenter = dict.object(forKey: "EnableGameCenter") as! Bool
                
                
                if (dict.object(forKey: "LeaderBoardID") != nil  && enableGameCenter == true) {
                    
                    if (dict.object(forKey: "LeaderBoardID") is String){
                        
                        leaderBoardID = dict.object(forKey: "LeaderBoardID") as! String
                        
                        print("will post scores to leaderboard with ID \(leaderBoardID)")
                        
                    }
                }
                
            }
            
            
        }
        
        
    }
    
    
    
    func parsePropertyList(){
   
    
        let path = Bundle.main.path(forResource: "LevelData", ofType: "plist")
    
        let dict:NSDictionary = NSDictionary(contentsOfFile: path!)!
    
        if (dict.object(forKey: propertyListData) != nil) {
    
            if let homeDict:[String : AnyObject] = dict.object(forKey: propertyListData) as? [String : AnyObject] {
            
                for (theKey, theValue) in homeDict {
                    
                    if (theKey == "Buttons") {
                        
                        
                         if let buttonDict:[String : AnyObject] = theValue as? [String : AnyObject] {
                            
                            for (buttonKey, buttonValue) in buttonDict {
                                
                                if (self.childNode(withName: buttonKey) != nil){
                                    
                                    if let someButton:Button = self.childNode(withName: buttonKey) as? Button {
                                        
                                        if let someButtonDict:[String : AnyObject] = buttonValue as? [String : AnyObject] {
                                            
                                            
                                            for (someButtonKey, someButtonValue) in someButtonDict {
                                            
                                                if (someButtonKey == "PlayerVersusPlayer") {
                                                    
                                                    if (someButtonValue is Bool){
                                                        
                                                        someButton.playerVersusPlayer = someButtonValue as! Bool
                                                        
                                                        
                                                    }

                                                    
                                                }
                                                else if (someButtonKey == "ReportHighScore") {
                                                    
                                                    if (someButtonValue is Bool){
                                                        
                                                        someButton.reportHighScore = someButtonValue as! Bool
                                                        
                                                        
                                                        if ( Helpers.loggedIntoGC == false && enableGameCenter == true ){
                                                            
                                                            authenticateLocalPlayer()
                                                        }
                                                        
                                                    }
                                                    
                                                    
                                                }
                                                else if (someButtonKey == "ShowGameCenter") {
                                                    
                                                    if (someButtonValue is Bool){
                                                        
                                                        someButton.showGameCenter = someButtonValue as! Bool
                                                       
                                                        
                                                        if ( Helpers.loggedIntoGC == false && enableGameCenter == true ){
                                                            
                                                            authenticateLocalPlayer()
                                                        }
                                                        
                                                    }
                                                    
                                                    
                                                }
                                                else if (someButtonKey == "LoadScene") {
                                                    
                                                    if (someButtonValue is String){
                                                        
                                                        someButton.loadHomeScene = someButtonValue as! String
                                                        
                                                        
                                                    }
                                                    
                                                    
                                                }
                                                else if (someButtonKey == "LoadScene") {
                                                    
                                                    if (someButtonValue is String){
                                                        
                                                        someButton.loadHomeScene = someButtonValue as! String
                                                        
                                                        
                                                    }
                                                    
                                                    
                                                }
                                                else if (someButtonKey == "LevelToLoad") {
                                                    
                                                    if (someButtonValue is Int){
                                                        
                                                        someButton.levelToLoad = someButtonValue as! Int
                                                        
                                                        
                                                    }

                                                    
                                                }
                                                else if (someButtonKey == "RequiresProduct") {
                                                    
                                                    if (someButtonValue is String ){
                                                        
                                                        someButton.requiresProduct = someButtonValue as! String
                                                        
                                                        
                                                    }
                                                    
                                                }
                                                    
                                                else if (someButtonKey == "RestoreProducts" || someButtonKey == "RestoresProducts" || someButtonKey == "RestoresPurchases" ) {
                                                    
                                                    if (someButtonValue is Bool){
                                                        
                                                        someButton.restoresProducts = someButtonValue as! Bool
                                                        
                                                        
                                                    }
                                                    
                                                    
                                                    
                                                }
                                                else if (someButtonKey == "UnboughtImage") {
                                                    
                                                    if (someButtonValue is String){
                                                        
                                                        someButton.unboughtImage = someButtonValue as! String
                                                        
                                                        
                                                    }
                                                    
                                                }
                                                else if (someButtonKey == "UnboughtSelectedImage") {
                                                    
                                                    if (someButtonValue is String){
                                                        
                                                        someButton.unboughtSelectedImage = someButtonValue as! String
                                                        
                                                        
                                                    }
                                                    
                                                }
                                                    
                                                else if (someButtonKey == "ContinueLastGame") {
                                                    
                                                    if (someButtonValue is Bool){


                                                        
                                                        if ( defaults.bool(forKey: "GameCanHaveContinueButton") == false ){
                                                            
                                                            print ("no continue point")
                                                            
                                                            someButton.alpha = 0.65
                                                            someButton.continueLastLevel = someButtonValue as! Bool
                                                            someButton.levelToLoad = 1
                                                            
                                                        } else {
                                                            
                                                            someButton.continueLastLevel = someButtonValue as! Bool
                                                            someButton.levelToLoad = defaults.integer(forKey: "LastLevel")
                                                            
                                                        }
                                                        
                                                    }
                                                    
                                                    
                                                }
                                                else if (someButtonKey == "SinglePlayerGame") {
                                                    
                                                    if (someButtonValue is Bool){
                                                        
                                                        someButton.singlePlayerGame = someButtonValue as! Bool
                                                       
                                                        
                                                    }
                                                    
                                                    
                                                    
                                                }
                                                else if (someButtonKey == "Player1PlaysAsPlayer2") {
                                                    
                                                    if (someButtonValue is Bool){
                                                        
                                                        someButton.player1PlaysAsPlayer2 = someButtonValue as! Bool
                                                        
                                                        
                                                    }
                                                    
                                                    
                                                    
                                                }
                                                else if (someButtonKey == "Levels") {
                                                    
                                                    if (someButtonValue is String){
                                                        
                                                        someButton.levelsName = someButtonValue as! String
                                                        
                                                        
                                                    }
                                                    
                                                    
                                                    
                                                }
                                                else if (someButtonKey == "DisableIfNotReached") {
                                                    
                                                    if (someButtonValue is Bool){
                                                        
                                                        someButton.disableIfNotReached = someButtonValue as! Bool
                                                        
                                                        
                                                        
                                                    }
                                                    
                                                    
                                                    
                                                }
                                                else if (someButtonKey == "SecondPlayerIsCPU") {
                                                    
                                                    if (someButtonValue is Bool){
                                                        
                                                        someButton.secondPlayerIsCPU = someButtonValue as! Bool
                                                        
                                                        
                                                    }
                                                    
                                                }
                                                else if (someButtonKey == "SelectedImage") {
                                                    
                                                    if (someButtonValue is String){
                                                        
                                                        someButton.selectedImage = someButtonValue as! String
                                                        
                                                        
                                                    }
                                                    
                                                }
                                                else if (someButtonKey == "SoundButtonSelect") {
                                                    
                                                    if (someButtonValue is String){
                                                        
                                                        someButton.soundButtonSelect = someButtonValue as! String
                                                        
                                                        
                                                    }
                                                    
                                                }
                                                else if (someButtonKey == "SoundButtonPress") {
                                                    
                                                    if (someButtonValue is String){
                                                        
                                                        someButton.soundButtonPress = someButtonValue as! String
                                                        
                                                        
                                                    }
                                                    
                                                }
                                                
                                            }
                                        
                                        }
                                        
                                    }
                                    
                                }
                                
                                
                                
                            }
                            
                            
                        }
                        
                        
                        
                    } else if (theKey == "Columns") {
                        
                        
                        if (theValue is Int){
                            
                            selectionColumns = theValue as! Int
                            
                            
                        }
                        
                        
                    } else if (theKey == "MP3Loop") {
                        
                        
                        if (theValue is String){
                            
                            
                            
                            let theFileName:String  = theValue as! String
                            let theFileNameWithNoMp3:String  = theFileName.replacingOccurrences(of: ".mp3", with: "", options:String.CompareOptions.caseInsensitive , range: nil)
                            
                            
                            
                            let dictToSend: [String: String] = ["fileToPlay":theFileNameWithNoMp3 ]
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "PlayBackgroundSound"), object: self, userInfo:dictToSend)
                            
                            bgSoundPlaying = true
                            
                        }
                        
                        
                    } else if (theKey == "IntroSound") {
                        
                        
                        if (theValue is String){
                            
                            
                            playSound(theValue as! String)
                            
                        }
                        
                        
                    } else if (theKey == "SelectionOrder") {
                        
                        if let someArray:[String] = theValue as? [String] {
                            
                            for item in someArray {
                                
                                if (self.childNode(withName: item) != nil){
                                    
                                    if let someButton:Button = self.childNode(withName: item) as? Button {
                                        
                                        selectionOrder.append(someButton)
                                        
                                    }
                                    
                                }
                                
                                
                                
                            }
                            
                            
                        }
                        
                        
                    }
                    
                    
                }
    
            }
    
    
        }
    }
    
    
    func changeSelectionWithDirection(_ type:Direction ){
        
        
        
        if (selectedIndex == -1){
            
            selectedIndex = 0
            selectButton (selectedIndex)
        }
            
            
        else if ( type == Direction.up){
            
            
            
            if (selectionColumns > 1){
                
                selectedIndex = selectedIndex - selectionColumns
                
                
                
                if (selectedIndex <= -1){
                    
                    if ( wrapAroundSelection == true){
                        
                        selectedIndex = maxIndex
                        
                    } else {
                        //set it back to what it was
                        
                        selectedIndex = selectedIndex + selectionColumns
                    }
                }
                
               
                
                selectButton(selectedIndex)
                
            } else {
                
                changeSelectionWithDirection(Direction.left )
                
            }
            
            
            
            
        } else if ( type == Direction.left){
            
           
            
            selectedIndex = selectedIndex - 1
            
            if (selectedIndex <= -1){
                
                if ( wrapAroundSelection == true){
                    
                    selectedIndex = maxIndex
                    
                } else {
                    //set it back to what it was
                    selectedIndex = selectedIndex + 1
                }
            }
            
           
            
            selectButton(selectedIndex)
            
        }
        else if ( type == Direction.right){
            
           
            
            selectedIndex = selectedIndex + 1
            
           
            
            if (selectedIndex > maxIndex){
                
                if ( wrapAroundSelection == true){
                    
                    selectedIndex = 0
                    
                } else {
                    //set it back to what it was
                    selectedIndex = selectedIndex - 1
                    
                }
            }
            
            
            selectButton(selectedIndex)
            
        }
        else if ( type == Direction.down){
            
            
            
            if (selectionColumns > 1){
                
                
                selectedIndex = selectedIndex + selectionColumns
                
                
                
                if (selectedIndex > maxIndex){
                    
                    if ( wrapAroundSelection == true){
                        
                        
                        selectedIndex = 0
                        
                    }  else {
                        //set it back to what it was
                        selectedIndex = selectedIndex - selectionColumns
                    }
                    
                }
                
                
                
                selectButton(selectedIndex)
                
                
            } else {
                
                changeSelectionWithDirection(Direction.right )
                
            }
            
        }
        
        
    }
    
    
    func selectButton(_ theIndex:Int){
        
        
        
        var counter:Int = 0
        
        for element in selectionOrder{
            
            if (counter == theIndex) {
                
                
                selectedButton?.deselect()
                
                selectedButton!.position = CGPoint(x: selectedButton!.position.x, y: selectedButton!.position.y - 5)
                
                selectedButton = element
                
                
                selectedButton!.select()
                
                selectedButton!.position = CGPoint(x: selectedButton!.position.x, y: selectedButton!.position.y + 5)
                
                break
                
            }
            
            counter += 1
            
        }
        
        
    }
    
    
    
    
    
    func pressedSelect(){
        
        
        
        
         if ( transitionInProgress == false) {
            
            
            if (selectedButton?.requiresProduct != "" && selectedButton?.isLocked == true){
                
                buyProduct( (selectedButton?.requiresProduct)! )
                
                
            }
            else if (selectedButton?.restoresProducts == true){
                
                restorePurchases()
                
                
            }
            
            
      
        else if (selectedButton?.continueLastLevel == true && defaults.bool(forKey: "GameCanHaveContinueButton") == false  ){
            
            // do nothing
            
            
        } else if (selectedButton?.isDisabled == true ){
            
            // do nothing
            
            
        } else if (selectedButton?.loadHomeScene != ""){
            
            loadHomeScene((selectedButton?.loadHomeScene)! )
            
            
        } else if (selectedButton?.reportHighScore == true){
            
           
              saveHighScore(leaderBoardID, score: self.highScore)
            
            
            
        } else if (selectedButton?.showGameCenter == true){
            
            // do nothing
            if (allowGCtoShow == true){
                
                //allowGCtoShow prevents double opening the window
                
                allowGCtoShow = false
                
                if (Helpers.loggedIntoGC == true){
                
                    showGameCenter()
                    
                } else {
                    
                    if (  enableGameCenter == true ){
                    
                        authenticateLocalPlayer()
                        
                    }
                }
               
                
            }
            
            
        } else if (selectedButton?.isLocked == false) {
        


                transitionInProgress = true
        
                loadGame()
        

        }
            
        }
    }
    
    func loadGame(){
        
        
        print("will load game")
        
        defaults.set(4, forKey: "HeartsPlayer1")
        defaults.set(4, forKey: "HeartsPlayer2")
        
        defaults.set(0, forKey: "WinCount1")
        defaults.set(0, forKey: "WinCount2")
        
        defaults.set(0, forKey: "ScorePlayer1")
        defaults.set(0, forKey: "ScorePlayer2")
        
        
        defaults.set(0, forKey: "BulletCountPlayer1")
        defaults.set(0, forKey: "BulletCountPlayer2")
        
        //for testing force a specific level
        //defaults.setInteger(1, forKey: "LastLevel")
        
        
        var levelsName:String = "Levels"
        
        if (selectedButton?.continueLastLevel == true){
            
            //Continueing Game
            
            continueGame = true
            
            if ( defaults.object(forKey: "LevelsName") != nil){
                
                //LevelsName is the array containing all the Levels to use for this game.

                levelsName = defaults.object(forKey: "LevelsName") as! String
                
                
            } else {
                
                levelsName = (selectedButton?.levelsName)!
                
                if ( selectedButton?.playerVersusPlayer == false) {
                
                    //don't save the LevelsName for PVP games, as they are intended more for "one off" battles and not part of a campaign mode.
                    
                    defaults.set(levelsName, forKey: "LevelsName")
                    
                }
            }
            
            
            if (defaults.integer(forKey: "LastLevel") != 0) {
                
                
                currentLevel = defaults.integer(forKey: "LastLevel")
                sksNameToLoad = Helpers.parsePropertyListForLevelToLoad(currentLevel, levelsName:levelsName)
                
            } else {
                
                currentLevel = 1
                sksNameToLoad = Helpers.parsePropertyListForLevelToLoad(currentLevel, levelsName:levelsName)
                defaults.set(currentLevel, forKey: "LastLevel")
                
            }

            
            
        } else {
            
            //Not continueing game, starting a new one.
            
            levelsName = (selectedButton?.levelsName)!
           
            
            if ( selectedButton?.playerVersusPlayer == false) {
                
                //don't save the LevelsName for PVP games, as they are intended more for "one off" battles and not part of a campaign mode.
                
                defaults.set(levelsName, forKey: "LevelsName")
                
            }
            
            
            continueGame = false
            
            currentLevel = (selectedButton?.levelToLoad)!
            
            if (currentLevel == 0){
                
                currentLevel = 1
            }
            
            sksNameToLoad = Helpers.parsePropertyListForLevelToLoad(currentLevel, levelsName:levelsName)
           
            
        }
        
        
        
        
        
        cleanUpScene()
        
        
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
            
             scene.levelsName = levelsName
            
            defaults.set(true, forKey: "GameCanHaveContinueButton")
            
            if ( isMadeForPad == false){
                
                if (UIDevice.current.userInterfaceIdiom == .pad ){
                     //adjustments will be made in the scene to account for Aspect Fit deing used
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
            
            
            
            
            
           
            print("loading SKS File \(sksNameToLoad)")
            
            scene.currentLevel = currentLevel
            
            
             playSound((selectedButton?.soundButtonPress)!)
            
            
            if ( continueGame == true) {
                
                print("continuing game settings from before")
                
                scene.playerVersusPlayer = defaults.bool(forKey: "PlayerVersusPlayer")
                scene.singlePlayerGame = defaults.bool(forKey: "SinglePlayerGame")
                scene.player1PlaysAsPlayer2 = defaults.bool(forKey: "Player1PlaysAsPlayer2")
                scene.player2NotInUse = defaults.bool(forKey: "Player2NotInUse")
                scene.levelsPassed = defaults.integer(forKey: "LevelsPassed")
                
                if (scene.levelsPassed <= 0){
                    //make sure this isn't 0 
                    
                    scene.levelsPassed = 1
                    defaults.set(1, forKey: "LevelsPassed")
                }
                
                
            } else {
                
               
                
            
            // game is not continued

            if ( (selectedButton?.singlePlayerGame)! == true ){
                
                //is a single player game
                
                scene.singlePlayerGame = true
                
                
                
                print("single player game")
                
                if ( (selectedButton?.player1PlaysAsPlayer2)! == true ){
                    
                    scene.player1PlaysAsPlayer2 = true
                    
                    print("Player 1 will use the Player2 art")
                    
                }
                
                if  (  (selectedButton?.secondPlayerIsCPU)!  == true ){
                    

                    scene.player2NotInUse = false
                    
                    
                    
                    print("player 2 stays in game as CPU")
                    
                } else  if  (  (selectedButton?.secondPlayerIsCPU)!  == false ){
                    
                     // user does not want to play co-op with CPU second player
                    
                    scene.player2NotInUse = true
                    
                   
                     print("will remove player 2")
                    
                }
                
                
            } else {
                
                //is a two player game
                
                scene.singlePlayerGame = false
                
                
                
                 print("2 Player game")
                
                
            }
            
            

           
            
            if ( (selectedButton?.playerVersusPlayer)! == true ) {
                
                
                scene.playerVersusPlayer = true
                
                
                
                 print("Player vs Player Game")
                
            } else {
                
                scene.playerVersusPlayer = false
                
                
                
                print("Is Not Versus Game")
            }
                
                
            } //ends else for continue game
            
           
            
            defaults.set(scene.player1PlaysAsPlayer2, forKey: "Player1PlaysAsPlayer2")
            defaults.set(scene.player2NotInUse, forKey: "Player2NotInUse")
            defaults.set(scene.singlePlayerGame, forKey: "SinglePlayerGame")
            defaults.set(scene.playerVersusPlayer, forKey: "PlayerVersusPlayer")
            
            defaults.synchronize()
            
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
        
        
        self.removeAllActions()
        
        for node in self.children {
            
            node.removeAllActions()
           // node.removeFromParent()
            
        }
        
        for controller in GCController.controllers(){
            
            
            controller.playerIndex = .indexUnset
            
            if (controller.extendedGamepad != nil ){
                
                controller.extendedGamepad?.valueChangedHandler = nil
               
                
            } else if (controller.gamepad != nil){
                
                
                controller.gamepad?.valueChangedHandler = nil
               
                
            }
            
            
        }
        
        
        
        
    }
    
    
    func swipedRight(){
        
       
        
        selectRight()
    }
    func swipedLeft(){
        
        selectLeft()
    }
    func swipedUp(){
        
      
        selectUp()
    }
    func swipedDown(){
        
        selectDown()
    }
    
    
    
    func selectRight(){
        
        changeSelectionWithDirection(Direction.right)
    }
    func selectLeft(){
        
        changeSelectionWithDirection(Direction.left)
    }
    func selectUp(){
        
        changeSelectionWithDirection(Direction.up)
    }
    func selectDown(){
        
        changeSelectionWithDirection(Direction.down)
    }

    func playSound(_ theSound:String ){
        
        if (theSound != ""){
            
            let sound:SKAction = SKAction.playSoundFileNamed(theSound, waitForCompletion: true)
            self.run(sound)
            
        }
        
    }
    
    
    func authenticateLocalPlayer() {
        
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {  (viewController, error )  -> Void in
            
            if (viewController != nil) {
                
                let vc:UIViewController = self.view!.window!.rootViewController!
                vc.present(viewController!, animated: true, completion:nil)
                
            } else {
                
                
                print ("Authentication is \(GKLocalPlayer.localPlayer().isAuthenticated) ")
                Helpers.loggedIntoGC = true
                
                
                
                // do something based on the player being logged in.
                
              
            }
            
        }
        
    }
    
    func showGameCenter() {
        
        let gameCenterViewController = GKGameCenterViewController()
        
        
        // options for what to initially show...
        
        //gameCenterViewController.viewState = GKGameCenterViewControllerState.Achievements
       // gameCenterViewController.viewState = GKGameCenterViewControllerState.Leaderboards
        
        //gameCenterViewController.leaderboardIdentifier = "VehiclesBuilt"
        
        gameCenterViewController.gameCenterDelegate = self
        
        let vc:UIViewController = self.view!.window!.rootViewController!
        vc.present(gameCenterViewController, animated: true, completion:nil)
        
        
    }
    
    func saveHighScore(_ identifier:String, score:Int) {
        
        if ( allowScorePosting == true) {
            
            
            if ( highScore > defaults.integer( forKey: "GameCenterHighScore")  && enableGameCenter == true) {
        
                if (GKLocalPlayer.localPlayer().isAuthenticated) {
            
                        allowScorePosting = false
            
                    let scoreReporter = GKScore(leaderboardIdentifier: identifier)
            
                    scoreReporter.value = Int64(score)
            
                    let scoreArray:[GKScore] = [scoreReporter]
            
            
                    GKScore.report(scoreArray, withCompletionHandler: {
                
                        error -> Void in
                
                        if (error != nil) {
                    
                            print("error")
                    
                        } else {
                    
                            self.allowScorePosting = true
                    
                            self.highScoreLabel.text = "Posted a New High Score to Game Center"
                    
                            self.defaults.set(self.highScore, forKey: "GameCenterHighScore")
                    
                            print("posted score of \(score)")
                            //from here you can do anything else to tell the user they posted a high score
                    
                        }
                
                
                    })
            
            
            
                }
                
                
            } else {
                
                
                self.highScoreLabel.text = "High Score: " + String(self.highScore)
                
                
            }
            
        }
    }
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        
        gameCenterViewController.dismiss(animated: true, completion:nil)
        
        
        
        print("Game Center Dismissed")
        
        allowGCtoShow = true
       
        
    }
    
    
    
    func loadHomeScene( _ sksName:String ){
        
        
        
        
        cleanUpScene()
        
        
        
        
        
        var fullSKSNameToLoad:String = sksName
        
        
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
            
            
            scene.propertyListData = sksName 
            scene.scaleMode = .aspectFill
            
            
            
            self.view?.presentScene(scene, transition: SKTransition.fade(with: SKColor.white, duration: 2) )
            
        }
        
        
        
    }
    
    
    func lockOrUnlockButtonsThatRequireProducts(){
        
        self.enumerateChildNodes(withName: "//*") {
            node, stop in
            
            if let someButton:Button = node as? Button {
                
                if (someButton.requiresProduct != "") {
                    
                    print("found button that requires a product")
                    
                    
                    
                    
                    if ( self.defaults.object(forKey: someButton.requiresProduct) ==  nil){
                        
                        print("No default saved for key \(someButton.requiresProduct) which means the product has not been bought ")
                        
                        someButton.lockButton()
                        
                        self.defaults.set("Unpurchased", forKey: someButton.requiresProduct)
                        self.productIdentifiers.insert( someButton.requiresProduct )
                        self.setUpPurchasing()
                        
                        
                        
                        
                        
                    }
                        
                    else if ( self.defaults.object(forKey: someButton.requiresProduct) as! String != "Purchased") {
                        
                        //defaults already has a string value of "Unpurchased" for objectForKey(someButton.requiresProduct)
                        self.productIdentifiers.insert( someButton.requiresProduct )
                        someButton.lockButton()
                        self.setUpPurchasing()
                        
                        
                        
                        
                    } else {
                        
                        someButton.unlockButton()
                    }
                    
                    
                    
                }
                
            }
            
        }
        
        /*
         
         */
        
    }
    
    
}
