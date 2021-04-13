//
//  IntroViewController.swift
//  UdinGame
//
//  Created by Dimas A. Prabowo on 13/04/21.
//

import UIKit
import SpriteKit

class IntroViewController: UIViewController {
    @IBOutlet weak var introScene: SKView!
    // Singleton
    static var viewController: IntroViewController?
    // Display berdasarkan Kondisinya Build program
    static let IS_DEVELOPMENT = true
    
    static func navigate(){
        // Buat Navigasi View Controller...
        // tdk dipakai karena byk bugnya... krn cuma pake 1 View Controller
        // sbg pengganti yg dipakai presentGameScene
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "gameView") as! GameViewController
//            IntroViewController.viewController?.present(nextViewController, animated:true, completion:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IntroViewController.viewController = self
        
        // Load Game
        if let view = introScene {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "Intro0") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFit
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = false
            
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = false
        }
    }
    
    // MARK: Function Present Scene
    static func presentGameScene(toScene scene: SKScene, callback cb: (()->Void)={}){
        IntroViewController.presentGameScene(toScene: scene, transition: nil, callback: cb)
    }
    static func presentGameScene(toScene scene: SKScene, transition: SKTransition?, callback cb: (()->Void)={}){
        let view = IntroViewController.viewController!.introScene!
        // Diasumsikan Scenenya ga mungkin nil
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFit
        // Present the scene
        if let trans = transition{
            view.presentScene(scene, transition: trans)
        }else{
            view.presentScene(scene)
        }
        // Panggil Callback
        cb()
        
        // Konfigurasi Kalau Development
        if IntroViewController.IS_DEVELOPMENT{
            view.ignoresSiblingOrder = false
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = false
        }
    }
}
