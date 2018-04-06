//
//  LevelViewController.swift
//  iOS-Final-Project
//
//  Created by Austin Toot on 3/25/18.
//  Copyright © 2018 Austin Toot. All rights reserved.
//

import UIKit

class LevelViewController: UIViewController {
    
    @IBOutlet weak var levelNavItem: UINavigationItem!
    var world : Int!
    var level : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let levelReader = LevelFileReader()
        let levelData = levelReader.loadLevel(world: world, level: level)
        //levelData should have all the info needed to initialize things
        
        //Set title of the level
        let levelTitle = String(world) + "-" + String(level) + ": " + levelData.name
        levelNavItem.title = levelTitle
        
        
        //Initialize and fill the grid
        Grid.initialize(size: levelData.gridSize)
        for gridObject in levelData.gridObjects {
            Grid.addGridObject(gridObject: gridObject)
        }
    }
    
    
    func run(maxIterations: Int) -> Bool {
        var isWin = false
        var iterator = 0
        
        while !isWin && iterator < maxIterations {
            isWin = Grid.advanceState()
            iterator += 1
        }
        return isWin
    }
    
}
