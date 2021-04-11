//
//  InteractionToni.swift
//  UdinGame
//
//  Created by Dimas A. Prabowo on 10/04/21.
//

import SpriteKit

class InteractionToni: SKScene {
    var playerChat: SKLabelNode?
    var toniChat: SKLabelNode?
    var playerBubble: SKNode?
    var toniBubble: SKNode?
    
    var textToni0 = ""
    var textToni1 = ""
    var textPlayer0 = ""
    var textPlayer1 = ""
    
    var touchCount = 0
    
    // Navigation
    static var fromScene = ""
    
    // Text properties
    static var fontName = "Verdana"
    static var fontType = "Bold"
    static var fontColor = UIColor.brown
    
    override func didMove(to view: SKView) {
        playerBubble = childNode(withName: "playerBubble")
        toniBubble = childNode(withName: "toniBubble")
        
        playerChat = playerBubble?.childNode(withName: "playerChat") as? SKLabelNode
        toniChat = toniBubble?.childNode(withName: "toniChat") as? SKLabelNode
        
        if InteractionToni.fromScene != "BagpackScene" {
            BagpackScene.items.append("insight2")
        }
        
        GameScene.hasToniInsight = true
        
        playerBubble?.isHidden = true
        toniBubble?.isHidden = true
        
        setText()
    }
    
    func setText() {
        textToni0 = "Kamu kenal Udin? Dia dulu meraih tingkat pertama \ndi kelas kita namun semenjak semester baru"
        textPlayer0 = "Nggak ah ton, kasihan gitu anaknya pendiam"
        textToni1 = "Ah ga asik Lam..."
        textPlayer1 = "Tahu deh ton"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let playerChat = playerChat else { return }
        guard let toniChat = toniChat else { return }
        touchCount += 1
        
        switch touchCount {
        case 1:
            toniBubble?.isHidden = false
            textAlignment(label: toniChat, string: textToni0)
        case 2:
            toniBubble?.isHidden = true
            playerBubble?.isHidden = false
            textAlignment(label: playerChat, string: textPlayer0)
        case 3:
            playerBubble?.isHidden = true
            toniBubble?.isHidden = false
            textAlignment(label: toniChat, string: textToni1)
        case 4:
            toniBubble?.isHidden = true
            playerBubble?.isHidden = false
            textAlignment(label: playerChat, string: textPlayer1)
        case 5:
            if InteractionToni.fromScene == "BagpackScene" {
                let bagpackScene = SKScene(fileNamed: "BagpackScene")
                bagpackScene?.scaleMode = .aspectFill
                self.view?.presentScene(bagpackScene!, transition: SKTransition.fade(withDuration: 1.0))
            } else {
                GameScene.point += 10
                let gameScene = GameScene(fileNamed: "GameScene")
                gameScene?.scaleMode = .aspectFill
                self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: 1.0))
            }
        default:
            textAlignment(label: toniChat, string: textToni0)
        }
    }
    
    func textAlignment(label: SKLabelNode ,string: String) {
        let font = "\(InteractionToni.fontName)-\(InteractionToni.fontType)"
        let attrString = NSMutableAttributedString(string: string)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let range = NSRange(location: 0, length: string.count)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        attrString.addAttributes([NSAttributedString.Key.foregroundColor : InteractionToni.fontColor, NSAttributedString.Key.font : UIFont(name: font, size: 23.0)!], range: range)
        label.attributedText = attrString
    }
}
