//
//  LevelViewController.swift
//  iOS-Final-Project
//
//  Created by Austin Toot on 3/25/18.
//  Copyright © 2018 Austin Toot. All rights reserved.
//

import UIKit
import SpriteKit

class LevelViewController: UIViewController {
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var stepButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet var settingsPopupView: UIView!
    @IBOutlet weak var popupSpeedSlider: UISlider!
    @IBOutlet weak var popupCloseButton: UIButton!
    
    @IBOutlet weak var levelNavItem: UINavigationItem!
    
    @IBOutlet weak var BoardView: SKView!
    
    var world : Int!
    var level : Int!
    var levelData : (name: String, gridSize: Vector, availableModules: [String], gridObjects: [GridObject])!
    
    var playing = false
    
    var speed = 0.5
    
    var win = false
    
    var boardScene: BoardScene?
    
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
        
        //Instantiate the board scene
        initScene();
        
        //Render the grid
        boardScene!.renderGrid(gridSize: levelData.gridSize);
        
        //Render all initial modules
        boardScene!.renderInitialModules(gridObjects: levelData.gridObjects);
    }
    
    //-----------------------------------------------------------------------------
    
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
    
    //-------------------------------------GRAPHICS--------------------------------
    
    //Initialize the BoardScene to display sprites
    func initScene() {
        boardScene = BoardScene(size: BoardView.bounds.size)
        //Allow us to monitor FPS to keep an eye on performance
        BoardView.showsFPS = true
      //Keey an eye on number of nodes to ensure it everything is generated properly
        BoardView.showsNodeCount = true
       //I think this means things can be rendered in whatever order we want, not sure though. Will check.
        BoardView.ignoresSiblingOrder = true
        boardScene!.scaleMode = .resizeFill
       //Present the scene!
        BoardView.presentScene(boardScene)
    }
    
    //-----------------------------------------------------------------------------
    
    @IBAction func playPausePressed(_ sender: UIButton) {
        if (!playing) {
            playPauseButton.setTitle("Pause", for: .normal)
            stopButton.isEnabled = true
            win = run(maxIterations: 20)
            playing = true
        } else {
            playPauseButton.setTitle("Play", for: .normal)
            playing = false
        }
    }
    
    @IBAction func stepPressed(_ sender: UIButton) {
        stopButton.isEnabled = true
        win = Grid.advanceState()
    }
    
    @IBAction func stopPressed(_ sender: UIButton) {
        playPauseButton.setTitle("Play", for: .normal)
        stopButton.isEnabled = false
        playing = false
        reloadGrid()
    }
    
    //-----------------------------------------------------------------------------
    
    @IBAction func settingsPressed(_ sender: UIBarButtonItem) {
        settingsPopupView.frame = CGRect(x: self.view.bounds.width / 2 - 120, y: 200, width: 240, height: 128)
        settingsPopupView.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.settingsPopupView.alpha = 1
        }
        self.view.addSubview(settingsPopupView)
    }
    
    @IBAction func popupCloseButtonPressed(_ sender: UIButton) {
        speed = Double(popupSpeedSlider.value)
        UIView.animate(withDuration: 0.5, animations: {
            self.settingsPopupView.alpha = 0
        }) { (true) in
            self.settingsPopupView.removeFromSuperview()
        }
    }
}
