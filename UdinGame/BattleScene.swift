//
//  BattleScene.swift
//  UdinGame
//
//  Created by Davin Djayadi on 07/04/21.
//

import SpriteKit

struct Message {
    var speaker: String
    var content: String
}

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
    
    // Action
    var playerAction: Int = -1
    // PLayer Action berguna untuk menyimpan action yg mau dilakukan oleh player
    // -1 -> Tidak ada action
    //  0 -> Confront Udin
    //  1 -> Listen to Udin
    //  2 -> Ask Clue
    var playerIncomingAction: Int = -1
    // Menyimpan Action Yang hendak dilakukan
    var idxChat: Int = -1 // Idx Chat Saat ini
    var chat: [Message] = [] // Chat saat ini
    var isChatAnimating: Bool = false // apakah masih animasi chat
    
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
    
    // MARK: Action
    // Menjalakan action sesuai pada player incoming action
    func doAction(){
        if playerIncomingAction == -1 || playerAction != -1{
            return
        }// Run Action
        playerAction = playerIncomingAction
        // Reset Incoming Action
        playerIncomingAction = -1
        // Reset Idx Cjat
        idxChat = -1
        // Assign Konten Chat
        chat = [[ // Confront
            Message(speaker: "Player", content: "Udin jangan galau"),
            Message(speaker: "Udin", content: "Udah jangan ganggu aku"),
            Message(speaker: "Udin", content: "Aku aja ga kenal kamu siapa"),
        ],[ // Listen
            Message(speaker: "Player", content: "..."),
            Message(speaker: "Udin", content: "kamu tau nda aku itu pendiam"),
            Message(speaker: "Udin", content: "gada yg bisa ngertiin aku\nAkhirnya aku menyendiri")
        ],[ // Ask About
            Message(speaker: "Player", content: "Udin aku mau tanya..."),
            Message(speaker: "Udin", content: "Jangan tanya-tanya"),
        ]][playerAction];
        // Hide Button Group
        dialog.btnGroup.run(.fadeOut(withDuration: 0.5))
        // Extend Bubblechat
        let action = SKAction.resize(toHeight: (180) * 2, duration: 0.5)
        dialog.bubbleChat.run(action)
        // Mulai Conversation
        speak()
    }
    // Untuk Berbicara dan mengubah
    func speak(){
        if isChatAnimating{ // Jika Masih Animasikan chat maka langsung diskip aja
            self.isChatAnimating = false
            let message = chat[idxChat]
            dialog.labelChat.text = message.content
        }else{ // Jika tidak lagi dianimasikan
            // Increment IDX Chat
            idxChat += 1
            // Check Apakah sudah akhir dari Chat atau blm
            if idxChat >= chat.count{
                endOfConversation()
            }else{// masih blm akhir dari chat
                let message = chat[idxChat]
                // Update Speaker
                dialog.labelSpeaker.text = message.speaker
                // Animate Chat
                animateLabel(label: dialog.labelChat, text: message.content, durationPerChar: 0.025)
            }
        }
    }
    // Action yg dijalankan ketika speak sudah sampai terakhir
    func endOfConversation(){
        // Hide Button Group
        dialog.btnGroup.run(.fadeIn(withDuration: 0.5))
        // Extend Bubblechat
        let action = SKAction.resize(toHeight: (108) * 2, duration: 0.25)
        dialog.bubbleChat.run(action)
        // Reset Player Action
        playerAction = -1
    }
    
    // MARK: Event Handler
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Untuk check apakah button yg ditekan benar
        var isValid = false;
        var tempIdxAction = -1;
        
        for touch in touches{
            let locationButton = touch.location(in: self)
            var node = atPoint(locationButton)
            
            // Check Bubble Chat
            // Check Button / BubbleChat
            
            // Jika dirinya Label node maka...
            if let label = node as? SKLabelNode{
                if label.name == "innerText"{
                    // Jika Inner Text maka merupakan label button
                    node = node.parent!
                }else if ["labelChat","labelSpeaker"].contains(label.name){
                    // Jika Label Chat / Label speaker jdi Bubble Chat
                    node = node.parent!
                }
            }
            let list_btn = ["btnConfront", "btnListen", "btnAskAbout"]
            let name = node.name ?? ""
            switch name{
            case _ where list_btn.contains(name): // Button Action
                node.run(.setTexture(SKTexture(imageNamed: "button2")))
                isValid = tempIdxAction == -1 // Valid jika tidak action sm sekali
                tempIdxAction = list_btn.firstIndex(of: name)!
            case "bubbleChat" where playerAction != -1: // Bubble Chat yg ditekan
                speak()
            default:
                print("Do Nothing...")
            }
        }
        // Check Valid Button ditkean
        if isValid && playerAction == -1{ // Jika Valid dan blm ada action
            playerIncomingAction = tempIdxAction
            print("Touch Action: \(playerIncomingAction)")
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let locationButton = touch.location(in: self)
            var button = atPoint(locationButton)
            
            // Check Button
            if let label = button as? SKLabelNode{
                button = label.parent ?? self
            }
            let list_btn = ["btnConfront", "btnListen", "btnAskAbout"]
            let name = button.name ?? ""
            switch name{
            case _ where list_btn.contains(name):
                button.run(.setTexture(SKTexture(imageNamed: "button1")))
                let idx = list_btn.firstIndex(of: name)!
                // Check Apakah Index yg dipilih sama dengan Incoming Action
                if playerIncomingAction == idx{
                    doAction()
                }
            default:
                print("Do Nothing...")
            }
        }
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
        // Mulai Animasi Chat
        self.isChatAnimating = true
        // Hapus text Dulu
        label.text = ""
        // SKAction
        var idx = 0
        var closureAnim: (()->Void)!
        closureAnim = {
            if idx >= text.count || !self.isChatAnimating{
                // Sudah Dianimasikan Semua...
                self.isChatAnimating = false
                cb()
            }else{
                // Masih Dalam Iterasi
                let index = text.index(text.startIndex, offsetBy: idx)
                let currentString = String(text[index])
                let action = SKAction.sequence([
                    SKAction.wait(forDuration: currentString == "." ? durDot : durChar),
                    SKAction.run{
                        if !self.isChatAnimating{return}
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
