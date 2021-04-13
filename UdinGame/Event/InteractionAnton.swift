//
//  InteractionAnton.swift
//  UdinGame
//
//  Created by Michael Hans on 09/04/21.
//

import Foundation
import SpriteKit

class InteractionAnton: SKScene {
    
    var antonBubble: SKNode?
    var playerBubble: SKNode?
    var antonSay: SKLabelNode?
    var playerSay: SKLabelNode?
    var answerButton1: SKNode?
    var answerButton2: SKNode?
    var opsiA: SKLabelNode?
    var opsiB: SKLabelNode?
    
    var touchCount = 0
    
    static var fromScene = ""
    
    // Player Answer
    static var answer = 0
    
    // Set text
    var text1 = ""
    var text2 = ""
    var text3 = ""
    var opsi1 = ""
    var opsi2 = ""
    var answer1 = ""
    var answer2 = ""
    
    // Text properties
    static var fontName = "Verdana"
    static var fontType = "Bold"
    static var fontColor = UIColor.black
    
    override func didMove(to view: SKView) {
        antonBubble = childNode(withName: "antonBubble")
        playerBubble = childNode(withName: "playerBubble")
        answerButton1 = childNode(withName: "answerButton1")
        answerButton2 = childNode(withName: "answerButton2")
        antonSay = antonBubble?.childNode(withName: "antonSay") as? SKLabelNode
        playerSay = playerBubble?.childNode(withName: "playerSay") as? SKLabelNode
        opsiA = answerButton1?.childNode(withName: "label1") as? SKLabelNode
        opsiB = answerButton2?.childNode(withName: "label2") as? SKLabelNode
        
        setText()
        
        GameScene.hasAntonInsight = true
        
        if InteractionAnton.fromScene != "BagpackScene" {
            BagpackScene.items.append("insight1")
        } else {
            answerButton1?.isHidden = true
            answerButton2?.isHidden = true
            antonBubble?.isHidden = true
            playerBubble?.isHidden = true
        }
    }
    
    func setText() {
        guard let antonsay = antonSay else { return }
        guard let playersay = playerSay else { return }
        guard let opsiA = opsiA else { return }
        guard let opsiB = opsiB else { return }
        
        text1 = "Heii anak baru, ayo kita kerjain si Udin."
        text2 = "....[Pilih opsi di bawah ini \n untuk menentukan alur cerita]"
        text3 = ""
        opsi1 = "Kenapa senang sekali ngerjain dia?"
        opsi2 = "Haha, ayo kita usilin seperti apa?"
        answer1 = "Salah dia menyendiri terus, diajak main \nmalah ngusir. Sombong sekali dia"
        answer2 = "Curi saja diarinya, dia sering tidak fokus \ndi kelas dan malah mencoret-coret bukunya. \nParah sekali sih."
        
        textAlignment(label: antonsay, string: text1)
        textAlignment(label: playersay, string: text2)
        textAlignment(label: opsiA, string: opsi1)
        textAlignment(label: opsiB, string: opsi2)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let antonSay = antonSay else { return }
        guard let playerSay = playerSay else { return }
        
        for touch in touches {
            let locationButton = touch.location(in: self)
            let buttonName = atPoint(locationButton)
            
            if buttonName.name == "answerButton1" || buttonName.name == "label1" {
                touchCount += 1
                answerButton1?.run(.setTexture(SKTexture(imageNamed: "longButtonA2")))
            } else if buttonName.name == "answerButton2" || buttonName.name == "label2" {
                touchCount += 1
                answerButton2?.run(.setTexture(SKTexture(imageNamed: "longButtonB2")))
            }
            
            // Start talk after choose answer
            if InteractionAnton.answer > 0 && InteractionAnton.fromScene != "BagpackScene" {
                touchCount += 1
                
                // Set answer
                if InteractionAnton.answer == 1 {
                    text3 = answer1
                } else if InteractionAnton.answer == 2 {
                    text3 = answer2
                }
                
                if touchCount == 2 {
                    playerBubble?.isHidden = true
                    antonBubble?.isHidden = false
                    textAlignment(label: antonSay, string: text3)
                } else if touchCount == 3 {
                    if let gameScene = SKScene(fileNamed: "GameScene") {
                        gameScene.scaleMode = .aspectFit
                        self.view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: 1.0))
                    }
                }
            }
            
            // MARK: Bagpack Scene Scenario
            // From bagpack scene scenario
            if InteractionAnton.fromScene == "BagpackScene" {
                touchCount += 1
                
                // Set answer
                if InteractionAnton.answer == 1 {
                    text2 = opsi1
                    text3 = answer1
                } else if InteractionAnton.answer == 2 {
                    text2 = opsi2
                    text3 = answer2
                }
                
                switch touchCount {
                case 1:
                    antonBubble?.isHidden = false
                    textAlignment(label: antonSay, string: text1)
                case 2:
                    antonBubble?.isHidden = true
                    playerBubble?.isHidden = false
                    textAlignment(label: playerSay, string: text2)
                case 3:
                    antonBubble?.isHidden = false
                    playerBubble?.isHidden = true
                    textAlignment(label: antonSay, string: text3)
                case 4:
                    if let bagpackScene = SKScene(fileNamed: "BagpackScene") {
                        bagpackScene.scaleMode = .aspectFit
                        self.view?.presentScene(bagpackScene, transition: SKTransition.fade(withDuration: 1.0))
                    }
                default:
                    antonBubble?.isHidden = true
                    playerBubble?.isHidden = true
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let locationButton = touch.location(in: self)
            let buttonName = atPoint(locationButton)
            
            if buttonName.name == "answerButton1" || buttonName.name == "label1" {
                answerButton1?.run(.setTexture(SKTexture(imageNamed: "longButtonA")))
                InteractionAnton.answer = 1
                GameScene.point += 10
            } else if buttonName.name == "answerButton2" || buttonName.name == "label2" {
                answerButton2?.run(.setTexture(SKTexture(imageNamed: "longButtonB")))
                InteractionAnton.answer = 2
                GameScene.point -= 10
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard let playerSay = playerSay else { return }
        
        if InteractionAnton.answer > 0 && InteractionAnton.fromScene != "BagpackScene" && touchCount < 2 {
            answerButton1?.isHidden = true
            answerButton2?.isHidden = true
            playerBubble?.isHidden = false
            antonBubble?.isHidden = true
            
            // Set answer
            if InteractionAnton.answer == 1 {
                text2 = opsi1
            } else if InteractionAnton.answer == 2 {
                text2 = opsi2
            }
            
            // Anton talk back
            textAlignment(label: playerSay, string: text2)
        }
        
        
    }
    
    func textAlignment(label: SKLabelNode ,string: String) {
        let font = "\(InteractionYusuf.fontName)-\(InteractionYusuf.fontType)"
        let attrString = NSMutableAttributedString(string: string)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let range = NSRange(location: 0, length: string.count)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        attrString.addAttributes([NSAttributedString.Key.foregroundColor : InteractionAnton.fontColor, NSAttributedString.Key.underlineColor: UIColor.black, NSAttributedString.Key.font : UIFont(name: font, size: 32.0)!], range: range)
        label.attributedText = attrString
    }
}
