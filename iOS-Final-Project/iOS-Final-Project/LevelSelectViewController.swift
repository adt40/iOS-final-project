//
//  LevelSelectViewController.swift
//  iOS-Final-Project
//
//  Created by Austin Toot on 3/25/18.
//  Copyright © 2018 Austin Toot. All rights reserved.
//

import UIKit

class LevelSelectViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var NavBar: UINavigationItem!
    @IBOutlet weak var PopupWindowStartLevelButton: UIButton!
    @IBOutlet weak var PopupWindowCloseButton: UIButton!
    @IBOutlet weak var PopupWindowLabel: UILabel!
    @IBOutlet weak var PopupWindowRuntimeScoreLabel: UILabel!
    @IBOutlet weak var PopupWindowModuleScoreLabel: UILabel!
    @IBOutlet weak var leftArrowButton: UIButton!
    @IBOutlet weak var rightArrowButton: UIButton!
    
    @IBOutlet var PopupWindowView: UIView!
    
    var currentlySelectedData : (world: Int, level: Int, name: String, runtimeScore: Int, moduleScore: Int) = (world: 0, level: 0, name: "", runtimeScore: 0, moduleScore: 0)
    var levels = [Int]()
    var currentWorld = 1
    var maxWorld = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let levelReader = LevelFileReader()
        levels = levelReader.getLevelCounts()
        maxWorld = levels.count
        updateArrayButtonStatus()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levels[currentWorld - 1]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! LevelSelectCollectionViewCell
        
        cell.label.text = String(currentWorld) + "-" + String(indexPath.item + 1)
        cell.label.backgroundColor = UIColor.init(red: 0.388, green: 0.604, blue: 0.867, alpha: 1)
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        startLevelPressed(index: indexPath.item + 1)
    }
    
    func startLevelPressed(index: Int) {
        updateLevelData(index: index)
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
        performSegue(withIdentifier: "LevelSelected", sender: self) //sender might cause problems
    }
    
    @IBAction func popupWindowClosePressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            self.PopupWindowView.alpha = 0
        }) { (true) in
            self.PopupWindowView.removeFromSuperview()
        }
    }
    
    func updateLevelData(index: Int){

        currentlySelectedData.world = currentWorld
        currentlySelectedData.level = index
        
        let levelReader = LevelFileReader()
        let levelData = levelReader.getLevelSelectData(world: currentlySelectedData.world, level: currentlySelectedData.level)
        currentlySelectedData.name = levelData.name
        currentlySelectedData.runtimeScore = levelData.runtimeScore
        currentlySelectedData.moduleScore = levelData.moduleScore
    }
    
    func updateArrayButtonStatus() {
        if currentWorld == 1 {
            leftArrowButton.isHidden = true
        } else {
            leftArrowButton.isHidden = false
        }
        
        if currentWorld == maxWorld {
            rightArrowButton.isHidden = true
        } else {
            rightArrowButton.isHidden = false
        }
        
        NavBar.title = "World " + String(currentWorld)
    }
    
    func reloadCollectionView() {
        guard let collectionView = self.view.viewWithTag(1) as? UICollectionView else {
            fatalError("no collection subview")
        }
        collectionView.reloadData()
    }
    
    @IBAction func rightArrowButtonPressed(_ sender: UIButton) {
        currentWorld += 1
        updateArrayButtonStatus()
        reloadCollectionView()
    }
    
    @IBAction func leftArrowButtonPressed(_ sender: UIButton) {
        currentWorld -= 1
        updateArrayButtonStatus()
        reloadCollectionView()
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
