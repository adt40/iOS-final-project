//
//  MainMenuViewController.swift
//  iOS-Final-Project
//
//  Created by Austin Toot on 3/25/18.
//  Copyright © 2018 Austin Toot. All rights reserved.
//

import UIKit
import SpriteKit

class MainMenuViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var spriteView: SKView!
    var mainMenuScene : MainMenuScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainMenuScene = MainMenuScene(size: spriteView.bounds.size)
        mainMenuScene!.scaleMode = .resizeFill
        spriteView.presentScene(mainMenuScene)
        
        mainMenuScene?.initialize()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "ToLevelSelect", sender: self)
    }
}
