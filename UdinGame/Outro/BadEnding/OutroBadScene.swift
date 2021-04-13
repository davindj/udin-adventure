//
//  OutroBadScene.swift
//  UdinGame
//
//  Created by Dimas A. Prabowo on 12/04/21.
//

import Foundation
import SpriteKit

class OutroBadScene: SKScene {
    var textBadEnd: SKLabelNode?
    var recapBadEnd: SKLabelNode?
    
    // Text properties
    static var fontName = "Verdana"
    static var fontType = "Bold"
    static var fontColor = UIColor.brown
    
    static var touchCount = 0
    
    override func didMove(to view: SKView) {
        let textBubbleBad = childNode(withName: "textBubbleBad")
        textBadEnd = textBubbleBad?.childNode(withName: "textBadEnd0") as? SKLabelNode
        recapBadEnd = textBubbleBad?.childNode(withName: "textBadEnd1") as? SKLabelNode
        
        setText()
    }
    
    func setText() {
        let textBadEndText = "Sayang sekali namun Anda tidak berhasil membantu memecahkan masalah Udin.\nHal ini dibutuhkan kesabaran dan pengertian."
        let recapBadEndText = "Oleh karena itu, jangan mudah mengecap orang dan mulailah mencoba untuk mengenalinya.\nTindakan kecil dapat membawakan dampak yang besar bagi seseorang."
        
        guard let textBadEnd = textBadEnd else {
            fatalError("Text Bad End 0 tidak ditemukan")
        }
        guard let recapBadEnd = recapBadEnd else {
            fatalError("Text Bad End 1 tidak ditemukan")
        }
        
        textAlignment(label: textBadEnd, string: textBadEndText)
        textAlignment(label: recapBadEnd, string: recapBadEndText)
    }
    
    func textAlignment(label: SKLabelNode ,string: String) {
        let font = "\(OutroGoodScene.fontName)-\(OutroGoodScene.fontType)"
        let attrString = NSMutableAttributedString(string: string)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let range = NSRange(location: 0, length: string.count)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        attrString.addAttributes([NSAttributedString.Key.foregroundColor : OutroGoodScene.fontColor, NSAttributedString.Key.font : UIFont(name: font, size: 32.0)!], range: range)
        label.attributedText = attrString
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        IntroScene.touchCount += 1
        
        switch IntroScene.touchCount {
        case 1:
            // Go to GameScene
            let scene4 = SKScene(fileNamed: "Credit")
            scene4?.scaleMode = .aspectFill
            self.view?.presentScene(scene4!, transition: SKTransition.fade(withDuration: 1.0))
        default:
            // default in Intro0
            let scene0 = SKScene(fileNamed: "OutroBad0")
            scene0?.scaleMode = .aspectFill
            self.view?.presentScene(scene0!, transition: SKTransition.fade(withDuration: 1.0))
        }
    }
}
