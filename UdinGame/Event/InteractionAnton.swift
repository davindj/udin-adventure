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
    var antonsay: SKLabelNode!
    var udinsay: SKLabelNode!
    
    static var fromScene = ""
    
    override func didMove(to view: SKView) {
        answerButton1 = childNode(withName: "answerButton1")
        answerButton2 = childNode(withName: "answerButton2")
        antonsay = childNode(withName: "antonsay") as? SKLabelNode
        udinsay = childNode(withName: "udinsay") as? SKLabelNode
        setText()
        GameScene.hasAntonInsight = true
    }
    
    func setText() {
        let text1 = "Heii anak baru, ayo kita kerjain si Udin."
        let text2 = "....[Pilih opsi di bawah ini \n untuk menentukan alur cerita]"
        
        if let antonsay = antonsay {
            textAlignment(label: antonsay, string: text1)}
        
        if let udinsay = udinsay {
            textAlignment(label: udinsay, string: text2)}
        
    }
    
    func textAlignment(label: SKLabelNode ,string: String) {
        let attrString = NSMutableAttributedString(string: string)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let range = NSRange(location: 0, length: string.count)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        attrString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.underlineColor: UIColor.black, NSAttributedString.Key.font : UIFont(name: "Verdana-Bold", size: 48.0)!], range: range)
        label.attributedText = attrString
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
                GameScene.point += 10
                //Back to GameScene
                let gameScene = GameScene(fileNamed: "GameScene")
                gameScene?.scaleMode = .aspectFill
                self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: 0.5))
            }
            else if buttonName.name == "answerButton2" {
                answerButton2?.run(.setTexture(SKTexture(imageNamed: "longButton")))
                GameScene.point -= 10
                //Back to GameScene
                let gameScene = GameScene(fileNamed: "GameScene")
                gameScene?.scaleMode = .aspectFill
                self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: 0.5))
           }
        }
    }
}
