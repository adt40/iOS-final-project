//
//  ViewController.swift
//  iOS-Final-Project
//
//  Created by Austin Toot on 2/22/18.
//  Copyright © 2018 Austin Toot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let levelReader = LevelFileReader()
        let level = levelReader.loadLevel(world: 1, level: 1)
        
        Grid.initialize(size: level.gridSize)
        
        for gridObject in level.gridObjects {
            Grid.addGridObject(gridObject: gridObject)
        }
        
        //setup simulation
        var isWin = false
        let maxIterations = 15
        var iterator = 0
        
        //run simulation
        while !isWin && iterator < maxIterations {
            isWin = Grid.advanceState()
            for gridObject in Grid.getState() {
                print(gridObject.position)
            }
            print(isWin)
            print()
            iterator += 1
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

