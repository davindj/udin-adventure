//
//  BattleScene.swift
//  UdinGame
//
//  Created by Davin Djayadi on 07/04/21.
//

import SpriteKit

class BattleScene: SKScene{
    
    // Variable
    var previousTime: TimeInterval = 0
    
    override func didMove(to view: SKView) {
//        player = childNode(withName: "player")
//        joystick = childNode(withName: "joystick")
//        joystickKnob = joystick?.childNode(withName: "knob")
//
//        player?.physicsBody = SKPhysicsBody(circleOfRadius: 50.0, center: CGPoint(x: 0, y: -112.15))
//        player?.physicsBody?.affectedByGravity = false
//
//        buildPlayer()
        
//        guard let camera = = childNode(withName: "camera") as SKCameraNode{
//
//        }
//        camera
//        let scaleOut = SKAction.scale(to: 2, duration: 1000)
//        camera?.run(scaleOut)
        
    }
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = currentTime - previousTime
        previousTime = currentTime
    }
}
