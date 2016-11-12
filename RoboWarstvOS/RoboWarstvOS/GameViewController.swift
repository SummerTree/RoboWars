//
//  GameViewController.swift
//  SideScroller
//


import UIKit
import SpriteKit
import AVFoundation
class GameViewController: UIViewController {
    
    var bgSoundPlayer:AVAudioPlayer?
    var bgSoundVolume:Float = 1 // 0.5 would be 50% or half volume
    var bgSoundLoops:Int = -1 // -1 will loop it forever
    var bgSoundContinues:Bool = false
    
    let defaults:UserDefaults = UserDefaults.standard
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.playBackgroundSound(_:)), name: NSNotification.Name(rawValue: "PlayBackgroundSound"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.stopBackgroundSound), name: NSNotification.Name(rawValue: "StopBackgroundSound"), object: nil)
        
        
        let sks:String = "Home" // This value will be used to find a matching SKS file, for example, "Home.sks"  then  within the class it will be used as the name of the dictionary to look up in the property list. 

        if let scene = Home(fileNamed: sks) {
            
            
            scene.propertyListData = sks
            
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            
            skView.showsPhysics = false
            
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            
            
            
            skView.presentScene(scene)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func playBackgroundSound(_ notification: Notification) {
        
        
        let name = (notification as NSNotification).userInfo!["fileToPlay"] as! String
        
    
        
        if (bgSoundPlayer != nil){
            
            bgSoundPlayer!.stop()
            bgSoundPlayer = nil
            
            
        }
        
        if (name != ""){
        
            let fileURL:URL = Bundle.main.url(forResource:name, withExtension: "mp3")!
        
        do {
            bgSoundPlayer = try AVAudioPlayer(contentsOf: fileURL)
        } catch _{
            bgSoundPlayer = nil
            
        }
        
        bgSoundPlayer!.volume = 0.75
        bgSoundPlayer!.numberOfLoops = -1
        bgSoundPlayer!.prepareToPlay()
        bgSoundPlayer!.play()
            
        }
        
        
    }
    func stopBackgroundSound() {
        
        if (bgSoundPlayer != nil){
            
            bgSoundPlayer!.stop()
            bgSoundPlayer = nil
            
            
        }
        
    }
    
    
}
