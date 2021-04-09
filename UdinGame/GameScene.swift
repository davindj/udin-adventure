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
    var anton: SKNode?
    var yusuf: SKNode?
    var toni: SKNode?
    
    
    // Utility
    var joystick: SKNode?
    var joystickKnob: SKNode?
    var actionButton: SKNode?
    var antonButton: SKNode?
    var yusufButton: SKNode?
    var toniButton: SKNode?
    var bag: SKNode?
    var book: SKNode?
    var settingButton: SKNode?
    var action: SKLabelNode?
    
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
    
    
    override func didMove(to view: SKView) {
        player = childNode(withName: "player")
        buildPlayer()
        
        // Item
        book = childNode(withName: "book")
        
        // NPC
        anton = childNode(withName: "anton")
        yusuf = childNode(withName: "yusuf")
        toni = childNode(withName: "toni")
        
        // Utility
        joystick = childNode(withName: "joystick")
        joystickKnob = joystick?.childNode(withName: "knob")
        settingButton = childNode(withName: "setting")
        bag = childNode(withName: "bag")
        actionButton = childNode(withName: "actionButton")
        antonButton = childNode(withName: "antonButton")
        yusufButton = childNode(withName: "yusufButton")
        toniButton = childNode(withName: "toniButton")
        action = childNode(withName: "actionName") as? SKLabelNode
        
        actionButton?.isHidden = true
        antonButton?.isHidden = true
        yusufButton?.isHidden = true
        toniButton?.isHidden = true
        
        action?.isHidden = true
        action?.fontSize = 32.0
        action?.horizontalAlignmentMode = .center
        action?.lineBreakMode = .byTruncatingMiddle
        
    }
    
    func buildPlayer() {
        let playerSideAtlas = SKTextureAtlas(named: "UdinSide")
        let playerFrontAtlas = SKTextureAtlas(named: "UdinFront")
        let playerRearAtlas = SKTextureAtlas(named: "UdinRear")
        
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
            if let joystickKnob = joystickKnob {
                let locationJoystick = touch.location(in: joystick!)
                joystickAction = joystickKnob.frame.contains(locationJoystick)
            }
            
            if joystickAction {
                player?.run(.repeatForever(.animate(with: framePlayerSide, timePerFrame: frameDuration)))
            }
            
            let locationButton = touch.location(in: self)
            let buttonPoint = atPoint(locationButton)
            
            switch buttonPoint.name {
            case "actionButton":
                actionButton?.run(.setTexture(SKTexture(imageNamed: "interactButton2")))
                print("Go to UdinDiaryScene")
            case "antonButton":
                antonButton?.run(.setTexture(SKTexture(imageNamed: "talkButton2")))
                print("Go to antonScene")
            case "yusufButton":
                yusufButton?.run(.setTexture(SKTexture(imageNamed: "talkButton2")))
                print("Go to yusufScene")
            case "toniButton" :
                toniButton?.run(.setTexture(SKTexture(imageNamed: "talkButton2")))
                print("Go to toniScene")
            case "bag":
                bag?.run(.setTexture(SKTexture(imageNamed: "bagButton2")))
                
                // Go to BagpackScene
                let bagpackScene = BagpackScene(fileNamed: "BagpackScene")
                bagpackScene?.scaleMode = .aspectFill
                self.view?.presentScene(bagpackScene!, transition: SKTransition.fade(withDuration: 0.5))
            case "setting":
                settingButton?.run(.setTexture(SKTexture(imageNamed: "settingButton2")))
                
                // Go to SettingsMenu
                let settingScene = SettingsMenu(fileNamed: "SettingsMenu")
                settingScene?.scaleMode = .aspectFill
                self.view?.presentScene(settingScene!, transition: SKTransition.fade(withDuration: 0.5))
            default:
                print("")
            }
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let joystick = joystick else { return }
        guard let joystickKnob = joystickKnob else { return }
        
        if !joystickAction { return }
        
        // Distance
        for touch in touches {
            let position = touch.location(in: joystick)
            
            let length = sqrt(pow(position.y, 2) + pow(position.x, 2))
            let angle = atan2(position.y, position.x)
            
            if knobRadius > length {
                joystickKnob.position = position
            } else {
                joystickKnob.position = CGPoint(x: cos(angle) * knobRadius, y: sin(angle) * knobRadius)
            }
            
            if abs(position.x) < abs(position.y) && position.y < 0  {
                player?.run(.repeatForever(.animate(with: framePlayerFront, timePerFrame: frameDuration)))
            } else if abs(position.x) < abs(position.y) && position.y > 0 {
                player?.run(.repeatForever(.animate(with: framePlayerRear, timePerFrame: frameDuration)))
            } else {
                player?.run(.repeatForever(.animate(with: framePlayerSide, timePerFrame: frameDuration)))
            }
            
            if length > 300.0 {
                resetKnobPosition()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let xJoystickCoordinate = touch.location(in: joystick!).x
            let xLimit: CGFloat = 300.0
            if xJoystickCoordinate > -xLimit && xJoystickCoordinate < xLimit {
                resetKnobPosition()
            }
            player!.removeAllActions()
            
            let locationButton = touch.location(in: self)
            let buttonPoint = atPoint(locationButton)
            
            switch buttonPoint.name {
            case "actionButton":
                actionButton?.run(.setTexture(SKTexture(imageNamed: "interactButton")))
            case "antonButton":
                antonButton?.run(.setTexture(SKTexture(imageNamed: "talkButton")))
            case "yusufButton":
                yusufButton?.run(.setTexture(SKTexture(imageNamed: "talkButton")))
            case "toniButton" :
                toniButton?.run(.setTexture(SKTexture(imageNamed: "talkButton")))
                print("Go to toniScene")
            case "bag":
                bag?.run(.setTexture(SKTexture(imageNamed: "bagButton")))
            case "setting":
                settingButton?.run(.setTexture(SKTexture(imageNamed: "settingButton")))
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
        super.update(currentTime)
        if let cameraplay = camera, let pl = player{
            cameraplay.position = pl.position
        }
        let deltaTime = currentTime - previousTimeInterval
        previousTimeInterval = currentTime
        
        // Player Movement
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
        event()
        
        guard let positionPlayer = player?.position else{ return }
        
        joystick!.position = CGPoint(x: positionPlayer.x - 1000, y: positionPlayer.y - 400)
        actionButton!.position = CGPoint(x: positionPlayer.x + 850, y: positionPlayer.y - 250)
        antonButton!.position = CGPoint(x: positionPlayer.x + 850, y: positionPlayer.y - 250)
        yusufButton!.position = CGPoint(x: positionPlayer.x + 850, y: positionPlayer.y - 250)
        toniButton!.position = CGPoint(x: positionPlayer.x + 850, y: positionPlayer.y - 250)
        bag!.position = CGPoint(x: positionPlayer.x + 1000, y: positionPlayer.y - 400)
        settingButton!.position = CGPoint(x: positionPlayer.x - 1050, y: positionPlayer.y + 450)
    }
    
    // Event: Variable
    func event() {
        guard let bookPosition = book?.position else { return }
        guard let antonPosition = anton?.position else { return }
        guard let yusufPosition = yusuf?.position else { return }
        guard let toniPosition = toni?.position else { return }
        guard let playerPosition = player?.position else { return }
        
        if abs(playerPosition.x - bookPosition.x) < 100.0 && abs(playerPosition.y - bookPosition.y) < 100.0 {
            actionButton?.isHidden = false
            textAlignment(string: "Baca \nDiari Udin")
            action?.isHidden = false
        } else if abs(playerPosition.x - antonPosition.x) < 100.0 && abs(playerPosition.y - antonPosition.y) < 100.0 {
            antonButton?.isHidden = false
            textAlignment(string: "Ngobrol Dengan \nAnton")
            action?.isHidden = false
        } else if abs(playerPosition.x - yusufPosition.x) < 100.0 && abs(playerPosition.y - yusufPosition.y) < 100.0 {
            yusufButton?.isHidden = false
            textAlignment(string: "Ngobrol Dengan \nYusuf")
            action?.isHidden = false
        } else if abs(playerPosition.x - toniPosition.x) < 100.0 && abs(playerPosition.y - toniPosition.y) < 100.0 {
            toniButton?.isHidden = false
            textAlignment(string: "Ngobrol Dengan \nToni")
            action?.isHidden = false
        } else {
            actionButton?.isHidden = true
            antonButton?.isHidden = true
            yusufButton?.isHidden = true
            toniButton?.isHidden = true
            action?.isHidden = true
        }
    }
    
    func textAlignment(string: String) {
        let attrString = NSMutableAttributedString(string: string)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let range = NSRange(location: 0, length: string.count)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        attrString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 32)], range: range)
        action?.attributedText = attrString
    }
    
}
