//
//  UdinDiaryScene.swift
//  UdinGame
//
//  Created by Dimas A. Prabowo on 10/04/21.
//

import SpriteKit

class UdinDiaryScene: SKScene {
    var closeButton: SKNode?
    
    static var fromScene = ""
    
    // Sound and Music
    var backgroundMusic: SKAudioNode?
    var closeSound: SKAudioNode?
    
    override func didMove(to view: SKView) {
        closeButton = childNode(withName: "closeButton")
        backgroundMusic = childNode(withName: "backgroundMusic") as? SKAudioNode
        closeSound = childNode(withName: "closeSound") as? SKAudioNode
        
        if UdinDiaryScene.fromScene != "BagpackScene" {
            BagpackScene.items.append("diary")
        }
        
        GameScene.hasDiaryUdin = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            guard let closeSound = closeSound else { return }
            
            let touchButton = touch.location(in: self)
            let buttonPoint = atPoint(touchButton)
            
            if buttonPoint.name == "closeButton" {
                closeButton?.run(.setTexture(SKTexture(imageNamed: "closeButton2")))
                SettingsMenu.runSound(node: closeSound)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchButton = touch.location(in: self)
            let buttonPoint = atPoint(touchButton)
            
            if buttonPoint.name == "closeButton" {
                closeButton?.run(.setTexture(SKTexture(imageNamed: "closeButton")))
                
                if UdinDiaryScene.fromScene == "BagpackScene" {
                    let bagpackScene = SKScene(fileNamed: "BagpackScene")
                    bagpackScene?.scaleMode = .aspectFill
                    self.view?.presentScene(bagpackScene!, transition: SKTransition.fade(withDuration: 1.0))
                } else {
                    GameScene.point += 10
                    let scene = SKScene(fileNamed: "GameScene")
                    scene?.scaleMode = .aspectFill
                    self.view?.presentScene(scene!, transition: SKTransition.fade(withDuration: 1.0))
                }
            }
        }
    }
}
