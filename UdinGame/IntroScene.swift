//
//  IntroScene.swift
//  UdinGame
//
//  Created by Dimas A. Prabowo on 09/04/21.
//

import SpriteKit

class IntroScene: SKScene {
    var story1: SKLabelNode?
    var story2: SKLabelNode?
    var story3: SKLabelNode?
    var story4: SKLabelNode?
    var story5: SKLabelNode?
    
    static var touchCount = 0
    
    override func didMove(to view: SKView) {
        story1 = childNode(withName: "story1") as? SKLabelNode
        story2 = childNode(withName: "story2") as? SKLabelNode
        story3 = childNode(withName: "story3") as? SKLabelNode
        story4 = childNode(withName: "story4") as? SKLabelNode
        story5 = childNode(withName: "story5") as? SKLabelNode
        
        setText()
    }
    
    func setText() {
        let text1 = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
        incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud
        exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
        """
        let text2 = "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu \nfugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui \nofficia deserunt mollit anim id est laborum."
        let text3 = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque \nlaudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi \narchitecto beatae vitae dicta sunt explicabo."
        let text4 = "Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia \nconsequuntur magni dolores eos qui ratione voluptatem sequi nesciunt."
        let text5 = "Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, \nadipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam \naliquam quaerat voluptatem."
        
        if let story1 = story1 {
            textAlignment(label: story1, string: text1)
        }
        
        if let story2 = story2 {
            textAlignment(label: story2, string: text2)
        }
        
        if let story3 = story3 {
            textAlignment(label: story3, string: text3)
        }
        
        if let story4 = story4 {
            textAlignment(label: story4, string: text4)
        }
        
        if let story5 = story5 {
            textAlignment(label: story5, string: text5)
        }
        
    }
    
    func textAlignment(label: SKLabelNode ,string: String) {
        let attrString = NSMutableAttributedString(string: string)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let range = NSRange(location: 0, length: string.count)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        attrString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 32)], range: range)
        label.attributedText = attrString
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        IntroScene.touchCount += 1
        
        switch IntroScene.touchCount {
        case 1:
            // scene2
            let scene1 = SKScene(fileNamed: "Intro2")
            scene1?.scaleMode = .aspectFill
            self.view?.presentScene(scene1!, transition: SKTransition.flipVertical(withDuration: 1.0))
        case 2:
            // scene2
            let scene1 = SKScene(fileNamed: "Intro3")
            scene1?.scaleMode = .aspectFill
            self.view?.presentScene(scene1!, transition: SKTransition.flipVertical(withDuration: 1.0))
        case 3:
            // scene2
            let scene1 = SKScene(fileNamed: "Intro4")
            scene1?.scaleMode = .aspectFill
            self.view?.presentScene(scene1!, transition: SKTransition.flipVertical(withDuration: 1.0))
        case 4:
            // scene2
            let scene1 = SKScene(fileNamed: "Intro5")
            scene1?.scaleMode = .aspectFill
            self.view?.presentScene(scene1!, transition: SKTransition.flipVertical(withDuration: 1.0))
        case 5:
            // scene2
            let scene1 = SKScene(fileNamed: "GameScene")
            scene1?.scaleMode = .aspectFill
            self.view?.presentScene(scene1!, transition: SKTransition.fade(withDuration: 1.0))
        default:
            let scene1 = SKScene(fileNamed: "Intro1")
            scene1?.scaleMode = .aspectFill
            self.view?.presentScene(scene1!, transition: SKTransition.fade(withDuration: 1.0))
        }
    }
}
