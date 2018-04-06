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
    
    var currentlySelectedData : (world: Int, level: Int, name: String) = (world: 0, level: 0, name: "")
    
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
        //performSegue(withIdentifier: "LevelSelected", sender: sender)
        let popup = (storyboard?.instantiateViewController(withIdentifier: "LevelPopup"))! as! LevelSelectPopupViewController
        updateLevelData(sender)
        popup.world = currentlySelectedData.world
        popup.level = currentlySelectedData.level
        popup.levelName = currentlySelectedData.name
        popup.modalTransitionStyle = .crossDissolve
        present(popup, animated: true, completion: nil)
    }

    func updateLevelData(_ sender: UIButton){
        switch (sender) {
            
            //Also do this programmatically. Not sure how yet, but it can be done
            
        case Level1Button:
            currentlySelectedData.world = 1
            currentlySelectedData.level = 1
            currentlySelectedData.name = "uhh"
        case Level2Button:
            currentlySelectedData.world = 1
            currentlySelectedData.level = 2
            currentlySelectedData.name = "hmm"
        default:
            currentlySelectedData.world = 1
            currentlySelectedData.level = 1
            currentlySelectedData.name = "lol"
        }
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
