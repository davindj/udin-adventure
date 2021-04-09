//
//  SettingsMenu.swift
//  UdinGame
//
//  Created by Alamsyah Oktavian on 08/04/21.
//

import SpriteKit

class SettingsMenu: SKScene {
    
    var closeButton: SKNode!
    var musicButton: SKNode!
    var soundButton: SKNode!
    var vibrateButton: SKNode!
    var emailButton: SKNode!
        
    override func didMove(to view: SKView) {
        closeButton = childNode(withName: "closeButton")
        musicButton = childNode(withName: "musicButton")
        soundButton = childNode(withName: "soundButton")
        vibrateButton = childNode(withName: "vibrateButton")
        emailButton = childNode(withName: "emailButton")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let locationButton = touch.location(in: self)
            let buttonName = atPoint(locationButton)
            
            if buttonName.name == "closeButton" {
                buttonName.run(.setTexture(SKTexture(imageNamed: "bagcloseButton")))
                
                //Back to GameScene
                let gameScene = GameScene(fileNamed: "GameScene")
                gameScene?.scaleMode = .aspectFill
                self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: 0.5))
            }
        }
    }
    
  
}
