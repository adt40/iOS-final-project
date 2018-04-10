//
//  LevelViewController.swift
//  iOS-Final-Project
//
//  Created by Austin Toot on 3/25/18.
//  Copyright © 2018 Austin Toot. All rights reserved.
//

import UIKit

class LevelViewController: UIViewController {
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var stepButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var levelNavItem: UINavigationItem!
    var world : Int!
    var level : Int!
    var levelData : (name: String, gridSize: Vector, availableModules: [String], gridObjects: [GridObject])!
    
    var playing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let levelReader = LevelFileReader()
        levelData = levelReader.loadLevel(world: world, level: level)
        //levelData should have all the info needed to initialize things
        
        //Set title of the level
        let levelTitle = String(world) + "-" + String(level) + ": " + levelData.name
        levelNavItem.title = levelTitle
        
        //Initialize and fill the grid
        reloadGrid()
    }
    
    func reloadGrid() {
        Grid.initialize(size: levelData.gridSize)
        for gridObject in levelData.gridObjects {
            Grid.addGridObject(gridObject: gridObject)
        }
    }
    
    func run(maxIterations: Int) -> Bool {
        var isWin = false
        var iterator = 0
        //can rework this stuff depending on how we wait for each advanceState call
        while !isWin && iterator < maxIterations && playing {
            isWin = Grid.advanceState()
            iterator += 1
        }
        return isWin
    }
    
    @IBAction func playPausePressed(_ sender: UIButton) {
        if (!playing) {
            playPauseButton.setTitle("Pause", for: .normal)
            stopButton.isEnabled = true
            run(maxIterations: 20)
            playing = true
        } else {
            playPauseButton.setTitle("Play", for: .normal)
            playing = false
        }
    }
    
    @IBAction func stepPressed(_ sender: UIButton) {
        stopButton.isEnabled = true
        Grid.advanceState()
    }
    
    @IBAction func stopPressed(_ sender: UIButton) {
        playPauseButton.setTitle("Play", for: .normal)
        stopButton.isEnabled = false
        playing = false
        reloadGrid()
    }
    
}
