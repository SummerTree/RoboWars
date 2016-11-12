//
//  Button.swift
//  SideScroller
//
//  Created by Justin Dike 2 on 11/24/15.
//  Copyright © 2015 CartoonSmart. All rights reserved.
//

import Foundation
import SpriteKit


class Button: SKSpriteNode {

    var currentTextureName:String?
    var selectedTexture:SKTexture?
    var initialTexture:SKTexture?
    var isSelected:Bool = false
    var selectedImage:String = "SomeImage"
    
    var playerVersusPlayer:Bool = false
    var levelToLoad:Int = 1
    var continueLastLevel:Bool = false
    var singlePlayerGame:Bool = false
    var secondPlayerIsCPU:Bool = false
    var levelsName:String = "Levels"
    var reportHighScore:Bool = false
    var showGameCenter:Bool = false
    var loadHomeScene:String = ""//don't give this a default value. Home class will check to see if this equals "" (nothing)
    var disableIfNotReached:Bool = false
     var isDisabled:Bool = false
    
    var soundButtonSelect:String = ""
    var soundButtonPress:String = ""
    
    var player1PlaysAsPlayer2:Bool = false
    
    
    //purchasing related properties
    
    var restoresProducts:Bool = false
    var unboughtImage:String = ""
    var unboughtTexture:SKTexture?
    
    var unboughtSelectedImage:String = ""
    var unboughtSelectedTexture:SKTexture?
    
    var requiresProduct:String = ""
    var isLocked:Bool = false
    
    var defaults:UserDefaults =  UserDefaults.standard
    
    func createButton(){
        
        
        initialTexture = self.texture
        
        selectedTexture = SKTexture(imageNamed: selectedImage)
        
        
        if ( disableIfNotReached == true && levelToLoad > 1) {
            
            if (defaults.integer(forKey: "LastLevel") < levelToLoad) {
                
                self.alpha = 0.4
                levelToLoad = defaults.integer(forKey: "LastLevel")
                isDisabled = true
                
                print ("Button is set to be disabled if the player hasn't reached this level. The last level passed is \(levelToLoad)")
                
            }
            
            
        }
        
    }
    
    
    func lockButton(){
        
        
        
        if ( unboughtImage != "" ){
            
            unboughtTexture = SKTexture(imageNamed: unboughtImage)
            self.texture = unboughtTexture
        }
        
        if ( unboughtSelectedImage != "" ){
            
            unboughtSelectedTexture = SKTexture(imageNamed: unboughtSelectedImage)
            
        }
        
        
        isLocked = true
        
        
    }
    
    func unlockButton(){
        
        self.texture = initialTexture
        isLocked = false
        
        
        
    }
    
    func select(){
    
        if ( selectedTexture != nil && isLocked == false) {
            
            self.texture = selectedTexture
            
        }
            
        else if (  unboughtSelectedTexture != nil &&  isLocked == true) {
            
            self.texture = unboughtSelectedTexture
            
        }
        
        playSound(soundButtonSelect)
        
        
    }
    
    func deselect(){
        
        if (isLocked == false) {
            
            self.texture = initialTexture
            
        } else if (isLocked == true && unboughtTexture != nil ) {
            
            
            self.texture = unboughtTexture
            
        }
        
    }
    
    func playSound(_ theSound:String ){
        
        if (theSound != ""){
        
        let sound:SKAction = SKAction.playSoundFileNamed(theSound, waitForCompletion: true)
        self.run(sound)
            
        }
        
    }

}
