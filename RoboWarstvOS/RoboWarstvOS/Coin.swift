//
//  Portal.swift
//  SideScroller
//


import Foundation
import SpriteKit


class Coin: SKSpriteNode {
    
    var score:Int = 1
    var sound:String = "Coin"
    
    
    func setUpCoin() {
        
        self.physicsBody?.categoryBitMask = BodyType.coin.rawValue
        self.physicsBody?.collisionBitMask = BodyType.platform.rawValue  |  BodyType.coin.rawValue
        self.physicsBody?.contactTestBitMask = BodyType.player.rawValue
        
        if ( self.name!.range(of: "Coin") != nil ){
            
            
            let numberForScore:String = self.name!.replacingOccurrences(of: "Coin", with: "", options:String.CompareOptions.caseInsensitive , range: nil)
            
            score = Int(numberForScore)!

        }
        
    }
    
    
}
