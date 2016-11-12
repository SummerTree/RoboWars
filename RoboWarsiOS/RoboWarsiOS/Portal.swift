//
//  Portal.swift
//  SideScroller
//
//  Created by Justin Dike 2 on 10/21/15.
//  Copyright © 2015 CartoonSmart. All rights reserved.
//

import Foundation
import SpriteKit


class Portal: SKSpriteNode {
    
    
    //var goesWhere:String = ""  //left over from tutorial, not used.
    
    //v1.4
    
    var goesToSpecificLevel:Bool = false
    var levelToLoad:Int = 1
    var levelsName:String = "Levels" //The array of levels to go to. This could be an alternate grouping of levels, like "SecretLevels"
    var requiresScoreOver:Int = -1
    var requiresEnemiesKilledOver:Int = -1
    var showLevelPassedImage:Bool = false // whether to show the Levels Passed Image when going through Portal
    var addsToLevelsPassed:Bool = false // whether to save to the defaults the overall number of levels passed has increased. Only set this to true if the Portal is going to the next level in main "Levels" array, leave this false for Bonus / Secret Levels.
    var movesPlayerToNode:Bool = false
    var nodeToMovePlayerTo:String = ""
    
    var oneTimeUse:Bool = false
    var alreadyUsed:Bool = false
    
    var nodeToMoveCameraTo:String = ""
    var movesBothPlayers:Bool = false
    var textureAfterUse:String = ""
    
    func setUpPortal() {
        
        // goesWhere = self.name!  //left over from tutorial, not used.
        
        if ( goesToSpecificLevel == true){
            
            print("Portal named \(self.name) will go to level number \(levelToLoad) in the array named \(levelsName)")
            
        } else if ( movesPlayerToNode == true){
            
            print("Portal named \(self.name) will move the player to a node named \(nodeToMovePlayerTo)")
            
            if ( nodeToMoveCameraTo != ""){
                
                print("and will also move the camera to a node named \(nodeToMoveCameraTo)")
            }
            
        } else {
            print("Portal named \(self.name) will take the player to the next level")
            print("To go to a specific level, see the Portals documentation as of Build 1.4")
        }
        
        self.physicsBody?.categoryBitMask = BodyType.portal.rawValue
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = BodyType.player.rawValue
        
        
        
    }
    
    func changeTexture(){
        
        if ( textureAfterUse != ""){
            
            self.texture = SKTexture(imageNamed: textureAfterUse)
            
        }
        
    }
    
    
}