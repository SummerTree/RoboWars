//
//  GameScene_GameController.swift
//  SideScroller
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
                
            } else if (controller.microGamepad != nil ){
                
                //is micro controller with playerIndex already set
                controller.microGamepad?.valueChangedHandler = nil
                setUpMicroControlsWithIndexing(controller)
                
            }
            
            
        }
        
        
        
        
        
        
   
    }
    
    func setUpExtendedControlsWithIndexing(_ controller:GCController){
        
       

        controller.extendedGamepad?.valueChangedHandler = {
            (gamepad: GCExtendedGamepad, element:GCControllerElement) in
            
            
            
            
            

            
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
    
    func setUpMicroControlsWithIndexing(_ controller:GCController){
       
        

        controller.microGamepad?.valueChangedHandler = {
            (gamepad: GCMicroGamepad, element:GCControllerElement) in
            
            
            gamepad.reportsAbsoluteDpadValues = true
            gamepad.allowsRotation = true
            
          
            
            
            
            if (gamepad.buttonA == element ){
                
                print("pressed")
                 self.pressedSelect()
                
            }
            
            if (gamepad.buttonX == element){
                
                 print("pressed")
                 self.pressedSelect()
            }
            

        }
        
        
        
    }
    
    func controllerDisconnected(){
        
        print("disconnected")
        
        
    }
    
    

    
    
    
}
