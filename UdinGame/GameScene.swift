//
//  GameScene.swift
//  UdinTest
//
//  Created by Dimas A. Prabowo on 06/04/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    // Character
    var player: SKNode?
    var udin: SKNode?
    var anton: SKNode?
    var yusuf: SKNode?
    var toni: SKNode?
    
    // Joystick
    var joystick: SKNode?
    var joystickKnob: SKNode?
    
    // Button
    var actionButton: SKNode?
    var udinButton: SKNode?
    var antonButton: SKNode?
    var yusufButton: SKNode?
    var toniButton: SKNode?
    var bag: SKNode?
    var book: SKNode?
    var settingButton: SKNode?
    var buttonText: SKLabelNode?
    
    // Background
    var background: SKNode?
    
    // PopUp
    var popUpUdin: SKNode?
    var popUpLabel: SKLabelNode?
    let popUpText = "Kamu sudah mendapat cukup informasi \nAyo bicara dengan Udin"
    
    // Animation
    var framePlayerSide = [SKTexture]()
    var framePlayerFront = [SKTexture]()
    var framePlayerRear = [SKTexture]()
    let frameDuration = 0.1
    
    // Boolean
    var joystickAction = false

    // Measure
    var knobRadius : CGFloat = 75.0
    
    // Sprite Engine
    var previousTimeInterval : TimeInterval = 0
    var playerIsFacingRight = true
    let playerSpeed = 2.0
    let objectRange = 100.0
    
    // Event State
    static var hasDiaryUdin = false
    static var hasAntonInsight = false
    static var hasYusufInsight = false
    static var hasToniInsight = false
    static var hasPopUp = false
    
    // Player position data
    static var playerPosition = CGPoint(x: 120, y: 285)
    
    // Game point
    static var point = 0
    
    // Text properties
    static var fontName = "Verdana"
    static var fontType = "Bold"
    
    // Sound and Music
    var backgroundMusic: SKAudioNode?
    var walkSound: SKAudioNode?
    var eventTriggerSound: SKAudioNode?
    var buttonSound: SKAudioNode?
    var bagpackSound: SKAudioNode?
    var settingSound: SKAudioNode?
    var popUpSound: SKAudioNode?
    
    override func didMove(to view: SKView) {
        player = childNode(withName: "player")
        player?.position = GameScene.playerPosition
        buildPlayer()
        
        // Item
        book = childNode(withName: "book")
        
        // NPC
        udin = childNode(withName: "udin")
        anton = childNode(withName: "anton")
        yusuf = childNode(withName: "yusuf")
        toni = childNode(withName: "toni")
        
        // Joystick
        joystick = childNode(withName: "joystick")
        joystickKnob = joystick?.childNode(withName: "knob")
        
        // Button
        settingButton = childNode(withName: "setting")
        bag = childNode(withName: "bag")
        actionButton = childNode(withName: "actionButton")
        udinButton = childNode(withName: "udinButton")
        antonButton = childNode(withName: "antonButton")
        yusufButton = childNode(withName: "yusufButton")
        toniButton = childNode(withName: "toniButton")
        buttonText = childNode(withName: "buttonText") as? SKLabelNode
        
        // Background
        background = childNode(withName: "background")
        
        // PopUp Udin
        popUpUdin = childNode(withName: "popUpUdin")
        popUpLabel = popUpUdin?.childNode(withName: "popUpText") as? SKLabelNode
        
        // Music
        backgroundMusic = childNode(withName: "backgroundMusic") as? SKAudioNode
        walkSound = childNode(withName: "walkSound") as? SKAudioNode
        eventTriggerSound = childNode(withName: "eventTriggerSound") as? SKAudioNode
        buttonSound = childNode(withName: "buttonSound") as? SKAudioNode
        bagpackSound = childNode(withName: "bagpackSound") as? SKAudioNode
        settingSound = childNode(withName: "settingSound") as? SKAudioNode
        popUpSound = childNode(withName: "popUpSound") as? SKAudioNode
        
        // Hide
        actionButton?.isHidden = true
        udinButton?.isHidden = true
        antonButton?.isHidden = true
        yusufButton?.isHidden = true
        toniButton?.isHidden = true
        buttonText?.isHidden = true
        popUpUdin?.isHidden = true
        
    }
    
    // Build player walk animation
    func buildPlayer() {
        let playerSideAtlas = SKTextureAtlas(named: "PlayerSide")
        let playerFrontAtlas = SKTextureAtlas(named: "PlayerFront")
        let playerRearAtlas = SKTextureAtlas(named: "PlayerRear")
        
        // Physics
        player?.physicsBody = SKPhysicsBody(circleOfRadius: 50.0, center: CGPoint(x: 0, y: -112.15))
        player?.physicsBody?.affectedByGravity = false
        
        for i in 0..<playerSideAtlas.textureNames.count {
            let textureSideName = "Side" + String(i)
            framePlayerSide.append(playerSideAtlas.textureNamed(textureSideName))
        }
        
        for i in 0..<playerFrontAtlas.textureNames.count {
            let textureFrontName = "Front" + String(i)
            framePlayerFront.append(playerFrontAtlas.textureNamed(textureFrontName))
        }
        
        for i in 0..<playerRearAtlas.textureNames.count {
            let textureRearName = "Rear" + String(i)
            framePlayerRear.append(playerRearAtlas.textureNamed(textureRearName))
        }
    }
}

// MARK: Touches
extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            guard let buttonSound = buttonSound else { return }
            guard let bagpackSound = bagpackSound else { return }
            guard let settingSound = settingSound else { return }
            
            // Read touch in joystick
            if let joystickKnob = joystickKnob {
                let locationJoystick = touch.location(in: joystick!)
                joystickAction = joystickKnob.frame.contains(locationJoystick)
            }
            
            if joystickAction {
                player?.run(.repeatForever(.animate(with: framePlayerSide, timePerFrame: frameDuration)))
            }
            
            // Close popup
            if !popUpUdin!.isHidden {
                popUpUdin?.isHidden = true
            }
            
            // MARK: Animate, Sound, and Music button
            // Button pressed effect
            let locationButton = touch.location(in: self)
            let buttonPoint = atPoint(locationButton)
            
            switch buttonPoint.name {
            case "actionButton":
                actionButton?.run(.setTexture(SKTexture(imageNamed: "interactButton2")))
                SettingsMenu.runSound(node: buttonSound)
            case "udinButton":
                udinButton?.run(.setTexture(SKTexture(imageNamed: "talkButton2")))
                SettingsMenu.runSound(node: buttonSound)
            case "antonButton":
                antonButton?.run(.setTexture(SKTexture(imageNamed: "talkButton2")))
                SettingsMenu.runSound(node: buttonSound)
            case "yusufButton":
                yusufButton?.run(.setTexture(SKTexture(imageNamed: "talkButton2")))
                SettingsMenu.runSound(node: buttonSound)
            case "toniButton" :
                toniButton?.run(.setTexture(SKTexture(imageNamed: "talkButton2")))
                SettingsMenu.runSound(node: buttonSound)
            case "bag":
                bag?.run(.setTexture(SKTexture(imageNamed: "bagButton2")))
                SettingsMenu.runSound(node: bagpackSound)
            case "setting":
                settingButton?.run(.setTexture(SKTexture(imageNamed: "settingButton2")))
                SettingsMenu.runSound(node: settingSound)
            default:
                print("")
            }
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Read joystick knob movement
        guard let joystick = joystick else { return }
        guard let joystickKnob = joystickKnob else { return }
        guard let walkSound = walkSound else { return }
        
        if !joystickAction { return }
        
        for touch in touches {
            // Get joystick knob displacement
            let position = touch.location(in: joystick)
            
            let length = sqrt(pow(position.y, 2) + pow(position.x, 2))
            let angle = atan2(position.y, position.x)
            
            if knobRadius > length {
                joystickKnob.position = position
            } else {
                joystickKnob.position = CGPoint(x: cos(angle) * knobRadius, y: sin(angle) * knobRadius)
            }
            
            // Animate player based on joystick knob
            if abs(position.x) < abs(position.y) && position.y < 0  {
                player?.run(.repeatForever(.animate(with: framePlayerFront, timePerFrame: frameDuration)))
            } else if abs(position.x) < abs(position.y) && position.y > 0 {
                player?.run(.repeatForever(.animate(with: framePlayerRear, timePerFrame: frameDuration)))
            } else {
                player?.run(.repeatForever(.animate(with: framePlayerSide, timePerFrame: frameDuration)))
            }
            
            // Play walk sound
            SettingsMenu.runSound(node: walkSound)
            
            // Reset Knob
            if length > 300.0 {
                resetKnobPosition()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            // Reset joystick knob position
            let xJoystickCoordinate = touch.location(in: joystick!).x
            let xLimit: CGFloat = 300.0
            if xJoystickCoordinate > -xLimit && xJoystickCoordinate < xLimit {
                resetKnobPosition()
            }
            player!.removeAllActions()
            
            // Stop walk sound
            walkSound?.run(SKAction.stop())
            
            // MARK: Navigation to other scene
            // Triggered by button
            let locationButton = touch.location(in: self)
            let buttonPoint = atPoint(locationButton)
            
            switch buttonPoint.name {
            case "actionButton":
                actionButton?.run(.setTexture(SKTexture(imageNamed: "interactButton")))
                
                // Go to BookScene
                let bookScene = UdinDiaryScene(fileNamed: "UdinDiaryScene")
                bookScene?.scaleMode = .aspectFill
                self.view?.presentScene(bookScene!, transition: SKTransition.fade(withDuration: 1.0))
            case "udinButton":
                udinButton?.run(.setTexture(SKTexture(imageNamed: "talkButton")))
                
                // Go to BattleScene
                let udinScene = InteractionAnton(fileNamed: "BattleScene")
                udinScene?.scaleMode = .aspectFill
                self.view?.presentScene(udinScene!, transition: SKTransition.fade(withDuration: 1.0))
            case "antonButton":
                antonButton?.run(.setTexture(SKTexture(imageNamed: "talkButton")))
                
                // Go to InteractionAnton
                let antonScene = InteractionAnton(fileNamed: "InteractionAnton")
                antonScene?.scaleMode = .aspectFill
                self.view?.presentScene(antonScene!, transition: SKTransition.fade(withDuration: 1.0))
            case "yusufButton":
                yusufButton?.run(.setTexture(SKTexture(imageNamed: "talkButton")))
                
                // Go to InteractionToni
                let yusufScene = InteractionYusuf(fileNamed: "InteractionYusuf")
                yusufScene?.scaleMode = .aspectFill
                self.view?.presentScene(yusufScene!, transition: SKTransition.fade(withDuration: 1.0))
            case "toniButton" :
                toniButton?.run(.setTexture(SKTexture(imageNamed: "talkButton")))
                
                // Go to InteractionToni
                let toniScene = InteractionToni(fileNamed: "InteractionToni")
                toniScene?.scaleMode = .aspectFill
                self.view?.presentScene(toniScene!, transition: SKTransition.fade(withDuration: 1.0))
            case "bag":
                bag?.run(.setTexture(SKTexture(imageNamed: "bagButton")))
                
                // Go to BagpackScene
                let bagpackScene = BagpackScene(fileNamed: "OutroGoodScene")
                bagpackScene?.scaleMode = .aspectFill
                self.view?.presentScene(bagpackScene!, transition: SKTransition.fade(withDuration: 1.0))
            case "setting":
                settingButton?.run(.setTexture(SKTexture(imageNamed: "settingButton")))
                
                // Go to SettingsMenu
                let settingScene = SettingsMenu(fileNamed: "SettingsMenu")
                settingScene?.scaleMode = .aspectFill
                self.view?.presentScene(settingScene!, transition: SKTransition.fade(withDuration: 1.0))
            default:
                print("")
            }
        }
    }
}

// MARK: Action
extension GameScene {
    func resetKnobPosition() {
        let initialPoint = CGPoint(x: 0, y: 0)
        let moveBack = SKAction.move(to: initialPoint, duration: 0.1)
        moveBack.timingMode = .linear
        joystickKnob?.run(moveBack)
        joystickAction = false
    }
}

// MARK: Game Loop
extension GameScene {
    override func update(_ currentTime: TimeInterval) {
        guard let positionPlayer = player?.position else{ return }
        
        super.update(currentTime)
        if let cameraplay = camera, let pl = player{
            cameraplay.position = pl.position
        }
        let deltaTime = currentTime - previousTimeInterval
        previousTimeInterval = currentTime
        
        // Set player movement
        // Based on joystick knob displacement
        guard let joystickKnob = joystickKnob else { return }
        let xPosition = Double(joystickKnob.position.x)
        let yPosition = Double(joystickKnob.position.y)
        let displacement = CGVector(dx: deltaTime * xPosition * playerSpeed, dy: deltaTime * yPosition * playerSpeed)
        let move = SKAction.move(by: displacement, duration: 0)
        let movingRight = xPosition > 0
        let movingLeft = xPosition < 0
        if movingLeft && playerIsFacingRight {
            playerIsFacingRight = false
            player!.xScale = abs(player!.xScale) * -1.0
        } else if movingRight && !playerIsFacingRight {
            playerIsFacingRight = true
            player!.xScale = abs(player!.xScale) * 1.0
        }
        
        player?.run(move)
        
        showPopUp()
        event()
        buttonPosition()
        
        // Set player position
        GameScene.playerPosition = positionPlayer
    }
    
    // MARK: Setting Button Position
    // From camera
    func buttonPosition() {
        guard let positionPlayer = player?.position else{ return }
        
        joystick?.position = CGPoint(x: positionPlayer.x - 1000.0, y: positionPlayer.y - 400.0)
        actionButton?.position = CGPoint(x: positionPlayer.x + 850.0, y: positionPlayer.y - 250.0)
        udinButton?.position = CGPoint(x: positionPlayer.x + 850.0, y: positionPlayer.y - 250.0)
        antonButton?.position = CGPoint(x: positionPlayer.x + 850.0, y: positionPlayer.y - 250.0)
        yusufButton?.position = CGPoint(x: positionPlayer.x + 850.0, y: positionPlayer.y - 250.0)
        toniButton?.position = CGPoint(x: positionPlayer.x + 850.0, y: positionPlayer.y - 250.0)
        buttonText?.position = CGPoint(x: positionPlayer.x + 850.0, y: positionPlayer.y - 400.0)
        bag?.position = CGPoint(x: positionPlayer.x + 1050.0, y: positionPlayer.y - 400.0)
        settingButton?.position = CGPoint(x: positionPlayer.x - 1050.0, y: positionPlayer.y + 450.0)
        popUpUdin?.position = CGPoint(x: positionPlayer.x, y: positionPlayer.y)
    }
    
    // MARK: Trigger Event
    // Based on distance
    func event() {
        guard let bookPosition = book?.position else { return }
        guard let udinPosition = udin?.position else { return }
        guard let antonPosition = anton?.position else { return }
        guard let yusufPosition = yusuf?.position else { return }
        guard let toniPosition = toni?.position else { return }
        guard let textButton = buttonText else { return }
        guard let eventSound = eventTriggerSound else { return }
        
        if getDistanceMax(itemPosition: bookPosition, distance: 100.0) && !GameScene.hasDiaryUdin {
            // Udin Diary
            actionButton?.isHidden = false
            textAlignment(string: "Baca \nDiari Udin", label: textButton, size: 30.0, color: UIColor.brown)
            buttonText?.isHidden = false
            book?.run(.setTexture(SKTexture(imageNamed: "highlightedBook")))
            SettingsMenu.runSound(node: eventSound)
        } else if getDistanceMax(itemPosition: udinPosition, distance: 100.0) && GameScene.point >= 20 {
            // Confront Udin
            udinButton?.isHidden = false
            textAlignment(string: "Ngobrol \nDengan Udin", label: textButton, size: 30.0, color: UIColor.brown)
            buttonText?.isHidden = false
            udin?.run(.setTexture(SKTexture(imageNamed: "highlightedUdin")))
            SettingsMenu.runSound(node: eventSound)
        } else if getDistanceMax(itemPosition: antonPosition, distance: 100.0) && !GameScene.hasAntonInsight {
            // Anton Insight
            antonButton?.isHidden = false
            textAlignment(string: "Ngobrol \nDengan Anton", label: textButton, size: 30.0, color: UIColor.brown)
            buttonText?.isHidden = false
            anton?.run(.setTexture(SKTexture(imageNamed: "highlightedBully1")))
            SettingsMenu.runSound(node: eventSound)
        } else if getDistanceMax(itemPosition: yusufPosition, distance: 100.0) && !GameScene.hasYusufInsight {
            // Yusuf Insight
            yusufButton?.isHidden = false
            textAlignment(string: "Ngobrol \nDengan Yusuf", label: textButton, size: 30.0, color: UIColor.brown)
            buttonText?.isHidden = false
            yusuf?.run(.setTexture(SKTexture(imageNamed: "highlightedBully2")))
            SettingsMenu.runSound(node: eventSound)
        } else if getDistanceMax(itemPosition: toniPosition, distance: 100.0) && !GameScene.hasToniInsight {
            // Toni Insight
            toniButton?.isHidden = false
            textAlignment(string: "Ngobrol \nDengan Toni", label: textButton, size: 30.0, color: UIColor.brown)
            buttonText?.isHidden = false
            toni?.run(.setTexture(SKTexture(imageNamed: "highlightedBully3")))
            SettingsMenu.runSound(node: eventSound)
        } else {
            actionButton?.isHidden = true
            antonButton?.isHidden = true
            yusufButton?.isHidden = true
            toniButton?.isHidden = true
            buttonText?.isHidden = true
            book?.run(.setTexture(SKTexture(imageNamed: "buku")))
            anton?.run(.setTexture(SKTexture(imageNamed: "bully1")))
            yusuf?.run(.setTexture(SKTexture(imageNamed: "bully2")))
            toni?.run(.setTexture(SKTexture(imageNamed: "bully3")))
            SettingsMenu.stopSound(node: eventSound)
        }
    }
    
    func showPopUp() {
        guard let labelPopUp = popUpLabel else { return }
        guard let popUpSound = popUpSound else { return }
        
        if GameScene.point >= 20 && !GameScene.hasPopUp {
            SettingsMenu.runSound(node: popUpSound)
            popUpUdin?.isHidden = false
            GameScene.hasPopUp = true
            popUpUdin?.alpha = 0.8
            textAlignment(string: popUpText, label: labelPopUp, color: UIColor.brown)
        }
    }
    
    func getDistanceMax(itemPosition: CGPoint, distance: CGFloat) -> Bool {
        if let playerPosition = player?.position {
            return abs(playerPosition.x - itemPosition.x) < distance && abs(playerPosition.y - itemPosition.y) < distance
        }
        
        return false
    }
    
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
    
}
