//
//  LevelSelectViewController.swift
//  iOS-Final-Project
//
//  Created by Austin Toot on 3/25/18.
//  Copyright © 2018 Austin Toot. All rights reserved.
//

import UIKit

class LevelSelectViewController: UIViewController {

    //These should probably be generated programatically, since we have an arbitrary number of levels
    @IBOutlet weak var Level1Button: UIButton!
    @IBOutlet weak var Level2Button: UIButton!
    @IBOutlet weak var PopupWindowStartLevelButton: UIButton!
    @IBOutlet weak var PopupWindowCloseButton: UIButton!
    @IBOutlet weak var PopupWindowLabel: UILabel!
    @IBOutlet weak var PopupWindowRuntimeScoreLabel: UILabel!
    @IBOutlet weak var PopupWindowModuleScoreLabel: UILabel!
    
    @IBOutlet var PopupWindowView: UIView!
    
    var currentlySelectedData : (world: Int, level: Int, name: String, runtimeScore: Int, moduleScore: Int, sender: UIButton) = (world: 0, level: 0, name: "", runtimeScore: 0, moduleScore: 0, sender: UIButton())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    
    //connect this with any buttons created
    @IBAction func startLevelPressed(_ sender: UIButton) {
        updateLevelData(sender)
        PopupWindowLabel.text = currentlySelectedData.name
        PopupWindowRuntimeScoreLabel.text = String(currentlySelectedData.runtimeScore)
        PopupWindowModuleScoreLabel.text = String(currentlySelectedData.moduleScore)
        PopupWindowView.frame = CGRect(x: self.view.bounds.width / 2 - 138, y: 200, width: 276, height: 211)
        PopupWindowView.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.PopupWindowView.alpha = 1
        }
        self.view.addSubview(PopupWindowView)
    }
    
    @IBAction func popupWindowStartLevelPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "LevelSelected", sender: currentlySelectedData.sender)
    }
    
    @IBAction func popupWindowClosePressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            self.PopupWindowView.alpha = 0
        }) { (true) in
            self.PopupWindowView.removeFromSuperview()
        }
    }
    
    
    func updateLevelData(_ sender: UIButton){
        switch (sender) {
            //Also do this programmatically. Not sure how yet, but it can be done
        case Level1Button:
            currentlySelectedData.world = 1
            currentlySelectedData.level = 1
        case Level2Button:
            currentlySelectedData.world = 1
            currentlySelectedData.level = 2
        default:
            currentlySelectedData.world = 1
            currentlySelectedData.level = 1
        }
        currentlySelectedData.sender = sender
        let levelReader = LevelFileReader()
        let levelData = levelReader.getLevelSelectData(world: currentlySelectedData.world, level: currentlySelectedData.level)
        currentlySelectedData.name = levelData.name
        currentlySelectedData.runtimeScore = levelData.runtimeScore
        currentlySelectedData.moduleScore = levelData.moduleScore
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            switch (id) {
            case "LevelSelected":
                let dvc = segue.destination as! LevelViewController

                dvc.level = currentlySelectedData.level
                dvc.world = currentlySelectedData.world
            default: break
            }
        }
    }
 
}
