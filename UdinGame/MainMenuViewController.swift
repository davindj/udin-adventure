//
//  MainMenuViewController.swift
//  UdinGame
//
//  Created by D’queen Wong on 07/04/21.
//

import UIKit

class MainMenuViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        playButton.setImage(UIImage(named: "playButton2"), for: .highlighted)
    }
}
