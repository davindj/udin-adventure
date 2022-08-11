//
//  OutroBadViewController.swift
//  UdinGame
//
//  Created by Dimas A. Prabowo on 13/04/21.
//

import UIKit
import SpriteKit

class OutroBadViewController: UIViewController {
    @IBOutlet weak var outroSceneBad: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load Game
        if let view = outroSceneBad {
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
