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
    var story2: SKLabelNode?
    var story3: SKLabelNode?
    var story4: SKLabelNode?
    
    // Text properties
    static var fontName = "Verdana"
    static var fontType = "Bold"
    static var fontColor = UIColor.white
    
    static var touchCount = 0
    
    override func didMove(to view: SKView) {
        story0 = childNode(withName: "storyBadEnd0") as? SKLabelNode
        story1 = childNode(withName: "storyBadEnd1") as? SKLabelNode
        story2 = childNode(withName: "storyBadEnd2") as? SKLabelNode
        story3 = childNode(withName: "storyBadEnd3") as? SKLabelNode
        story4 = childNode(withName: "storyBadEnd4") as? SKLabelNode
        
        setText()
    }
    
    func setText() {
        let text0 = "Aku adalah murid baru kelas 4 pada salah satu Sekolah Dasar di Surabaya."
        let text1 = "Pada hari pertama masuk sekolah aku duduk sebangku dengan siswa bernama Udin."
        let text2 = "Namun sifatnya sangat tertutup, dia enggan berbicara banyak dengan ku."
        let text3 = "Karena sifat tertutup itu, dia sering dijahili oleh teman-temannya."
        let text4 = "Kira-kira apa yang harus aku lakukan agar dapat mengetahui \nmengapa sifat Udin seperti itu?"
        
        if let story0 = story0 {
            textAlignment(label: story0, string: text0)
        }
        
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
            // Go to Intro2
            let scene1 = SKScene(fileNamed: "OutroBad2")
            scene1?.scaleMode = .aspectFill
            self.view?.presentScene(scene1!, transition: SKTransition.crossFade(withDuration: 0.75))
        case 3:
            // Go to Intro3
            let scene2 = SKScene(fileNamed: "OutroBad3")
            scene2?.scaleMode = .aspectFill
            self.view?.presentScene(scene2!, transition: SKTransition.crossFade(withDuration: 0.75))
        case 4:
            // Go to Intro4
            let scene3 = SKScene(fileNamed: "OutroBad4")
            scene3?.scaleMode = .aspectFill
            self.view?.presentScene(scene3!, transition: SKTransition.crossFade(withDuration: 0.75))
        case 5:
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
