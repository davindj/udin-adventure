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
    
    static var touchCount = 0
    
    override func didMove(to view: SKView) {
        playerBubble = childNode(withName: "playerBubble")
        toniBubble = childNode(withName: "toniBubble")
        
        playerChat = playerBubble?.childNode(withName: "playerChat") as? SKLabelNode
        toniChat = toniBubble?.childNode(withName: "toniBubble") as? SKLabelNode
       
        GameScene.point += 10
        
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
        guard let yusufChat = toniChat else { return }
        InteractionYusuf.touchCount += 1
        
        switch InteractionYusuf.touchCount {
        case 1:
            toniBubble?.isHidden = false
            textAlignment(label: yusufChat, string: textToni)
        case 2:
            playerBubble?.isHidden = false
            textAlignment(label: playerChat, string: textPlayer)
        case 3:
            textAlignment(label: yusufChat, string: textToni1)
        case 4:
            textAlignment(label: playerChat, string: textPlayer1)
        case 5:
            let gameScene = GameScene(fileNamed: "GameScene")
            gameScene?.scaleMode = .aspectFill
            self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: 1.0))
        default:
            textAlignment(label: yusufChat, string: textToni)
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
