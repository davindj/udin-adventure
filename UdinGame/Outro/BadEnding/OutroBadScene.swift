//
//  OutroBadScene.swift
//  UdinGame
//
//  Created by Dimas A. Prabowo on 12/04/21.
//

import Foundation
import SpriteKit

class OutroBadScene: SKScene {
    var story0: SKLabelNode?
    var story1: SKLabelNode?
    
    // Text properties
    static var fontName = "Verdana"
    static var fontType = "Bold"
    static var fontColor = UIColor.white
    
    static var touchCount = 0
    
    override func didMove(to view: SKView) {
        story0 = childNode(withName: "storyBadEnd0") as? SKLabelNode
        story1 = childNode(withName: "storyBadEnd1") as? SKLabelNode
        
        setText()
    }
    
    func setText() {
        let text0 = "Aku adalah murid baru kelas 4 pada salah satu Sekolah Dasar di Surabaya."
        let text1 = "Pada hari pertama masuk sekolah aku duduk sebangku dengan siswa bernama Udin."
        
        if let story0 = story0 {
            textAlignment(label: story0, string: text0)
        }
        
        if let story1 = story1 {
            textAlignment(label: story1, string: text1)
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
            let scene0 = SKScene(fileNamed: "OutroBad1")
            scene0?.scaleMode = .aspectFill
            self.view?.presentScene(scene0!, transition: SKTransition.crossFade(withDuration: 0.75))
        case 2:
            // Go to GameScene
            let scene4 = SKScene(fileNamed: "GameScene")
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
