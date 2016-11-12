//
//  MovingPole.swift
//  SideScroller
//


import Foundation
import SpriteKit

class MovingPole: Pole {
    
    var lastLocation:CGPoint = CGPoint.zero
    var moveAmount:CGFloat = 0
    
    func update() {
        
        if (lastLocation != CGPoint.zero) {
            
            moveAmount = self.position.x - lastLocation.x
        }
        
        lastLocation = self.position
        
    }
}
