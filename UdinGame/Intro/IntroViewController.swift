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
    
    static var viewController: IntroViewController?
    static func navigate(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "gameView") as! GameViewController
            IntroViewController.viewController?.present(nextViewController, animated:true, completion:nil)
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
}
