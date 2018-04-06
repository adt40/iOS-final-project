//
//  LevelSelectPopupViewController.swift
//  iOS-Final-Project
//
//  Created by Austin Toot on 4/5/18.
//  Copyright © 2018 Austin Toot. All rights reserved.
//

import UIKit

class LevelSelectPopupViewController: UIViewController {

    @IBOutlet weak var levelNameLabel: UILabel!
    var levelName : String!
    var world : Int!
    var level : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        levelNameLabel.text = String(world) + "-" + String(level) + ": " + levelName
        // Do any additional setup after loading the view.
    }

    
    @IBAction func startLevelPressed(_ sender: UIButton) {
        //let vc = self.presentingViewController! as! LevelSelectViewController
        //print(vc.currentlySelectedData)
        //vc.performSegue(withIdentifier: "LevelSelected", sender: sender)
        
        //AHHHHHH
        //Why is presentingViewController a UINavigationController?!?!
    }
    
    
    @IBAction func closePressed(_ sender: UIButton) {
        dismiss(animated: true)
    }

}
