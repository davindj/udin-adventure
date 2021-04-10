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
    
    var textToni = ""
    var textToni1 = ""
    var textPlayer = ""
    var textPlayer1 = ""
    
    var touchCount = 0
    
    static var fromScene = ""
    
    override func didMove(to view: SKView) {
        playerBubble = childNode(withName: "playerBubble")
        toniBubble = childNode(withName: "toniBubble")
        
        playerChat = playerBubble?.childNode(withName: "playerChat") as? SKLabelNode
        toniChat = toniBubble?.childNode(withName: "toniChat") as? SKLabelNode
        
        if InteractionToni.fromScene != "BagpackScene" {
            BagpackScene.items.append("insight2")
            GameScene.point += 10
        }
        
        playerBubble?.isHidden = true
        toniBubble?.isHidden = true
        
        setText()
    }
    
    func setText() {
        textToni = "Kamu kenal Udin? Dia dulu meraih tingkat pertama \ndi kelas kita namun semenjak semester baru"
        textPlayer = "Nggak ah ton, kasihan gitu anaknya pendiam"
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
            textAlignment(label: toniChat, string: textToni)
        case 2:
            toniBubble?.isHidden = true
            playerBubble?.isHidden = false
            textAlignment(label: playerChat, string: textPlayer)
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
                let gameScene = GameScene(fileNamed: "GameScene")
                gameScene?.scaleMode = .aspectFill
                self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: 1.0))
            }
        default:
            textAlignment(label: toniChat, string: textToni)
        }
    }
    
    func textAlignment(label: SKLabelNode ,string: String) {
        let attrString = NSMutableAttributedString(string: string)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let range = NSRange(location: 0, length: string.count)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        attrString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font : UIFont(name: "Verdana-Bold", size: 23.0)!], range: range)
        label.attributedText = attrString
    }
}
