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
    
    var textYusuf0 = ""
    var textYusuf1 = ""
    var textYusuf2 = ""
    
    var textPlayer0 = ""
    var textPlayer1 = ""
    
    var touchCount = 0
    
    static var fromScene = ""
    
    // Text properties
    static var fontName = "Verdana"
    static var fontType = "Bold"
    static var fontColor = UIColor.brown
    
    // Sound and Music
    var backgroundMusic: SKAudioNode?
    var playerChatSound: SKAudioNode?
    var yusufChatSound: SKAudioNode?
    var closeSound: SKAudioNode?
    
    override func didMove(to view: SKView) {
        playerBubble = childNode(withName: "playerBubble")
        yusufBubble = childNode(withName: "yusufBubble")
        
        playerChat = playerBubble?.childNode(withName: "playerChat") as? SKLabelNode
        yusufChat = yusufBubble?.childNode(withName: "yusufChat") as? SKLabelNode
        
        backgroundMusic = childNode(withName: "backgroundMusic") as? SKAudioNode
        playerChatSound = childNode(withName: "playerChatSound") as? SKAudioNode
        yusufChatSound = childNode(withName: "yusufChatSound") as? SKAudioNode
        closeSound = childNode(withName: "closeSound") as? SKAudioNode
        
        GameScene.hasYusufInsight = true
        
        playerBubble?.isHidden = true
        yusufBubble?.isHidden = true
        
        if InteractionYusuf.fromScene != "BagpackScene" {
            BagpackScene.items.append("insight3")
        }
        
        setText()
    }
    
    func setText() {
        textYusuf0 = "Kamu tahu tidak dulu Udin \nanaknya ceria dan asik sekali. \nTidak seperti sekarang, penyendiri"
        textPlayer0 = "Oh ya? Kenapa dia berubah?"
        textYusuf1 = "Kurang tahu sih, tapi akhir-akhir ini \ndia sering kali datang dan \npulang dari sekolah sendiri juga"
        textPlayer1 = "Emangnya dia biasanya \nbersama orang tuanya ya?"
        textYusuf2 = "Iya, biasanya Ibunya siap menjemputnya \nbahkan sebelum bel berbunyi \nibunya sudah berada di gerbang sekolah"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let playerChatSound = playerChatSound else { return }
        guard let yusufChatSound = yusufChatSound else { return }
        guard let closeSound = closeSound else { return }
        
        guard let playerChat = playerChat else { return }
        guard let yusufChat = yusufChat else { return }
        touchCount += 1
        
        // MARK: Event Yusuf Insight
        switch touchCount{
        case 1:
            yusufBubble?.isHidden = false
            textAlignment(label: yusufChat, string: textYusuf0)
            SettingsMenu.runSound(node: yusufChatSound)
        case 2:
            yusufBubble?.isHidden = true
            playerBubble?.isHidden = false
            textAlignment(label: playerChat, string: textPlayer0)
            SettingsMenu.runSound(node: playerChatSound)
        case 3:
            playerBubble?.isHidden = true
            yusufBubble?.isHidden = false
            textAlignment(label: yusufChat, string: textYusuf1)
            SettingsMenu.runSound(node: yusufChatSound)
        case 4:
            yusufBubble?.isHidden = true
            playerBubble?.isHidden = false
            textAlignment(label: playerChat, string: textPlayer1)
            SettingsMenu.runSound(node: playerChatSound)
        case 5:
            playerBubble?.isHidden = true
            yusufBubble?.isHidden = false
            textAlignment(label: yusufChat, string: textYusuf2)
            SettingsMenu.runSound(node: yusufChatSound)
        case 6:
            SettingsMenu.runSound(node: closeSound)
            
            if InteractionYusuf.fromScene == "BagpackScene" {
                let bagpackScene = SKScene(fileNamed: "BagpackScene")
                bagpackScene?.scaleMode = .aspectFill
                self.view?.presentScene(bagpackScene!, transition: SKTransition.fade(withDuration: 1.0))
            } else {
                GameScene.point += 10
                let gameScene = SKScene(fileNamed: "GameScene")
                gameScene?.scaleMode = .aspectFill
                self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: 1.0))
            }
        default:
            textAlignment(label: yusufChat, string: textYusuf1)
        }
    }
    
    func textAlignment(label: SKLabelNode ,string: String) {
        let font = "\(InteractionYusuf.fontName)-\(InteractionYusuf.fontType)"
        let attrString = NSMutableAttributedString(string: string)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let range = NSRange(location: 0, length: string.count)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        attrString.addAttributes([NSAttributedString.Key.foregroundColor : InteractionYusuf.fontColor, NSAttributedString.Key.font : UIFont(name: font, size: 23.0)!], range: range)
        label.attributedText = attrString
    }
}
