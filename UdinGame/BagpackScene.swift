//
//  BagpackScene.swift
//  UdinGame
//
//  Created by Dimas A. Prabowo on 09/04/21.
//

import SpriteKit

class BagpackScene: SKScene {
    
    var closeButton: SKNode?
    
    override func didMove(to view: SKView) {
        closeButton = childNode(withName: "closeButton")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let locationButton = touch.location(in: self)
            let buttonName = atPoint(locationButton)
            
            if buttonName.name == "closeButton" {
                buttonName.run(.setTexture(SKTexture(imageNamed: "bagcloseButton2")))
                
                //Back to GameScene
                let gameScene = GameScene(fileNamed: "GameScene")
                gameScene?.scaleMode = .aspectFill
                self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: 0.5))
            }
        }
    }
}
