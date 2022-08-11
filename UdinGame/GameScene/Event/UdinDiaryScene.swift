//
//  UdinDiaryScene.swift
//  UdinGame
//
//  Created by Dimas A. Prabowo on 10/04/21.
//

import SpriteKit

class UdinDiaryScene: SKScene {
    var closeButton: SKNode?
    
    var textLeft0: SKLabelNode?
    var textLeft1: SKLabelNode?
    var textLeft2: SKLabelNode?
    var textRight0: SKLabelNode?
    var textRight1: SKLabelNode?
    var textRight2: SKLabelNode?
    
    static var fromScene: String = "" // scene from?
    
    static var touchCount: Int = 0 // touch counter
    
    // Sound and Music
    var backgroundMusic: SKAudioNode?
    var closeSound: SKAudioNode?
    
    // Text properties
    static var fontName = "Verdana"
    static var fontType = "Bold"
    static var fontColor = UIColor.brown
    
    // Text
    var leftText0: String = ""
    var leftText1: String = ""
    var leftText2: String = ""
    var rightText0: String = ""
    var rightText1: String = ""
    var rightText2: String = ""
    
    var isChatAnimating: Bool = false // apakah masih animasi chat
    static let CHAR_DURATION : TimeInterval = 0.01
    
    override func didMove(to view: SKView) {
        textLeft0 = childNode(withName: "textLeft0") as? SKLabelNode
        textLeft1 = childNode(withName: "textLeft1") as? SKLabelNode
        textLeft2 = childNode(withName: "textLeft2") as? SKLabelNode
        textRight0 = childNode(withName: "textRight0") as? SKLabelNode
        textRight1 = childNode(withName: "textRight1") as? SKLabelNode
        textRight2 = childNode(withName: "textRight2") as? SKLabelNode
        
        closeButton = childNode(withName: "closeButton")
        backgroundMusic = childNode(withName: "backgroundMusic") as? SKAudioNode
        closeSound = childNode(withName: "closeSound") as? SKAudioNode
        
        if UdinDiaryScene.fromScene != "BagpackScene" {
            BagpackScene.items.append("diary")
        }
        
        GameScene.hasDiaryUdin = true
        setText()
    }
    
    func setText() {
        guard let textLeftLabel0 = textLeft0 else { return }
        
        leftText0 = "11/2/20 Enaknya si Anton \nmendapatkan sepatu baru dari \norang tuanya. Brand N*ke \njuga, mahal sekali pasti."
        leftText1 = "11/2/20 Durhaka sekali sih, \norang tuaku sudah susah malah \npingin yang mahal-mahal"
        leftText2 = "15/2/20 Hari ini diajak main \nsama anak-anak kelas, buat \napa sih? membuang tenaga saja"
        rightText0 = "17/2/20 Mungkin kalau aku \nsudah kerja, aku dapat membantu \norang tuaku dan bahkan membeli \nsepatuku sendiri"
        rightText1 = "21/2/20 Duh diajak main lagi, \napa mereka tidak tahu aku \ntidak mempunyai sepatu olahraga? \nSepatu sudah tembelan lem, kalau\n dibuat main pasti rusak. Mereka \njuga mana mungkin mengerti. \nKalau pingin tinggal minta."
        rightText2 = "25/2/20 Kalau aku tidak ada, \nmungkin papa dan mama tidak \nakan bekerja sampai malam lagi"
        
        animateLabel(label: textLeftLabel0, text: leftText0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let textLeftLabel1 = textLeft1 else { return }
        guard let textLeftLabel2 = textLeft2 else { return }
        guard let textRightLabel0 = textRight0 else { return }
        guard let textRightLabel1 = textRight1 else { return }
        guard let textRightLabel2 = textRight2 else { return }
        
        for touch in touches {
            guard let closeSound = closeSound else { return }
            
            let touchButton = touch.location(in: self)
            let buttonPoint = atPoint(touchButton)
            
            if buttonPoint.name == "closeButton" {
                closeButton?.run(.setTexture(SKTexture(imageNamed: "closeButton2")))
                SettingsMenu.runSound(node: closeSound)
            }
            
            UdinDiaryScene.touchCount += 1
            
            switch UdinDiaryScene.touchCount {
            case 1:
                animateLabel(label: textLeftLabel1, text: leftText1)
            case 2:
                animateLabel(label: textLeftLabel2, text: leftText2)
            case 3:
                animateLabel(label: textRightLabel0, text: rightText0)
            case 4:
                animateLabel(label: textRightLabel1, text: rightText1)
            case 5:
                animateLabel(label: textRightLabel2, text: rightText2)
            default:
                if UdinDiaryScene.fromScene == "BagpackScene" {
                    let bagpackScene = SKScene(fileNamed: "BagpackScene")
                    bagpackScene?.scaleMode = .aspectFit
                    self.view?.presentScene(bagpackScene!, transition: SKTransition.fade(withDuration: 1.0))
                } else {
                    GameScene.point += 10
                    let scene = SKScene(fileNamed: "GameScene")
                    scene?.scaleMode = .aspectFit
                    self.view?.presentScene(scene!, transition: SKTransition.fade(withDuration: 1.0))
                }
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
                    bagpackScene?.scaleMode = .aspectFit
                    self.view?.presentScene(bagpackScene!, transition: SKTransition.fade(withDuration: 1.0))
                } else {
                    GameScene.point += 10
                    let scene = SKScene(fileNamed: "GameScene")
                    scene?.scaleMode = .aspectFit
                    self.view?.presentScene(scene!, transition: SKTransition.fade(withDuration: 1.0))
                }
            }
        }
    }
    
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
            } else {
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
}
