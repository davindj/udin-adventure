//
//  SettingsMenu.swift
//  UdinGame
//
//  Created by Alamsyah Oktavian on 08/04/21.
//

import SpriteKit

class SettingsMenu: SKScene {
    
    var closeButton: SKNode?
    var musicButton: SKSpriteNode?
    var soundButton: SKSpriteNode?
    var vibrateButton: SKSpriteNode?
    var emailButton: SKNode?
    
    // Sound and Music Bool
    static var hasSound = true
    static var hasMusic = true
    static var hasVibration = true
    
    // Sound
    var closeSound: SKAudioNode?
    var buttonSoundOn: SKAudioNode?
    var buttonSoundOff: SKAudioNode?
    var backgroundMusic: SKAudioNode?
        
    override func didMove(to view: SKView) {
        // Button
        closeButton = childNode(withName: "closeButton")
        musicButton = childNode(withName: "musicButton") as? SKSpriteNode
        soundButton = childNode(withName: "soundButton") as? SKSpriteNode
        vibrateButton = childNode(withName: "vibrateButton") as? SKSpriteNode
        emailButton = childNode(withName: "emailButton")
        
        buttonState()
        
        // Sound and Music
        closeSound = childNode(withName: "closeSound") as? SKAudioNode
        buttonSoundOn = childNode(withName: "buttonSoundOn") as? SKAudioNode
        buttonSoundOff = childNode(withName: "buttonSoundOff") as? SKAudioNode
        backgroundMusic = childNode(withName: "backgroundMusic") as? SKAudioNode
        
        if let backgroundMusic = backgroundMusic {
            SettingsMenu.runMusic(node: backgroundMusic)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            guard let backgroundMusic = backgroundMusic else { return }
            guard let closeSound = closeSound else { return }
            
            guard let musicDescription = musicButton?.texture?.description else { return }
            let musicButtonName = getTextureName(textureTmp: musicDescription)
            
            guard let soundDescription = soundButton?.texture?.description else { return }
            let soundButtonName = getTextureName(textureTmp: soundDescription)
            
            guard let vibrateDescription = vibrateButton?.texture?.description else { return }
            let vibrateButtonName = getTextureName(textureTmp: vibrateDescription)
            
            let locationButton = touch.location(in: self)
            let buttonPoint = atPoint(locationButton)
            
            // Set Button Pressed Effect
            switch buttonPoint.name {
            case "closeButton":
                closeButton?.run(.setTexture(SKTexture(imageNamed: "closeButton2")))
                SettingsMenu.stopMusic(node: backgroundMusic)
                SettingsMenu.runSound(node: closeSound)
            case "musicButton":
                if musicButtonName == "musicButton" {
                    musicButton?.run(.setTexture(SKTexture(imageNamed: "musicButton2")))
                } else if musicButtonName == "nomusicButton" {
                    musicButton?.run(.setTexture(SKTexture(imageNamed: "nomusicButton2")))
                }
            case "soundButton":
                if soundButtonName == "soundButton" {
                    soundButton?.run(.setTexture(SKTexture(imageNamed: "soundButton2")))
                } else if soundButtonName == "nosoundButton" {
                    soundButton?.run(.setTexture(SKTexture(imageNamed: "nosoundButton2")))
                }
            case "vibrateButton":
                if vibrateButtonName == "vibrateButton" {
                    vibrateButton?.run(.setTexture(SKTexture(imageNamed: "vibrateButton2")))
                } else if vibrateButtonName == "novibrateButton" {
                    vibrateButton?.run(.setTexture(SKTexture(imageNamed: "novibrateButton2")))
                }
            case "emailButton":
                emailButton?.run(.setTexture(SKTexture(imageNamed: "supportButton2")))
            default:
                print("")
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            guard let backgroundMusic = backgroundMusic else { return }
            guard let buttonSoundOn = buttonSoundOn else { return }
            guard let buttonSoundOff = buttonSoundOff else { return }
            
            guard let musicDescription = musicButton?.texture?.description else { return }
            let musicButtonName = getTextureName(textureTmp: musicDescription)
            
            guard let soundDescription = soundButton?.texture?.description else { return }
            let soundButtonName = getTextureName(textureTmp: soundDescription)
            
            guard let vibrateDescription = vibrateButton?.texture?.description else { return }
            let vibrateButtonName = getTextureName(textureTmp: vibrateDescription)
            
            let locationButton = touch.location(in: self)
            let buttonPoint = atPoint(locationButton)
            
            switch buttonPoint.name {
            case "closeButton":
                closeButton?.run(.setTexture(SKTexture(imageNamed: "closeButton")))
                
                //Back to GameScene
                let gameScene = GameScene(fileNamed: "GameScene")
                gameScene?.scaleMode = .aspectFill
                self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: 1.0))
            case "musicButton":
                if musicButtonName == "musicButton2" {
                    // Turn off music
                    SettingsMenu.runSound(node: buttonSoundOff)
                    SettingsMenu.stopMusic(node: backgroundMusic)
                    SettingsMenu.hasMusic = false
                    musicButton?.run(.setTexture(SKTexture(imageNamed: "nomusicButton")))
                } else if musicButtonName == "nomusicButton2" {
                    // Turn on music
                    SettingsMenu.runSound(node: buttonSoundOn)
                    SettingsMenu.hasMusic = true
                    SettingsMenu.runMusic(node: backgroundMusic)
                    musicButton?.run(.setTexture(SKTexture(imageNamed: "musicButton")))
                }
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
            case "vibrateButton":
                if vibrateButtonName == "vibrateButton2" {
                    // Turn off vibration
                    SettingsMenu.runSound(node: buttonSoundOff)
                    SettingsMenu.hasVibration = false
                    vibrateButton?.run(.setTexture(SKTexture(imageNamed: "novibrateButton")))
                } else if vibrateButtonName == "novibrateButton2" {
                    // Turn on vibration
                    SettingsMenu.runSound(node: buttonSoundOn)
                    SettingsMenu.hasVibration = true
                    vibrateButton?.run(.setTexture(SKTexture(imageNamed: "vibrateButton")))
                }
            case "emailButton":
                // Send support email
                emailButton?.run(.setTexture(SKTexture(imageNamed: "supportButton")))
            default:
                print("")
            }
        }
    }
    
    func buttonState() {
        if SettingsMenu.hasMusic {
            musicButton?.run(.setTexture(SKTexture(imageNamed: "musicButton")))
        } else {
            musicButton?.run(.setTexture(SKTexture(imageNamed: "nomusicButton")))
        }
        
        if SettingsMenu.hasSound {
            soundButton?.run(.setTexture(SKTexture(imageNamed: "soundButton")))
        } else {
            soundButton?.run(.setTexture(SKTexture(imageNamed: "nosoundButton")))
        }
        
        if SettingsMenu.hasVibration {
            vibrateButton?.run(.setTexture(SKTexture(imageNamed: "vibrateButton")))
        } else {
            vibrateButton?.run(.setTexture(SKTexture(imageNamed: "novibrateButton")))
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
    static func runMusic(node: SKAudioNode) {
        if SettingsMenu.hasMusic {
            node.run(SKAction.play())
            node.run(SKAction.changeVolume(to: 0.5, duration: 0.0))
            node.autoplayLooped = true
        }
    }
    
    static func runSound(node: SKAudioNode) {
        if SettingsMenu.hasSound {
            node.run(SKAction.play())
        }
    }
    
    static func stopMusic(node: SKAudioNode) {
        node.run(SKAction.stop())
    }
    
    static func stopSound(node: SKAudioNode) {
        node.run(SKAction.stop())
    }
    
}


