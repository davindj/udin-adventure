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
        
    override func didMove(to view: SKView) {
        closeButton = childNode(withName: "closeButton")
        musicButton = childNode(withName: "musicButton") as? SKSpriteNode
        soundButton = childNode(withName: "soundButton") as? SKSpriteNode
        vibrateButton = childNode(withName: "vibrateButton") as? SKSpriteNode
        emailButton = childNode(withName: "emailButton")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
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
                    // Turn to no music
                    musicButton?.run(.setTexture(SKTexture(imageNamed: "nomusicButton")))
                } else if musicButtonName == "nomusicButton2" {
                    musicButton?.run(.setTexture(SKTexture(imageNamed: "musicButton")))
                }
            case "soundButton":
                if soundButtonName == "soundButton2" {
                    // Turn to no sound
                    soundButton?.run(.setTexture(SKTexture(imageNamed: "nosoundButton")))
                } else if soundButtonName == "nosoundButton2" {
                    soundButton?.run(.setTexture(SKTexture(imageNamed: "soundButton")))
                }
            case "vibrateButton":
                if vibrateButtonName == "vibrateButton2" {
                    // Turn to no vibration
                    vibrateButton?.run(.setTexture(SKTexture(imageNamed: "novibrateButton")))
                } else if vibrateButtonName == "novibrateButton2" {
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
    
}


