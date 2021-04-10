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
    
    override func didMove(to view: SKView) {
        playerChat = childNode(withName: "playerChat") as? SKLabelNode
        yusufChat = childNode(withName: "yusufChat") as? SKLabelNode
        playerBubble = childNode(withName: "playerBubble")
        yusufBubble = childNode(withName: "yusufBubble")
        GameScene.point += 10
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameScene = GameScene(fileNamed: "GameScene")
        gameScene?.scaleMode = .aspectFill
        self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: 1.0))
    }
    
    func textAlignment(label: SKLabelNode ,string: String) {
        let attrString = NSMutableAttributedString(string: string)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let range = NSRange(location: 0, length: string.count)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        attrString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 48)], range: range)
        label.attributedText = attrString
    }
}
