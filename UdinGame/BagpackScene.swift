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
        print(GameScene.point)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let locationButton = touch.location(in: self)
            let buttonPoint = atPoint(locationButton)
            
            switch buttonPoint.name {
            case "closeButton":
                closeButton!.run(.setTexture(SKTexture(imageNamed: "bagcloseButton2")))
            default:
                print("")
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let locationButton = touch.location(in: self)
            let buttonPoint = atPoint(locationButton)
            
            switch buttonPoint.name {
            case "closeButton":
                closeButton!.run(.setTexture(SKTexture(imageNamed: "bagcloseButton")))
                
                //Back to GameScene
                let gameScene = GameScene(fileNamed: "GameScene")
                gameScene?.scaleMode = .aspectFill
                self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: 1.0))
            default:
                print("")
            }
        }
    }
}
