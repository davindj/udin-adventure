//
//  GameViewController.swift
//  UdinTest
//
//  Created by Dimas A. Prabowo on 06/04/21.
//

import UIKit
import SpriteKit
import AVFoundation
import GameplayKit

class GameViewController: UIViewController {
    @IBOutlet weak var gameScene: SKView!
    
    static var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = gameScene {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
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
        
        do {
            GameViewController.audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "breakdown", ofType: "wav")!))
            GameViewController.audioPlayer.prepareToPlay()
            GameViewController.audioPlayer.numberOfLoops = 10
        } catch {
            print(error)
        }
        
        SettingsMenu.runMusic(node: GameViewController.audioPlayer)
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
