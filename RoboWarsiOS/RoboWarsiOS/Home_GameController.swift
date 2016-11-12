//
//  GameScene_GameController.swift
//  SideScroller
//
//  Created by Justin Dike 2 on 10/28/15.
//  Copyright © 2015 CartoonSmart. All rights reserved.
//

import Foundation
import SpriteKit
import GameController

extension Home {
    
   
    func setUpControllerObservers(){
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(Home.connectControllers), name: NSNotification.Name.GCControllerDidConnect, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(Home.controllerDisconnected), name: NSNotification.Name.GCControllerDidDisconnect, object: nil)
        
        
    }
    
    func connectControllers(){
        
        
        

        //prioritize extended controllers 
        
        for controller in GCController.controllers(){
            

            if (controller.extendedGamepad != nil ){
                
                controller.extendedGamepad?.valueChangedHandler = nil
                setUpExtendedControlsWithIndexing(controller)

            } else if (controller.gamepad != nil){
                

                controller.gamepad?.valueChangedHandler = nil
                setUpStandardControlsWithIndexing(controller)
                
            }
            
        }
        
        
        
        
        
        
   
    }
    
    func setUpExtendedControlsWithIndexing(_ controller:GCController){
        
       

        controller.extendedGamepad?.valueChangedHandler = {
            (gamepad: GCExtendedGamepad, element:GCControllerElement) in
            
            
            
            
            if (gamepad.leftThumbstick == element){
                
                
                
                if (gamepad.leftThumbstick.down.isPressed == true && self.canSelect == true){
                    
                    self.canSelect = false
                    self.selectDown()
                    
                } else if (gamepad.leftThumbstick.up.isPressed == true && self.canSelect == true){
                    
                    self.canSelect = false
                   self.selectUp()
                    
                }
                    
                else if (gamepad.leftThumbstick.right.isPressed == true && self.canSelect == true){
                    
                    self.canSelect = false
                     self.selectRight()
                    
                } else if (gamepad.leftThumbstick.left.isPressed == true  && self.canSelect == true ){
                    
                    self.canSelect = false
                    self.selectLeft()
                    
                } else if (gamepad.leftThumbstick.left.isPressed == false && gamepad.leftThumbstick.right.isPressed == false && gamepad.leftThumbstick.up.isPressed == false && gamepad.leftThumbstick.down.isPressed == false){
                    
                     self.canSelect = true
                    
                } 
                
                
                
                
            }  else if (gamepad.dpad == element){
                
                if (gamepad.dpad.down.isPressed == true && self.canSelect == true){
                     self.canSelect = false
                    self.selectDown()
                    
                    
                } else if (gamepad.dpad.up.isPressed == true && self.canSelect == true){
                     self.canSelect = false
                     self.selectUp()
                    
                } else if (gamepad.dpad.right.isPressed == true && self.canSelect == true){
                     self.canSelect = false
                    self.selectRight()
                    
                } else if (gamepad.dpad.left.isPressed == true && self.canSelect == true){
                     self.canSelect = false
                     self.selectLeft()
                    
                } else if (gamepad.dpad.left.isPressed == false && gamepad.dpad.right.isPressed == false && gamepad.dpad.up.isPressed == false && gamepad.dpad.down.isPressed == false){
                    self.canSelect = true
                  
                    
                }
                
                
            } // ends if (gamepad.dpad == element){
            
            

            
             if (gamepad.buttonA == element ){
                
                if ( gamepad.buttonA.isPressed == false){
                
   
                    self.pressedSelect()
                    
                }
                
                
            }
            else if (gamepad.buttonX == element){
                
                 self.pressedSelect()
            }
            
           
            else if (gamepad.buttonY == element){
                
                 self.pressedSelect()
            }
            
            
            
            

        }
        

    }
    
    func setUpStandardControlsWithIndexing(_ controller:GCController){
        
        
        
        controller.gamepad?.valueChangedHandler = {
            (gamepad: GCGamepad, element:GCControllerElement) in
            
           
            if (gamepad.dpad == element){
                
                if (gamepad.dpad.down.isPressed == true && self.canSelect == true){
                    self.canSelect = false
                    self.selectDown()
                    
                    
                } else if (gamepad.dpad.up.isPressed == true && self.canSelect == true){
                    self.canSelect = false
                    self.selectUp()
                    
                } else if (gamepad.dpad.right.isPressed == true && self.canSelect == true){
                    self.canSelect = false
                    self.selectRight()
                    
                } else if (gamepad.dpad.left.isPressed == true && self.canSelect == true){
                    self.canSelect = false
                    self.selectLeft()
                    
                } else if (gamepad.dpad.left.isPressed == false && gamepad.dpad.right.isPressed == false && gamepad.dpad.up.isPressed == false && gamepad.dpad.down.isPressed == false){
                    self.canSelect = true
                    
                    
                }
                
                
            } // ends if (gamepad.dpad == element){
            
            
             if (gamepad.buttonA == element ){
                
              
                 self.pressedSelect()
                
            }
            else if (gamepad.buttonX == element){
                
               
                     self.pressedSelect()
                    
            }
                
                
            else if (gamepad.buttonY == element){
                    
                 self.pressedSelect()

                    
            }
                
          
            
            
        }
        

    }
    
    
    
    func controllerDisconnected(){
        
        print("disconnected")
        
        
    }
    
    

    
    
    
}
