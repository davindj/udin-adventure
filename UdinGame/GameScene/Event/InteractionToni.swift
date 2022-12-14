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
    
    var textToni0 = ""
    var textToni1 = ""
    var textToni2 = ""
    var textToni3 = ""
    var textPlayer0 = ""
    var textPlayer1 = ""
    var textPlayer2 = ""
    var textPlayer3 = ""
    
    var touchCount = 0
    
    // Navigation
    static var fromScene = ""
    
    // Text properties
    static var fontName = "Verdana"
    static var fontType = "Bold"
    static var fontColor = UIColor.brown
    
    // Sound and Music
    var backgroundMusic: SKAudioNode?
    var playerChatSound: SKAudioNode?
    var toniChatSound: SKAudioNode?
    var closeSound: SKAudioNode?
    
    override func didMove(to view: SKView) {
        playerBubble = childNode(withName: "playerBubble")
        toniBubble = childNode(withName: "toniBubble")
        
        playerChat = playerBubble?.childNode(withName: "playerChat") as? SKLabelNode
        toniChat = toniBubble?.childNode(withName: "toniChat") as? SKLabelNode
        
        backgroundMusic = childNode(withName: "backgroundMusic") as? SKAudioNode
        playerChatSound = childNode(withName: "playerChatSound") as? SKAudioNode
        toniChatSound = childNode(withName: "toniChatSound") as? SKAudioNode
        closeSound = childNode(withName: "closeSound") as? SKAudioNode
        
        GameScene.hasToniInsight = true
        
        playerBubble?.isHidden = true
        toniBubble?.isHidden = true
        
        if InteractionToni.fromScene != "BagpackScene" {
            BagpackScene.items.append("insight2")
        }
        
        setText()
    }
    
    func setText() {
        textToni0 = "Hei anak baru! Main basket yuk"
        textPlayer0 = "Wah boleh, siapa saja yang ikut?"
        textToni1 = "Semua anak-anak kelas ini \nkecuali Udin mungkin. Dia mah \norangnya tidak punya hobi."
        textPlayer1 = "Masa sih? setiap orang kan \npasti suka melakukan sesuatu."
        textToni2 = "Setiap orang kecuali Udin, \ncuek sekali orangnya."
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let playerChatSound = playerChatSound else { return }
        guard let toniChatSound = toniChatSound else { return }
        guard let closeSound = closeSound else { return }
        
        guard let playerChat = playerChat else { return }
        guard let toniChat = toniChat else { return }
        touchCount += 1
        print(touchCount)
        
        switch touchCount {
        case 1:
            toniBubble?.isHidden = false
            textAlignment(label: toniChat, string: textToni0)
            SettingsMenu.runSound(node: toniChatSound)
        case 2:
            toniBubble?.isHidden = true
            playerBubble?.isHidden = false
            textAlignment(label: playerChat, string: textPlayer0)
            SettingsMenu.runSound(node: playerChatSound)
        case 3:
            playerBubble?.isHidden = true
            toniBubble?.isHidden = false
            textAlignment(label: toniChat, string: textToni1)
            SettingsMenu.runSound(node: toniChatSound)
        case 4:
            toniBubble?.isHidden = true
            playerBubble?.isHidden = false
            textAlignment(label: playerChat, string: textPlayer1)
            SettingsMenu.runSound(node: playerChatSound)
        case 5:
            toniBubble?.isHidden = false
            textAlignment(label: toniChat, string: textToni2)
            SettingsMenu.runSound(node: toniChatSound)
        default:
            SettingsMenu.runSound(node: closeSound)
            
            if InteractionToni.fromScene == "BagpackScene" {
                let bagpackScene = SKScene(fileNamed: "BagpackScene")
                bagpackScene?.scaleMode = .aspectFit
                self.view?.presentScene(bagpackScene!, transition: SKTransition.fade(withDuration: 1.0))
            } else {
                GameScene.point += 10
                let gameScene = GameScene(fileNamed: "GameScene")
                gameScene?.scaleMode = .aspectFit
                self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: 1.0))
            }
        }
    }
    
    func textAlignment(label: SKLabelNode ,string: String) {
        let font = "\(InteractionToni.fontName)-\(InteractionToni.fontType)"
        let attrString = NSMutableAttributedString(string: string)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let range = NSRange(location: 0, length: string.count)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        attrString.addAttributes([NSAttributedString.Key.foregroundColor : InteractionToni.fontColor, NSAttributedString.Key.font : UIFont(name: font, size: 32.0)!], range: range)
        label.attributedText = attrString
    }
}
