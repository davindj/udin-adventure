//
//  BattleScene.swift
//  UdinGame
//
//  Created by Davin Djayadi on 07/04/21.
//

import SpriteKit

// MARK: Conversation
struct Conversation{
    var idxMessage: Int // Index Message Saat ini
    var messages: [Message]
    var reward: Int // Reward dari Conversation
    // Computer Property
    var activeMessage: Message?{
        idxMessage >= 0 && !isEndOfConversation ? messages[idxMessage] : nil
    }
    var isEndOfConversation: Bool{
        idxMessage >= messages.count
    }
    
    init(messages: [Message], reward: Int){
        self.idxMessage = -1;
        self.messages = messages
        self.reward = reward
    }
}

// MARK: Message
struct Message {
    var speaker: String
    var content: String
}

// MARK: Dialog
struct Dialog {
    // Parent
    var dialog: SKNode
    // Progress Bar
    var bar: SKSpriteNode
    // Bubble Chat
    var bubbleChat: SKNode
    var labelSpeaker: SKLabelNode
    var labelChat: SKLabelNode
    // Button
    var btnGroup: SKNode
    var btnGroupClue: SKNode
    
    init(dialog: SKNode, clue: [String]){
        self.dialog = dialog
        // Load Progress bar
        guard let progressBar = dialog.childNode(withName: "progressBar") else {
            fatalError("Progress Bar not found!")
        }
        guard let bar = progressBar.childNode(withName: "bar") as? SKSpriteNode else {
            fatalError("Progress Bar's Bar not found!")
        }
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
        // Load Button Group Clue
        guard let btnGroupClue = dialog.childNode(withName: "btnGroupClue") else {
            fatalError("Button group Clue not found!")
        }
        // Assign
        self.bubbleChat = bubbleChat
        self.labelSpeaker = labelSpeaker
        self.labelChat = labelChat
        
        self.btnGroup = btnGroup
        self.btnGroupClue = btnGroupClue
        self.bar = bar
        // Fade Out
        let action = SKAction.fadeOut(withDuration: 0.00001)
        self.dialog.run(action)
        // Samain Posisi btngroupclue dgn btngroup chat
        self.btnGroupClue.position = self.btnGroup.position
        self.btnGroupClue.run(SKAction.fadeOut(withDuration: 0.00001))
        // Assign Text Clue
        for i in 1...4{
            guard let btnClue = self.btnGroupClue.childNode(withName: "btnClue\(i)") as? SKSpriteNode else {
                fatalError("Button Clue \(i) not found!")
            }
            guard let label = btnClue.childNode(withName: "innerText") as? SKLabelNode else {
                fatalError("InnerText Button Clue \(i) not found!")
            }
            let clueNotEmpty = clue[i-1] != ""
            label.text = clueNotEmpty ? clue[i-1] : "-"
        }
    }
    
    // Function
    func toggleVisible(isChatVisible chat: Bool, isClueVisible clue: Bool){
        let actionFadeIn = SKAction.fadeIn(withDuration: 0.5)
        let actionFadeOut = SKAction.fadeOut(withDuration: 0.5)
        self.btnGroup.run(chat ? actionFadeIn : actionFadeOut)
        self.btnGroupClue.run(clue ? actionFadeIn : actionFadeOut)
    }
    func updateProgressBar(value: Int){
        var progress = value
        if progress > 40{
            progress = 40
        }else if progress < 0{
            progress = 0
        }
        progress = 950 * progress / 40
        let action = SKAction.resize(toWidth: CGFloat(progress), duration: 0.5)
        self.bar.run(action)
    }
    func disableComponent(
        isConfrontActive confront: Bool,
        isListenActive listen: Bool,
        isClue1Active clue1: Bool,
        isClue2Active clue2: Bool,
        isClue3Active clue3: Bool,
        isClue4Active clue4: Bool
    ){
        toggleDisableChild(parentNode: btnGroup, childName: "btnConfront", isDisable: !confront)
        toggleDisableChild(parentNode: btnGroup, childName: "btnListen", isDisable: !listen)
        toggleDisableChild(parentNode: btnGroupClue, childName: "btnClue1", isDisable: !clue1)
        toggleDisableChild(parentNode: btnGroupClue, childName: "btnClue2", isDisable: !clue2)
        toggleDisableChild(parentNode: btnGroupClue, childName: "btnClue3", isDisable: !clue3)
        toggleDisableChild(parentNode: btnGroupClue, childName: "btnClue4", isDisable: !clue4)
        // Disable Button Ask about
        let isBtnAskAboutEnable = clue1 || clue2 || clue3 || clue4
        if !isBtnAskAboutEnable{
            toggleDisableChild(parentNode: btnGroup, childName: "btnAskAbout", isDisable: true)
        }
    }
    func toggleDisableChild(parentNode parent: SKNode, childName name: String, isDisable: Bool){
        guard let btn = parent.childNode(withName: name) as? SKSpriteNode else{
            fatalError("\(name) not found")
        }
        if isDisable{
            btn.run(.setTexture(SKTexture(imageNamed: "button2")))
            btn.run(.fadeAlpha(to: BattleScene.DISABLE_ALPHA, duration: 0.001))
            print("Asset berubah!")
        }
    }
}

// MARK: Main Class
class BattleScene: SKScene{
    // CONSTANT
    static let CHAR_DURATION: TimeInterval = 0.15
    static let DISABLE_ALPHA: CGFloat = 0.5
    
    // Idx Conversation
    var idxConfront: Int = 0
    var idxListen: Int = 0
    var isDoneConfront: Bool = false
    var isDoneListen: Bool = false
    
    // Trust Point
    var trustPoint: Int = 0{
        didSet{
            self.dialog.updateProgressBar(value: trustPoint)
        }
    }
    // Component (Dialog)
    var dialog: Dialog!
    
    // Frame
    var framePlayerFront = [SKTexture]()
    
    // Clue yang dimiliki oleh player
    var list_clue = [String]()
    var done_clue = [false, false, false, false]
    
    // Conversation
    var activeConversation: Conversation? = nil
    // PLayer Action berguna untuk menyimpan action yg mau dilakukan oleh player
    // -1 -> Tidak ada action
    //  0 -> Confront Udin
    //  1 -> Listen to Udin
    //  2 -> Ask Clue
    var playerIncomingAction: Int = -1
    // Menyimpan Action Yang hendak dilakukan
    var isChatAnimating: Bool = false // apakah masih animasi chat
    
    // MARK: Constructor
    override func didMove(to view: SKView) {
        // Load Clue
        loadClue()
        // Get Component
        self.camera = childNode(withName: "camera") as? SKCameraNode
        loadDialog()
        // Load Sprite
        loadSprite()
        // Animating
        self.trustPoint = 0
        self.animateIntroScene{
            self.animateBackground(duration: 1.5)
            self.animateCamera(duration: 1.5)
            self.animateCharacter{
                self.animateUdin(duration: 0.5)
                self.animateDialog{
                    self.trustPoint = 20
                }
            }
        }
        // Toggle Disable Enable Component, siapa tau ada clue yg tidak ditemukan
        self.toggleDisableEnable()
    }
    
    func loadClue(){
        // Load Clue nya pake Static Bagpack
        list_clue = ["", "", "", ""]
        // List All Posssible Clue
        // 1 diary
        // 2 insight1
        // 3 insight2
        // 4 insight3
        let available_clue = ["diary", "insight1", "insight2", "insight3"]
        let preview_clue = ["Diary","Anton","Yusuf","Toni"]
        // Iterate setiap clue yg ditemukan kedalam list_clue
        for i in 0...3{
            let currentClue = available_clue[i]
            if BagpackScene.items.contains(currentClue) || true{
                list_clue[i] = preview_clue[i]
            }else{ // Clue jadi tidak bisa diakses
                done_clue[i] = true
            }
        }
    }
    
    // MARK: Get Conversion Function
    func getConfrontConversation() -> Conversation{
        return [
            Conversation(messages: [ // Confront 1
                Message(speaker: "Player", content: "Udin jangan galau"),
                Message(speaker: "Udin", content: "jangan ganggu aku"),
                Message(speaker: "Udin", content: "Aku lagi ingin sendirian")
            ], reward: -10),
            Conversation(messages: [ // Confront 2
                Message(speaker: "Player", content: "Udin kamu jangan sombong ya"),
                Message(speaker: "Udin", content: "Jangan ganggu aku")
            ], reward: -10),
            Conversation(messages: [ // Confront 3
                Message(speaker: "Player", content: "Udin jelek, Udin jelek"),
                Message(speaker: "Udin", content: "....."),
                Message(speaker: "Udin", content: "*sob*")
            ], reward: -15)
        ][idxConfront]
    }
    func getListenConversation() -> Conversation{
        return [
            Conversation(messages: [ // Listen 1
                Message(speaker: "Player", content: "..."),
                Message(speaker: "Udin", content: "kamu tau ga? aku itu pendiam"),
                Message(speaker: "Udin", content: "gada yg bisa ngertiin aku..."),
                Message(speaker: "Udin", content: "Akhirnya aku menyendiri...")
            ], reward: 5),
            Conversation(messages: [ // Listen 2
                Message(speaker: "Player", content: "..."),
                Message(speaker: "Udin", content: "terkadang orang mendengarku untuk memakiku"),
                Message(speaker: "Udin", content: "maka dari itu aku menjauh dari orang")
            ], reward: 5),
            Conversation(messages: [ // Listen 3
                Message(speaker: "Player", content: "..."),
                Message(speaker: "Udin", content: "kenapa kamu ngetliat aku?"),
                Message(speaker: "Udin", content: "kamu mau maki aku?")
            ], reward: -10)
        ][idxListen]
    }
    
    // MARK: Action
    // Menjalakan action sesuai pada player incoming action
    func doAction(){
        if playerIncomingAction == -1 || activeConversation != nil{
            return
        }// Run Action
        let playerAction = playerIncomingAction
        // Reset Incoming Action
        playerIncomingAction = -1
        // Assign Konten Chat
        let conversation = [
            getConfrontConversation(), // Confront
            getListenConversation(), // Listen
            Conversation(messages: [ // Clue 1 (Diary)
                Message(speaker: "Player", content: "Udin aku mau tanya..."),
                Message(speaker: "Player", content: "Maaf sebelumnya aku ga singaja baca Diary kamu"),
                Message(speaker: "Udin", content: "......"),
                Message(speaker: "Player", content: "Udin bagaimana kabarmu?"),
                Message(speaker: "Player", content: "Bukan berarti kamu menyusahkan orang tua kamu"),
                Message(speaker: "Player", content: "Orang tua kamu bekerja keras, karena sayang sama kamu"),
                Message(speaker: "Player", content: "Tinggal kita sebagai anak harus membalasnya"),
                Message(speaker: "Player", content: "Untuk membalasnya bisa dibalas dengan hal-hal kecil"),
                Message(speaker: "Player", content: "Seperti senyuman manis yang kamu berikan ke mereka"),
                Message(speaker: "Player", content: "Jangan berpikiran seperti itu ya din..."),
                Message(speaker: "Player", content: "Orang-orang disekitarmu akan sedih jika kamu tidak ada"),
                Message(speaker: "Player", content: "Termasuk orang tua-mu..."),
                Message(speaker: "Udin", content: "Terima kasih ya masukannya..."),
                Message(speaker: "Udin", content: "Ternyata kamu tidak seperti anak-anak lainnya..."),
                Message(speaker: "Udin", content: "Yang menggunakan Diaryku sebagai bahan tertawa mereka"),
                Message(speaker: "Player", content: "Jangan khawatir din, aku selalu ada untukmur"),
                Message(speaker: "Player", content: "Udin tetap semangat ya")
            ], reward: 10),
            Conversation(messages: [ // Clue 2 (Anton)
                Message(speaker: "Player", content: "Udin apa kamu sering diganggu sama teman-teman?"),
                Message(speaker: "Udin", content: "aku ga mau bicarain tentang itu..."),
                Message(speaker: "Player", content: "Tidak apa-apa Udin, santai aja.."),
                Message(speaker: "Player", content: "Kita semua pasti ada yang ganggu kita"),
                Message(speaker: "Player", content: "Orang-orang seperti itu kita abaikan saja"),
                Message(speaker: "Player", content: "Tidak perlu dimasukan hati :)"),
                Message(speaker: "Player", content: "Tapi jangan khawatir, bila ada yang ganggu kamu..."),
                Message(speaker: "Player", content: "Aku siap kok bantu kamu")
            ], reward: 10),
            Conversation(messages: [ // Clue 3 (Yusuf)
                Message(speaker: "Player", content: "Udin aku mau tanya sesuatu..."),
                Message(speaker: "Player", content: "Aku dengar dulu kamu selalu dijemput ibumu ya?"),
                Message(speaker: "Player", content: "Kenapa kok kamu sekarang pulang sendiri?"),
                Message(speaker: "Udin", content: "Oh.... Tentang itu..."),
                Message(speaker: "Udin", content: "Pada waktu dulu, ibuku belum mejadi wanita karir"),
                Message(speaker: "Udin", content: "Semenjak ada ayahku kena tipu"),
                Message(speaker: "Udin", content: "Ibuku terpaksa bekerja..."),
                Message(speaker: "Udin", content: "dan akhirnya aku mulai pulang sekolah sendiri...")
            ], reward: 10),
            Conversation(messages: [ // Clue 4 (Toni)
                Message(speaker: "Player",  content: "Udin ayo main basket dengan anak-anak lainnya"),
                Message(speaker: "Udin", content: "Kamu aja deh, aku lagi tidak selera"),
                Message(speaker: "Player",  content: "Kalau gitu ayo kapan-kapan kita main bareng"),
                Message(speaker: "Player",  content: "Terserah mau main apapun"),
                Message(speaker: "Player",  content: "Karena refreshing itu cukup penting Din"),
                Message(speaker: "Player",  content: "Dan sebagai teman sebangkumu..."),
                Message(speaker: "Player",  content: "Aku mau kenal lebih dekat dengan kamu"),
                Message(speaker: "Udin",  content: "Oh... hmm.. Terima kasih atas perhatiannya")
            ], reward: 10),
            Conversation(messages: [ // Clue X
                Message(speaker: "Player", content: "Emmmmm"),
                Message(speaker: "Udin", content: ".... ???")
            ], reward: -10),
        ][playerAction];
        activeConversation = conversation;
        print("Start Conversation: \(playerAction)")
        // Update idx
        if playerAction == 0{
            idxConfront += 1
            if idxConfront >= 3 {
                idxConfront = 2
                isDoneConfront = true
            }
        }else if playerAction == 1{
            idxListen += 1
            if idxListen >= 3 {
                idxListen = 2
                isDoneListen = true
            }
        }else{
            done_clue[playerAction - 2] = true
        }
        // Hide Button Group / Button Group CLue
        dialog.toggleVisible(isChatVisible: false, isClueVisible: false)
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
            let message = activeConversation!.activeMessage!
            dialog.labelChat.text = message.content
        }else{ // Jika tidak lagi dianimasikan
            // Increment IDX Chat
            activeConversation?.idxMessage += 1
            // Check Apakah sudah akhir dari Chat atau blm
            if activeConversation!.isEndOfConversation{
                endOfConversation()
            }else{// masih blm akhir dari chat
                let message = activeConversation!.activeMessage!
                // Update Speaker
                dialog.labelSpeaker.text = message.speaker
                // Animate Chat
                animateLabel(label: dialog.labelChat, text: message.content, durationPerChar: 0.025)
            }
        }
    }
    // Action yg dijalankan ketika speak sudah sampai terakhir
    func endOfConversation(){
        // UnHide Button Group
        dialog.toggleVisible(isChatVisible: true, isClueVisible: false)
        // Extend Bubblechat
        let action = SKAction.resize(toHeight: (108) * 2, duration: 0.25)
        dialog.bubbleChat.run(action)
        // Tambahi Point Trust
        trustPoint += activeConversation!.reward
        print("Point: \(trustPoint)")
        // Reset Player Action
        activeConversation = nil
        // Block action
        toggleDisableEnable()
        // Check Score
        let isWinning = trustPoint >= 40
        let isLosing = trustPoint <= 0
        // Jika menang atau kalah maka pindah halaman
        if isWinning || isLosing{
            RedemptionScene.isHappyEnding = isWinning
            let gameScene: SKScene = RedemptionScene(fileNamed: "RedemptionScene")!;
            gameScene.scaleMode = .aspectFill
            self.view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: 1.0))
        }
    }
    
    func toggleDisableEnable(){
        dialog.disableComponent(
            isConfrontActive: !isDoneConfront,
            isListenActive: !isDoneListen,
            isClue1Active: !done_clue[0],
            isClue2Active: !done_clue[1],
            isClue3Active: !done_clue[2],
            isClue4Active: !done_clue[3]
        )
    }
    
    // MARK: Event Handler
    func checkButtonAvailability(button: SKNode) -> Bool{
        guard let btn = button as? SKSpriteNode else{
            return false
        }
        return btn.alpha != BattleScene.DISABLE_ALPHA
    }
    
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
            let list_btn_clue = ["btnClue1", "btnClue2", "btnClue3", "btnClue4"]
            let name = node.name ?? ""
            switch name{
            case _ where list_btn.contains(name): // Button Action
                // Check Button Condition
                let isAvailable = checkButtonAvailability(button: node)
                if isAvailable{
                    node.run(.setTexture(SKTexture(imageNamed: "button2")))
                    isValid = tempIdxAction == -1 // Valid jika tidak action sm sekali
                    tempIdxAction = list_btn.firstIndex(of: name)!
                }
            case _ where list_btn_clue.contains(name):
                let isAvailable = checkButtonAvailability(button: node)
                if isAvailable{
                    node.run(.setTexture(SKTexture(imageNamed: "button2")))
                    isValid = tempIdxAction == -1 // Valid jika tidak action sm sekali
                    tempIdxAction = list_btn_clue.firstIndex(of: name)! + 2 // ditambah 2 jk clue
                }
            case "bubbleChat" where activeConversation != nil: // Bubble Chat yg ditekan
                speak()
            default:
                print("[Touch Begin] Do Nothing...")
            }
        }
        // Check Valid Button ditkean
        if isValid && activeConversation == nil{ // Jika Valid dan blm ada action
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
            let list_btn_clue = ["btnClue1", "btnClue2", "btnClue3", "btnClue4"]
            let name = button.name ?? ""
            switch name{
            case _ where list_btn.contains(name):
                button.run(.setTexture(SKTexture(imageNamed: "button1")))
                let idx = list_btn.firstIndex(of: name)!
                // Check Apakah Index yg dipilih sama dengan Incoming Action
                if playerIncomingAction == idx{
                    if name == "btnAskAbout"{ // Tampilkan semua Clue
                        playerIncomingAction = -1
                        dialog.toggleVisible(isChatVisible: false, isClueVisible: true)
                    }else{
                        doAction()
                    }
                }
            case _ where list_btn_clue.contains(name):
                button.run(.setTexture(SKTexture(imageNamed: "button1")))
                let idx = list_btn_clue.firstIndex(of: name)! + 2 // ditambah 2 jk clue
                if playerIncomingAction == idx{ // Cluenya dijalankan
                    let clue = list_clue[idx-2]
                    if clue == ""{ // JIka Clue tidak ditemukan
                        playerIncomingAction = 6 // set Clue X
                    }
                    doAction()
                }
            default:
                print("[Touch Ended] Do Nothing...")
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
        isUsingAttributeText isAtext: Bool = false,
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
                        let text = String(text.prefix(idx))
                        if isAtext{
                            self.textAlignment(string: text, label: label, color: .black)
                        }else{
                            label.text = text
                        }
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
        bgNode.zPosition = 5
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
        bgNode.run(action){
            bgNode.zPosition = -10000
        }
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
        self.dialog = Dialog(dialog: dialog, clue: list_clue)
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
    
    // MARK: Helper Function
    func textAlignment(string: String, label: SKLabelNode, size: CGFloat = 32.0, color: UIColor = .white) {
        let font = "\(GameScene.fontName)-\(GameScene.fontType)"
        let attrString = NSMutableAttributedString(string: string)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let range = NSRange(location: 0, length: string.count)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        attrString.addAttributes([NSAttributedString.Key.foregroundColor : color, NSAttributedString.Key.font : UIFont(name: font, size: size)!], range: range)
        label.attributedText = attrString
    }
    
    // Done
    // Button Confront & Listen ubah jadi disable dn transparan
    // Disable clue yang blm ditemukan
    // Align Text label
    // load clue
    // redir ke endingscene
    // insight button
    // Ending Scene and Redir to Credit
    // Credit Scene
    // insight conversation
    
    // OTW
    // audio (itch.io)
    // bad clue
}
