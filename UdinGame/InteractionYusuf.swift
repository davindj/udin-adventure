//
//  InteractionYusuf.swift
//  UdinGame
//
//  Created by Dimas A. Prabowo on 10/04/21.
//

import SpriteKit

class InteractionYusuf: SKScene {
    var playerChat: SKLabelNode?
    var yusufChat: SKLabelNode?
    var playerBubble: SKNode?
    var yusufBubble: SKNode?
    
    var textYusuf = ""
    var textYusuf1 = ""
    var textYusuf2 = ""
    var textPlayer = ""
    var textPlayer1 = ""
    
    var touchCount = 0
    
    static var fromScene = ""
    
    override func didMove(to view: SKView) {
        playerBubble = childNode(withName: "playerBubble")
        yusufBubble = childNode(withName: "yusufBubble")
        
        playerChat = playerBubble?.childNode(withName: "playerChat") as? SKLabelNode
        yusufChat = yusufBubble?.childNode(withName: "yusufChat") as? SKLabelNode
        
        if InteractionYusuf.fromScene != "BagpackScene" {
            BagpackScene.items.append("insight1")
            GameScene.point += 10
        }
        
        GameScene.hasYusufInsight = true
        
        playerBubble?.isHidden = true
        yusufBubble?.isHidden = true
        
        setText()
    }
    
    func setText() {
        textYusuf = "Kamu tahu tidak dulu Udin \nanaknya ceria dan asik sekali. \nTidak seperti sekarang, penyendiri"
        textPlayer = "Oh ya? Kenapa dia berubah?"
        textYusuf1 = "Kurang tahu sih, tapi akhir-akhir ini \ndia sering kali datang dan \npulang dari sekolah sendiri juga"
        textPlayer1 = "Emangnya dia biasanya \nbersama orang tuanya kah?"
        textYusuf2 = "Iya, biasanya Ibunya siap menjemputnya \nbahkan sebelum bel berbunyi \nibunya sudah berada di gerbang sekolah"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let playerChat = playerChat else { return }
        guard let yusufChat = yusufChat else { return }
        touchCount += 1
        
        switch touchCount{
        case 1:
            yusufBubble?.isHidden = false
            textAlignment(label: yusufChat, string: textYusuf)
        case 2:
            yusufBubble?.isHidden = true
            playerBubble?.isHidden = false
            textAlignment(label: playerChat, string: textPlayer)
        case 3:
            playerBubble?.isHidden = true
            yusufBubble?.isHidden = false
            textAlignment(label: yusufChat, string: textYusuf1)
        case 4:
            yusufBubble?.isHidden = true
            playerBubble?.isHidden = false
            textAlignment(label: playerChat, string: textPlayer1)
        case 5:
            playerBubble?.isHidden = true
            yusufBubble?.isHidden = false
            textAlignment(label: yusufChat, string: textYusuf2)
        case 6:
            if InteractionYusuf.fromScene == "BagpackScene" {
                let bagpackScene = SKScene(fileNamed: "BagpackScene")
                bagpackScene?.scaleMode = .aspectFill
                self.view?.presentScene(bagpackScene!, transition: SKTransition.fade(withDuration: 1.0))
            } else {
                let gameScene = SKScene(fileNamed: "GameScene")
                gameScene?.scaleMode = .aspectFill
                self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: 1.0))
            }
        default:
            textAlignment(label: yusufChat, string: textYusuf1)
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
