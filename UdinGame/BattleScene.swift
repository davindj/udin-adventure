//
//  BattleScene.swift
//  UdinGame
//
//  Created by Davin Djayadi on 07/04/21.
//

import SpriteKit

class BattleScene: SKScene{
    // Component
    
    // Frame
    var framePlayerFront = [SKTexture]()
    
    // Variable
    var previousTime: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        // Get Component
        self.camera = childNode(withName: "camera") as? SKCameraNode
        // Load Sprite
        loadSprite()
        // Animating
        animateIntroScene{
            self.animateBackground(duration: 1.5)
            self.animateCamera(duration: 1.5)
            self.animateCharacter()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = currentTime - previousTime
        previousTime = currentTime
    }
    
    // MARK: Animate Function
    func animateIntroScene(callBack cb: @escaping (()->Void) = {}){
        // Change Z Index of bgNode
        guard let bgNode = childNode(withName: "bgIntro") as? SKSpriteNode else {return}
        bgNode.zPosition = 0
        // Animate Text
        let introText: String = "Udin..."
        guard let textIntro = childNode(withName: "textIntro") as? SKLabelNode else{return}
        textIntro.text = ""
        // SKAction
        var idx = 0
        var closureAnim: (()->Void)!
        closureAnim = {
            if idx >= introText.count{
                // Sudah Dianimasikan Semua...
                // Delay 1 Detik Terus hapus text
                let action = SKAction.wait(forDuration: 1)
                textIntro.run(action){
                    textIntro.text = ""
                    cb()
                }
            }else{
                // Masih Dalam Iterasi
                let index = introText.index(introText.startIndex, offsetBy: idx)
                let currentString = String(introText[index])
                let action = SKAction.sequence([
                    SKAction.wait(forDuration: currentString == "." ? 0.5 : 0.15),
                    SKAction.run{
                        idx += 1
                        textIntro.text = String(introText.prefix(idx))
                    }
                ])
                textIntro.run(action){
                    closureAnim()
                }
            }
        }
        // Panggil animasi
        closureAnim()
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
    
    // Animate Player & Udin Character into Scene
    func animateCharacter(callback cb: @escaping (()->Void) = {}){
        
    }
    
    // MARK: Load Sprite Function
    // Load Semua Textture dari Semua Sprite
    func loadSprite(){
        framePlayerFront = loadTexture(spriteName: "UdinFront", textureName: "Front")
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
        return listTexture
    }
}
