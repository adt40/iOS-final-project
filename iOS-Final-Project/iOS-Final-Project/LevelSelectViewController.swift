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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //connect this with any buttons created
    @IBAction func startLevelPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "LevelSelected", sender: sender)
    }

    
    
    
    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            switch (id) {
            case "LevelSelected":
                let dvc = segue.destination as! LevelViewController
                switch (sender as! UIButton) {
                
                //Also do this programmatically. Not sure how yet, but it can be done
                    
                case Level1Button:
                    dvc.world = 1
                    dvc.level = 1
                case Level2Button:
                    dvc.world = 1
                    dvc.level = 2
                default:
                    dvc.world = 1
                    dvc.level = 1
                }
            default: break
            }
        }
    }
}
