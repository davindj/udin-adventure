//
//  InteractionAnton.swift
//  UdinGame
//
//  Created by Michael Hans on 09/04/21.
//

import Foundation
import SpriteKit

class InteractionAnton: SKScene {
    
    var answerButton1: SKNode!
    var answerButton2: SKNode!
    
    override func didMove(to view: SKView) {
        answerButton1 = childNode(withName: "answerButton1")
        answerButton2 = childNode(withName: "answerButton2")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let locationButton = touch.location(in: self)
            let buttonName = atPoint(locationButton)
            
            if buttonName.name == "answerButton1" {
                answerButton1?.run(.setTexture(SKTexture(imageNamed: "longButton2")))
            }
            else if buttonName.name == "answerButton2" {
                answerButton2?.run(.setTexture(SKTexture(imageNamed: "longButton2")))
            }
            
            
            if buttonName.name == "closeButton" {
                buttonName.run(.setTexture(SKTexture(imageNamed: "bagcloseButton")))
                
                //Back to GameScene
                let gameScene = GameScene(fileNamed: "GameScene")
                gameScene?.scaleMode = .aspectFill
                self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: 0.5))
            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let locationButton = touch.location(in: self)
            let buttonName = atPoint(locationButton)
            
            if buttonName.name == "answerButton1" {
                answerButton1?.run(.setTexture(SKTexture(imageNamed: "longButton")))
            }
            else if buttonName.name == "answerButton2" {
                answerButton2?.run(.setTexture(SKTexture(imageNamed: "longButton")))
           }
        }
    }
}
