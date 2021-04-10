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
       Aku adalah murid baru kelas 4 pada salah satu Sekolah Dasar di Surabaya.
        """
        let text2 = "Pada hari pertama masuk sekolah aku duduk sebangku dengan siswa bernama Udin."
        let text3 = "Namun sifatnya sangat tertutup, dia enggan berbicara banyak dengan ku."
        let text4 = "Karena sifat tertutup itu, dia sering dijahili oleh teman-temannya yang lain terutama oleh Anton, Toni, dan Yusuf."
        let text5 = "Kira-kira apa yang harus aku lakukan agar dapat mengetahui mengapa sift Udin seperti itu?"
        
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
            self.view?.presentScene(scene1!, transition: SKTransition.crossFade(withDuration: 0.75))
        case 2:
            // scene2
            let scene1 = SKScene(fileNamed: "Intro3")
            scene1?.scaleMode = .aspectFill
            self.view?.presentScene(scene1!, transition: SKTransition.crossFade(withDuration: 0.75))
        case 3:
            // scene2
            let scene1 = SKScene(fileNamed: "Intro4")
            scene1?.scaleMode = .aspectFill
            self.view?.presentScene(scene1!, transition: SKTransition.crossFade(withDuration: 0.75))
        case 4:
            // scene2
            let scene1 = SKScene(fileNamed: "Intro5")
            scene1?.scaleMode = .aspectFill
            self.view?.presentScene(scene1!, transition: SKTransition.crossFade(withDuration: 0.75))
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
