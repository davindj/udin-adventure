//
//  OutroGoodScene.swift
//  UdinGame
//
//  Created by Dimas A. Prabowo on 12/04/21.
//

import Foundation
import SpriteKit

class OutroGoodScene: SKScene {
    var textGoodEnd: SKLabelNode?
    var recapGoodEnd: SKLabelNode?
    
    // Text properties
    static var fontName = "Verdana"
    static var fontType = "Bold"
    static var fontColor = UIColor.white
    
    static var touchCount = 0
    
    override func didMove(to view: SKView) {
        textGoodEnd = childNode(withName: "textGoodEnd") as? SKLabelNode
        recapGoodEnd = childNode(withName: "recapGoodEnd") as? SKLabelNode
        
        setText()
    }
    
    func setText() {
        let goodEndText = "Aku adalah murid baru kelas 4 pada salah satu Sekolah Dasar di Surabaya."
        let recapGoodEndText = "Pada hari pertama masuk sekolah aku duduk sebangku dengan siswa bernama Udin."
        
        if let textGoodEnd = textGoodEnd {
            textAlignment(label: textGoodEnd, string: goodEndText)
        }
        
        if let recapGoodEnd = recapGoodEnd {
            textAlignment(label: recapGoodEnd, string: recapGoodEndText)
        }
    }
    
    func textAlignment(label: SKLabelNode ,string: String) {
        let font = "\(IntroScene.fontName)-\(IntroScene.fontType)"
        let attrString = NSMutableAttributedString(string: string)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let range = NSRange(location: 0, length: string.count)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        attrString.addAttributes([NSAttributedString.Key.foregroundColor : IntroScene.fontColor, NSAttributedString.Key.underlineColor: UIColor.black, NSAttributedString.Key.font : UIFont(name: font, size: 48.0)!], range: range)
        label.attributedText = attrString
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        IntroScene.touchCount += 1
        
        switch IntroScene.touchCount {
        case 1:
            // Go to Intro1
            let scene0 = SKScene(fileNamed: "OutroGood1")
            scene0?.scaleMode = .aspectFill
            self.view?.presentScene(scene0!, transition: SKTransition.crossFade(withDuration: 0.75))
        case 2:
            // Go to GameScene
            let scene1 = SKScene(fileNamed: "Credit")
            scene1?.scaleMode = .aspectFill
            self.view?.presentScene(scene1!, transition: SKTransition.fade(withDuration: 1.0))
        default:
            // default in Intro0
            let scene0 = SKScene(fileNamed: "OutroGood0")
            scene0?.scaleMode = .aspectFill
            self.view?.presentScene(scene0!, transition: SKTransition.fade(withDuration: 1.0))
        }
    }
}
