//
//  BattleSceneViewController.swift
//  UdinGame
//
//  Created by Davin Djayadi on 08/04/21.
//

import UIKit
import SpriteKit

class BattleSceneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Load Game
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = BattleScene(fileNamed: "BattleScene") {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
