//
//  GameScene_GameController.swift
//  SideScroller
//
//  Created by Justin Dike 2 on 10/28/15.
//  Copyright © 2015 CartoonSmart. All rights reserved.
//

import Foundation
import SpriteKit


extension Home {
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        
        
        
        for touch in (touches ) {
            let location = touch.location(in: self)
            
            
            self.enumerateChildNodes(withName: "//*") {
                node, stop in
                
                if (node is Button){
                    
                    
                    
                    if let someButton:Button = node as? Button {
                        
                        
                        if ( someButton.frame.contains(location) ){
                        
                            self.selectedButton!.deselect()
                            
                        someButton.select()
                        
                        self.selectedButton = someButton
                        
                        self.pressedSelect()
                        
                        }
                        
                    }
                    
                    
                }
                
            }
            
        }
    }
    
    
    
}
