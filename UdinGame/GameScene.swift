//
//  GameScene.swift
//  UdinTest
//
//  Created by Dimas A. Prabowo on 06/04/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var player: SKNode?
    var joystick: SKNode?
    var joystickKnob: SKNode?
    
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
    
    
    
    override func didMove(to view: SKView) {
        player = childNode(withName: "player")
        joystick = childNode(withName: "joystick")
        joystickKnob = joystick?.childNode(withName: "knob")
        
        player?.physicsBody = SKPhysicsBody(circleOfRadius: 50.0, center: CGPoint(x: 0, y: -112.15))
        player?.physicsBody?.affectedByGravity = false
        
        buildPlayer()
    }
    
    func buildPlayer() {
        let playerSideAtlas = SKTextureAtlas(named: "UdinSide")
        let playerFrontAtlas = SKTextureAtlas(named: "UdinFront")
        let playerRearAtlas = SKTextureAtlas(named: "UdinRear")
        
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
                let location = touch.location(in: joystick!)
                joystickAction = joystickKnob.frame.contains(location)
            }
            
            player?.run(.repeatForever(.animate(with: framePlayerSide, timePerFrame: frameDuration)))
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
        
    }
}
