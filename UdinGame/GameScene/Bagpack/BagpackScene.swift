//
//  BagpackScene.swift
//  UdinGame
//
//  Created by Dimas A. Prabowo on 09/04/21.
//

import SpriteKit

class BagpackScene: SKScene {
    var closeButton: SKNode?
    
    // Item
    var item0: SKSpriteNode?
    var item1: SKSpriteNode?
    var item2: SKSpriteNode?
    var item3: SKSpriteNode?
    var textItem0: SKLabelNode?
    var textItem1: SKLabelNode?
    var textItem2: SKLabelNode?
    var textItem3: SKLabelNode?
    
    static var items = [String]()
    
    // Text properties
    static var fontName = "Verdana"
    static var fontType = "Bold"
    static var fontColor = UIColor.brown
    
    // Sound and Music
    var backgroundMusic: SKAudioNode?
    var closeSound: SKAudioNode?
    var itemSound: SKAudioNode?
    
    override func didMove(to view: SKView) {
        closeButton = childNode(withName: "closeButton")
        
        item0 = childNode(withName: "item0") as? SKSpriteNode
        item1 = childNode(withName: "item1") as? SKSpriteNode
        item2 = childNode(withName: "item2") as? SKSpriteNode
        item3 = childNode(withName: "item3") as? SKSpriteNode
        textItem0 = item0?.childNode(withName: "textItem0") as? SKLabelNode
        textItem1 = item1?.childNode(withName: "textItem1") as? SKLabelNode
        textItem2 = item2?.childNode(withName: "textItem2") as? SKLabelNode
        textItem3 = item3?.childNode(withName: "textItem3") as? SKLabelNode
        
        item0?.isHidden = true
        item1?.isHidden = true
        item2?.isHidden = true
        item3?.isHidden = true
        
        backgroundMusic = childNode(withName: "backgroundMusic") as? SKAudioNode
        closeSound = childNode(withName: "closeSound") as? SKAudioNode
        itemSound = childNode(withName: "itemSound") as? SKAudioNode
        
        print(GameScene.point)
        insertItem()
    }
    
    func insertItem() {
        guard let textItem0 = textItem0 else { return }
        guard let textItem1 = textItem1 else { return }
        guard let textItem2 = textItem2 else { return }
        guard let textItem3 = textItem3 else { return }
        
        // Insert items/clues to bagpack
        for (index, item) in BagpackScene.items.enumerated() {
            switch index {
            case 0:
                let text0: String
                item0?.isHidden = false
                item0?.run(.setTexture(SKTexture(imageNamed: item)))
                (text0, _) = getItemLabelAndScene(item: item)
                textAlignment(string: text0, label: textItem0)
            case 1:
                let text1: String
                item1?.isHidden = false
                item1?.run(.setTexture(SKTexture(imageNamed: item)))
                (text1, _) = getItemLabelAndScene(item: item)
                textAlignment(string: text1, label: textItem1)
            case 2:
                let text2: String
                item2?.isHidden = false
                item2?.run(.setTexture(SKTexture(imageNamed: item)))
                (text2, _) = getItemLabelAndScene(item: item)
                textAlignment(string: text2, label: textItem2)
            case 3:
                let text3: String
                item3?.isHidden = false
                item3?.run(.setTexture(SKTexture(imageNamed: item)))
                (text3, _) = getItemLabelAndScene(item: item)
                textAlignment(string: text3, label: textItem3)
            default:
                print("")
            }
        }
    }
    
    // Based on texture name (Assets)
    func getItemLabelAndScene(item: String) -> (String, String) {
        var itemLabel: String
        var itemScene: String
        
        switch item {
        case "diary":
            itemLabel = "Diari Udin"
            itemScene = "UdinDiaryScene"
        case "insight1":
            itemLabel = "Opini Anton"
            itemScene = "InteractionAnton"
        case "insight3":
            itemLabel = "Opini Yusuf"
            itemScene = "InteractionYusuf"
        case "insight2":
            itemLabel = "Opini Toni"
            itemScene = "InteractionToni"
        default:
            itemLabel = ""
            itemScene = ""
        }
        
        return (itemLabel, itemScene)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            // MARK: Sound and Music
            guard let closeSound = closeSound else { return }
            guard let itemSound = itemSound else { return }
            
            let locationButton = touch.location(in: self)
            let buttonPoint = atPoint(locationButton)
            
            switch buttonPoint.name {
            case "closeButton":
                closeButton!.run(.setTexture(SKTexture(imageNamed: "bagcloseButton2")))
                SettingsMenu.runSound(node: closeSound)
            case "item0":
                SettingsMenu.runSound(node: itemSound)
            case "item1":
                SettingsMenu.runSound(node: itemSound)
            case "item2":
                SettingsMenu.runSound(node: itemSound)
            case "item3":
                SettingsMenu.runSound(node: itemSound)
            default:
                print("")
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            // MARK: Navigation
            // Preview Item
            guard let itemDescription0 = item0?.texture?.description else { return }
            let itemName0 = getTextureName(textureTmp: itemDescription0)
            
            guard let itemDescription1 = item1?.texture?.description else { return }
            let itemName1 = getTextureName(textureTmp: itemDescription1)
            
            guard let itemDescription2 = item2?.texture?.description else { return }
            let itemName2 = getTextureName(textureTmp: itemDescription2)
            
            guard let itemDescription3 = item3?.texture?.description else { return }
            let itemName3 = getTextureName(textureTmp: itemDescription3)
            
            let locationButton = touch.location(in: self)
            let buttonPoint = atPoint(locationButton)
            
            switch buttonPoint.name {
            case "closeButton":
                closeButton!.run(.setTexture(SKTexture(imageNamed: "bagcloseButton")))
                
                // Back to GameScene
                let gameScene = GameScene(fileNamed: "GameScene")
                gameScene?.scaleMode = .aspectFit
                self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: 1.0))
            case "item0":
                let sceneName0: String
                (_, sceneName0) = getItemLabelAndScene(item: itemName0)
                setFromScene(scene: sceneName0)
                
                
                // Review to item0
                let scene0 = SKScene(fileNamed: sceneName0)
                scene0?.scaleMode = .aspectFit
                self.view?.presentScene(scene0!, transition: SKTransition.fade(withDuration: 1.0))
            case "item1":
                let sceneName1: String
                (_, sceneName1) = getItemLabelAndScene(item: itemName1)
                setFromScene(scene: sceneName1)
                
                // Review to item1
                let scene1 = SKScene(fileNamed: sceneName1)
                scene1?.scaleMode = .aspectFit
                self.view?.presentScene(scene1!, transition: SKTransition.fade(withDuration: 1.0))
            case "item2":
                let sceneName2: String
                (_, sceneName2) = getItemLabelAndScene(item: itemName2)
                setFromScene(scene: sceneName2)
                
                // Review to item2
                let scene2 = SKScene(fileNamed: sceneName2)
                scene2?.scaleMode = .aspectFit
                self.view?.presentScene(scene2!, transition: SKTransition.fade(withDuration: 1.0))
            case "item3":
                let sceneName3: String
                (_, sceneName3) = getItemLabelAndScene(item: itemName3)
                setFromScene(scene: sceneName3)
                
                // Review to item3
                let scene3 = SKScene(fileNamed: sceneName3)
                scene3?.scaleMode = .aspectFit
                self.view?.presentScene(scene3!, transition: SKTransition.fade(withDuration: 1.0))
            default:
                print("")
            }
        }
    }
    
    func setFromScene(scene: String) {
        switch scene {
        case "UdinDiaryScene":
            UdinDiaryScene.fromScene = "BagpackScene"
        case "InteractionAnton":
            InteractionAnton.fromScene = "BagpackScene"
        case "InteractionYusuf":
            InteractionYusuf.fromScene = "BagpackScene"
        case "InteractionToni":
            InteractionToni.fromScene = "BagpackScene"
        default:
            print("")
        }
    }
    
    func getTextureName(textureTmp: String) -> String {
        var texture:String = ""
        var startInput = false
        for char in textureTmp {
            if startInput {
                if char != "'" {
                    texture += String(char)
                } else {
                    return texture
                }
            }
            if char == "'" {
                startInput = true
            }
        }
        return texture
    }
    
    func textAlignment(string: String, label: SKLabelNode) {
        let font = "\(BagpackScene.fontName)-\(BagpackScene.fontType)"
        let attrString = NSMutableAttributedString(string: string)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let range = NSRange(location: 0, length: string.count)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        attrString.addAttributes([NSAttributedString.Key.foregroundColor : BagpackScene.fontColor, NSAttributedString.Key.font : UIFont(name: font, size: 32.0)!], range: range)
        label.attributedText = attrString
    }
}
