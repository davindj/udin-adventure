//
//  GameViewController.swift
//  UdinTest
//
//  Created by Dimas A. Prabowo on 06/04/21.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    @IBOutlet weak var Gamescene: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.Gamescene {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "Intro1") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = false
            
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = false
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
