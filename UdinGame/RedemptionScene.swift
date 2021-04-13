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
            openScene(scene: OutroGoodScene())
        }else if RedemptionScene.N_REDEMPT >= 1{ // Jika Sad Ending
            openScene(scene: OutroBadScene())
        }else{ // Masih Ada kesempatan Redemption
            RedemptionScene.N_REDEMPT += 1
        }
    }
    
    func openScene(scene gameScene: SKScene){
        gameScene.scaleMode = .aspectFill
        self.view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: 1.0))
    }
}
