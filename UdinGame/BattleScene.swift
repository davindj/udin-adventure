//
//  BattleScene.swift
//  UdinGame
//
//  Created by Davin Djayadi on 07/04/21.
//

import SpriteKit

struct Dialog {
    // Parent
    var dialog: SKNode
    // Bubble Chat
    var bubbleChat: SKNode
    var labelSpeaker: SKLabelNode
    var labelChat: SKLabelNode
    // Button
    var btnGroup: SKNode
    
    
    
    init(dialog: SKNode){
        self.dialog = dialog
        // Load Bubble Chat
        guard let bubbleChat = dialog.childNode(withName: "bubbleChat") else {
            fatalError("Bubble chat not found!")
        }
        guard let labelSpeaker = bubbleChat.childNode(withName: "labelSpeaker") as? SKLabelNode else {
            fatalError("Label Speaker not found!")
        }
        guard let labelChat = bubbleChat.childNode(withName: "labelChat") as? SKLabelNode else {
            fatalError("Label Chat not found!")
        }
        // Load Button Group
        guard let btnGroup = dialog.childNode(withName: "btnGroup") else {
            fatalError("Button group chat not found!")
        }
        
        // Assign
        self.bubbleChat = bubbleChat
        self.labelSpeaker = labelSpeaker
        self.labelChat = labelChat
        self.btnGroup = btnGroup
        
        // Fade Out
        let action = SKAction.fadeOut(withDuration: 0.00001)
        self.dialog.run(action)
    }
}

class BattleScene: SKScene{
    // CONSTANT
    static let CHAR_DURATION: TimeInterval = 0.15
    
    // Component (Dialog)
    var dialog: Dialog!
    // Frame
    var framePlayerFront = [SKTexture]()
    
    // Variable
    var previousTime: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        // Get Component
        self.camera = childNode(withName: "camera") as? SKCameraNode
        loadDialog()
        // Load Sprite
        loadSprite()
        // Animating
        animateIntroScene{
            self.animateBackground(duration: 1.5)
            self.animateCamera(duration: 1.5)
            self.animateCharacter{
                self.animateUdin(duration: 0.5)
                self.animateDialog()
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = currentTime - previousTime
        previousTime = currentTime
    }
    
    // MARK: Animate Function
    // Animate Label Text
    
    func animateLabel(
        label: SKLabelNode,
        text: String,
        durationPerChar durChar: TimeInterval = CHAR_DURATION,
        durationPerDot durDot: TimeInterval = CHAR_DURATION,
        callBack cb: @escaping (()->Void) = {}
    ){
        // Hapus text Dulu
        label.text = ""
        // SKAction
        var idx = 0
        var closureAnim: (()->Void)!
        closureAnim = {
            if idx >= text.count{
                // Sudah Dianimasikan Semua...
                cb()
            }else{
                // Masih Dalam Iterasi
                let index = text.index(text.startIndex, offsetBy: idx)
                let currentString = String(text[index])
                let action = SKAction.sequence([
                    SKAction.wait(forDuration: currentString == "." ? durDot : durChar),
                    SKAction.run{
                        idx += 1
                        label.text = String(text.prefix(idx))
                    }
                ])
                label.run(action){
                    closureAnim()
                }
            }
        }
        // Panggil Function Recursive
        closureAnim()
    }
    
    
    // Animate Intro Scene
    func animateIntroScene(callBack cb: @escaping (()->Void) = {}){
        // Change Z Index of bgNode
        guard let bgNode = childNode(withName: "bgIntro") as? SKSpriteNode else {return}
        bgNode.zPosition = 0
        // Animate Text
        let introText: String = "Udin..."
        guard let textIntro = childNode(withName: "textIntro") as? SKLabelNode else{return}
        
        self.animateLabel(label: textIntro, text: introText){
            let action = SKAction.wait(forDuration: 1)
            textIntro.run(action){
                textIntro.text = ""
                cb()
            }
        }
    }
    
    // Animate Background Jadi Transparant
    func animateBackground(duration: TimeInterval, callback cb: @escaping (()->Void) = {}){
        guard let bgNode = childNode(withName: "bgIntro") as? SKSpriteNode else {return}
        let action = SKAction.colorize(
            with: UIColor(red: 1, green: 1, blue: 1, alpha: 0),
            colorBlendFactor: 1,
            duration: duration
        )
        bgNode.run(action)
    }
    
    // Animate Zoom Out Camera
    func animateCamera(duration: TimeInterval, callback cb: @escaping (()->Void) = {}){
        let action = SKAction.scale(to: 2, duration: duration)
        self.camera?.run(action)
    }
    
    // Animate Player into Scene
    func animateCharacter(callback cb: @escaping (()->Void) = {}){
        // Get Player Object
        guard let player = childNode(withName: "player") as? SKSpriteNode else {
            fatalError("Player Entity Not Found!")
        }
        
        let actionMove = SKAction.move(to: CGPoint(x: -1200, y: -500), duration: 2)
        let actionAnimating = SKAction.repeatForever(SKAction.animate(with: framePlayerFront, timePerFrame: 0.1))

        player.run(actionAnimating, withKey: "animation")
        player.run(actionMove){
            player.removeAllActions()
            cb()
        }
    }
    
    // Animate Udin into Scene
    func animateUdin(duration: TimeInterval, callback cb: @escaping (()->Void) = {}){
        // Get Udin Object
        guard let udin = childNode(withName: "udin") as? SKSpriteNode else {
            fatalError("Udin Entity Not Found!")
        }
        // Sprite Udin Geser ke Atas
        let action = SKAction.moveTo(y: 90, duration: duration)
        // Call Animation
        udin.run(action)
    }
    
    // Animate Dialog
    func animateDialog(callback cb: @escaping (()->Void) = {}){
        // NOTE: Dialog sudah ada, jadi tidak perlu diLoad
        // yg dianimasikan dialognya muncul
        let action = SKAction.fadeIn(withDuration: 0.3)
        self.dialog.dialog.run(action){
            cb()
        }
    }
    
    // MARK: Load Component / Node
    func loadDialog(){
        // Coba Dapetin Component Dialog beserta child"nya yg perlu
        guard let dialog = childNode(withName: "dialog") else {
            fatalError("Dialog not found!")
        }
        self.dialog = Dialog(dialog: dialog)
    }
    
    // MARK: Load Sprite Function
    // Load Semua Textture dari Semua Sprite
    func loadSprite(){
        framePlayerFront = loadTexture(spriteName: "PlayerSide", textureName: "Side")
    }
    
    // Load Texture dari suatu sprite yg dipakai
    func loadTexture(spriteName name: String, textureName: String) -> [SKTexture] {
        // Create Return Variable
        var listTexture = [SKTexture]()
        // Load From Atlas
        let textureAtlas = SKTextureAtlas(named: name)
        for i in 0..<textureAtlas.textureNames.count{
            let textureCurrent = "\(textureName)\(i)"
            listTexture.append(textureAtlas.textureNamed(textureCurrent))
        }
        // Pengecekan apakah Texturenya ketemu
        if listTexture.isEmpty{
            fatalError("Texture not found! Sprite=\(name), Texture=\(textureName)")
        }
        return listTexture
    }
}
