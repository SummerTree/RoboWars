//
//  MovingPole.swift
//  SideScroller
//
//  Created by Justin Dike 2 on 10/20/15.
//  Copyright © 2015 CartoonSmart. All rights reserved.
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
    
    
    /*
    //first method taught in the tutorial. Better method above
    
    var moveAmount:CGFloat = 1 // will toggle between 1 and -1, and we will pass this value onto thePlayer
    var moveTotal:CGFloat = 0 // when exceeds the max or min range, it will toggle the moveAmount from either 1 to -1
    var moveRange:CGFloat = 100
    
    func update() {
        
        self.position = CGPointMake(self.position.x + moveAmount, self.position.y)
        
        
        moveTotal = moveTotal + moveAmount
        
        if (moveTotal == moveRange) {
            
            moveTotal = 0
            moveAmount = -1
            
        } else if (moveTotal == -moveRange){
            
            moveTotal = 0
            moveAmount = 1
        }
        
        
        
    }*/
    
    
}
