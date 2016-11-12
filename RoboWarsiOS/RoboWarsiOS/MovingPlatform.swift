//
//  MovingPlatformX.swift
//  SideScroller
//
//  Created by Justin Dike 2 on 10/23/15.
//  Copyright © 2015 CartoonSmart. All rights reserved.
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
