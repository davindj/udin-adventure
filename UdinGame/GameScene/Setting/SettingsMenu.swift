//
//  SettingsMenu.swift
//  UdinGame
//
//  Created by Alamsyah Oktavian on 08/04/21.
//  Maintined by Dimas A. Prabowo on 12/04/21.

import SpriteKit
import AVFoundation

class SettingsMenu: SKScene {
    
    var closeButton: SKNode?
    var soundButton: SKSpriteNode?
    
    // Sound and Music Bool
    static var hasSound = true
    static var hasMusic = true
    static var hasVibration = true
    
    // Sound
    var closeSound: SKAudioNode?
    var buttonSoundOn: SKAudioNode?
    var buttonSoundOff: SKAudioNode?
        
    override func didMove(to view: SKView) {
        // Button
        closeButton = childNode(withName: "closeButton")
        soundButton = childNode(withName: "soundButton") as? SKSpriteNode
        
        buttonState()
        
        // Sound and Music
        closeSound = childNode(withName: "closeSound") as? SKAudioNode
        buttonSoundOn = childNode(withName: "buttonSoundOn") as? SKAudioNode
        buttonSoundOff = childNode(withName: "buttonSoundOff") as? SKAudioNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            guard let closeSound = closeSound else { return }
            
            guard let soundDescription = soundButton?.texture?.description else { return }
            let soundButtonName = getTextureName(textureTmp: soundDescription)
            
            let locationButton = touch.location(in: self)
            let buttonPoint = atPoint(locationButton)
            
            // Set Button Pressed Effect
            switch buttonPoint.name {
            case "closeButton":
                closeButton?.run(.setTexture(SKTexture(imageNamed: "closeButton2")))
                SettingsMenu.runSound(node: closeSound)
            case "soundButton":
                if soundButtonName == "soundButton" {
                    soundButton?.run(.setTexture(SKTexture(imageNamed: "soundButton2")))
                } else if soundButtonName == "nosoundButton" {
                    soundButton?.run(.setTexture(SKTexture(imageNamed: "nosoundButton2")))
                }
            default:
                print("")
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            guard let buttonSoundOn = buttonSoundOn else { return }
            guard let buttonSoundOff = buttonSoundOff else { return }
            
            guard let soundDescription = soundButton?.texture?.description else { return }
            let soundButtonName = getTextureName(textureTmp: soundDescription)
            
            let locationButton = touch.location(in: self)
            let buttonPoint = atPoint(locationButton)
            
            switch buttonPoint.name {
            case "closeButton":
                closeButton?.run(.setTexture(SKTexture(imageNamed: "closeButton")))
                
                //Back to GameScene
                let gameScene = GameScene(fileNamed: "GameScene")
                let transition = SKTransition.fade(withDuration: 1.0)
                IntroViewController.presentGameScene(toScene: gameScene!, transition: transition)
            case "soundButton":
                if soundButtonName == "soundButton2" {
                    // Turn off sound
                    SettingsMenu.runSound(node: buttonSoundOff)
                    SettingsMenu.hasSound = false
                    soundButton?.run(.setTexture(SKTexture(imageNamed: "nosoundButton")))
                } else if soundButtonName == "nosoundButton2" {
                    // Turn on sound
                    SettingsMenu.runSound(node: buttonSoundOn)
                    SettingsMenu.hasSound = true
                    soundButton?.run(.setTexture(SKTexture(imageNamed: "soundButton")))
                }
            default:
                print("")
            }
        }
    }
    
    func buttonState() {
        if SettingsMenu.hasSound {
            soundButton?.run(.setTexture(SKTexture(imageNamed: "soundButton")))
        } else {
            soundButton?.run(.setTexture(SKTexture(imageNamed: "nosoundButton")))
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
    
    // MARK: Play Sound and Music
    static func runMusic(node: AVAudioPlayer) {
        if SettingsMenu.hasMusic {
            node.volume = 0.7
            node.play()
        }
    }
    
    static func runSound(node: SKAudioNode) {
        if SettingsMenu.hasSound {
            node.run(SKAction.play())
        }
    }
    
    static func stopMusic(node: AVAudioPlayer) {
        node.stop()
    }
    
    static func stopSound(node: SKAudioNode) {
        node.run(SKAction.stop())
    }
    
}


