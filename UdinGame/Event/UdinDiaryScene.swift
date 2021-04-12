//
//  UdinDiaryScene.swift
//  UdinGame
//
//  Created by Dimas A. Prabowo on 10/04/21.
//

import SpriteKit

class UdinDiaryScene: SKScene {
    var closeButton: SKNode?
    
    var textLeft: SKLabelNode?
    var textRight: SKLabelNode?
    
    static var fromScene = ""
    
    // Sound and Music
    var backgroundMusic: SKAudioNode?
    var closeSound: SKAudioNode?
    
    // Text properties
    static var fontName = "Verdana"
    static var fontType = "Bold"
    static var fontColor = UIColor.black
    
    override func didMove(to view: SKView) {
        closeButton = childNode(withName: "closeButton")
        textLeft = childNode(withName: "textLeft") as? SKLabelNode
        textRight = childNode(withName: "textRight") as? SKLabelNode
        backgroundMusic = childNode(withName: "backgroundMusic") as? SKAudioNode
        closeSound = childNode(withName: "closeSound") as? SKAudioNode
        
        if UdinDiaryScene.fromScene != "BagpackScene" {
            BagpackScene.items.append("diary")
        }
        
        GameScene.hasDiaryUdin = true
        setText()
    }
    
    func setText() {
        guard let textLeftLabel = textLeft else { return }
        guard let textRightLabel = textRight else { return }
        let textLeft = "Lorem ipsum dolor sit amet, consectetur \nadipiscing elit, sed do eiusmod tempor \nincididunt ut labore et dolore magna aliqua. \nUt enim ad minim veniam, \nquis nostrud exercitation ullamco \nlaboris nisi ut \naliquip ex ea commodo consequat. \nDuis aute irure dolor in \nreprehenderit in voluptate \nvelit esse cillum dolore eu \nfugiat nulla \npariatur. Excepteur sint occaecat \ncupidatat non proident, \nsunt in culpa qui \nofficia deserunt mollit \nanim id est laborum."
        let textRight = "Lorem ipsum dolor sit amet, consectetur \nadipiscing elit, sed do eiusmod tempor \nincididunt ut labore et dolore magna aliqua. \nUt enim ad minim veniam, \nquis nostrud exercitation ullamco \nlaboris nisi ut \naliquip ex ea commodo consequat. \nDuis aute irure dolor in \nreprehenderit in voluptate \nvelit esse cillum dolore eu \nfugiat nulla \npariatur. Excepteur sint occaecat \ncupidatat non proident, \nsunt in culpa qui \nofficia deserunt mollit \nanim id est laborum."
        
        textAlignment(label: textLeftLabel, string: textLeft)
        textAlignment(label: textRightLabel, string: textRight)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            guard let closeSound = closeSound else { return }
            
            let touchButton = touch.location(in: self)
            let buttonPoint = atPoint(touchButton)
            
            if buttonPoint.name == "closeButton" {
                closeButton?.run(.setTexture(SKTexture(imageNamed: "closeButton2")))
                SettingsMenu.runSound(node: closeSound)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchButton = touch.location(in: self)
            let buttonPoint = atPoint(touchButton)
            
            if buttonPoint.name == "closeButton" {
                closeButton?.run(.setTexture(SKTexture(imageNamed: "closeButton")))
                
                if UdinDiaryScene.fromScene == "BagpackScene" {
                    let bagpackScene = SKScene(fileNamed: "BagpackScene")
                    bagpackScene?.scaleMode = .aspectFill
                    self.view?.presentScene(bagpackScene!, transition: SKTransition.fade(withDuration: 1.0))
                } else {
                    GameScene.point += 10
                    let scene = SKScene(fileNamed: "GameScene")
                    scene?.scaleMode = .aspectFill
                    self.view?.presentScene(scene!, transition: SKTransition.fade(withDuration: 1.0))
                }
            }
        }
    }
    
    func textAlignment(label: SKLabelNode ,string: String) {
        let font = "\(UdinDiaryScene.fontName)-\(UdinDiaryScene.fontType)"
        let attrString = NSMutableAttributedString(string: string)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let range = NSRange(location: 0, length: string.count)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        attrString.addAttributes([NSAttributedString.Key.foregroundColor : UdinDiaryScene.fontColor, NSAttributedString.Key.font : UIFont(name: font, size: 23.0)!], range: range)
        label.attributedText = attrString
    }
}
