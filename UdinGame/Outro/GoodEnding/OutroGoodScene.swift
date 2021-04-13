//
//  OutroGoodScene.swift
//  UdinGame
//
//  Created by Dimas A. Prabowo on 12/04/21.
//

import Foundation
import SpriteKit

class OutroGoodScene: SKScene {
    var textBubbleGood: SKNode?
    var textGoodEnd0: SKLabelNode?
    var textGoodEnd1: SKLabelNode?
    var recapGoodEnd: SKLabelNode?
    
    // Text properties
    static var fontName = "Verdana"
    static var fontType = "Bold"
    static var fontColor = UIColor.brown
    
    static var touchCount = 0
    
    override func didMove(to view: SKView) {
        textBubbleGood = childNode(withName: "textBubbleGood")
        textGoodEnd0 = textBubbleGood?.childNode(withName: "textGoodEnd0") as? SKLabelNode
        textGoodEnd1 = textBubbleGood?.childNode(withName: "textGoodEnd1") as? SKLabelNode
        recapGoodEnd = childNode(withName: "recapGoodEnd") as? SKLabelNode
        
        textBubbleGood?.isHidden = true
        setText()
    }
    
    func setText() {
        
        let goodEndText0 = "Selamat! Anda berhasil mengembalikan kepercayaan diri Udin dan membuat Udin \nsemangat kembali. Berkat bantuanmu, Udin dapat lebih menghargai dirinya dan sesamanya."
        let goodEndText1 = "Menghadapi orang yang memiliki depresi \ntentunya tidaklah mudah dan dibutuhkan kesabaran. Oleh karena itu, \njangan mudah mengecap orang dan mulailah mencoba untuk mengenalinya."
        let recapGoodEndText = "Pada hari pertama masuk sekolah aku duduk sebangku dengan siswa bernama Udin."
        
        if let textGoodEnd0 = textGoodEnd0 {
            textAlignment(label: textGoodEnd0, string: goodEndText0)
        }
        
        if let textGoodEnd1 = textGoodEnd1 {
            textAlignment(label: textGoodEnd1, string: goodEndText1)
        }
        
        if let recapGoodEnd = recapGoodEnd {
            textAlignment(label: recapGoodEnd, string: recapGoodEndText)
        }
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
        OutroGoodScene.touchCount += 1
        
        switch OutroGoodScene.touchCount {
        case 1:
            // Show text
            textBubbleGood?.isHidden = false
        case 2:
            // Go to Credit
            let scene1 = SKScene(fileNamed: "Credit")
            scene1?.scaleMode = .aspectFit
            self.view?.presentScene(scene1!, transition: SKTransition.fade(withDuration: 1.0))
        default:
            // default in Intro0
            let scene0 = SKScene(fileNamed: "OutroGood0")
            scene0?.scaleMode = .aspectFit
            self.view?.presentScene(scene0!, transition: SKTransition.fade(withDuration: 1.0))
        }
    }
}
