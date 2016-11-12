//
//  MovingPlatformX.swift
//  SideScroller
//


import Foundation
import SpriteKit


class MovingPlatform: Platform {
    
    var lastLocation:CGPoint = CGPoint.zero
    var moveAmountX:CGFloat = 0
    var moveAmountY:CGFloat = 0
    
    func update() {
        
        if (lastLocation != CGPoint.zero) {
            
            moveAmountX = self.position.x - lastLocation.x
            moveAmountY = self.position.y - lastLocation.y
        }
        
        lastLocation = self.position
        
       
        
    }
    
    
}
