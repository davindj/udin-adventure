//
//  Redemption.swift
//  UdinGame
//
//  Created by Davin Djayadi on 13/04/21.
//

import Foundation
import SpriteKit

// MARK: Main Class
class RedemptionScene: SKScene{
    static var N_REDEMPT: Int = 0
    static var isHappyEnding: Bool = false
    // MARK: Constructor
    override func didMove(to view: SKView) {
        if RedemptionScene.isHappyEnding{ // Jika Happy Ending
            goodEnd()
        }else if RedemptionScene.N_REDEMPT >= 1{ // Jika Sad Ending
            badEnd()
        }else{ // Masih Ada kesempatan Redemption
            RedemptionScene.N_REDEMPT += 1
            self.camera = childNode(withName: "camera") as? SKCameraNode
        }
    }
    
    // MARK: End Function
    // Function yg dijalankan ketika player sudah mencapai scene terkahir
    func eofGame(){
        RedemptionScene.N_REDEMPT = 0
    }
    
    // MARK: Scene Navigation
    func goodEnd(){
        eofGame()
        openScene(scene: OutroGoodScene(fileNamed: "OutroGood0"))
    }
    
    func badEnd(){
        eofGame()
        openScene(scene: OutroBadScene(fileNamed: "OutroBad0"))
    }
    
    func battleEnd(){
        openScene(scene: BattleScene(fileNamed: "BattleScene"))
    }
    
    func openScene(scene gameScene: SKScene?){
        gameScene!.scaleMode = .aspectFill
        self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: 1.0))
    }
    
    // MARK: Event Handler
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let locationButton = touch.location(in: self)
            let node = atPoint(locationButton)
            let name = node.name
            switch name{
            case "labelYes":
                battleEnd()
                return
            case "labelNo":
                badEnd()
                return
            default:
                print("")
            }
        }
    }
}
