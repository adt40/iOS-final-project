//
//  LevelViewController.swift
//  iOS-Final-Project
//
//  Created by Austin Toot on 3/25/18.
//  Copyright © 2018 Austin Toot. All rights reserved.
//

import UIKit
import SpriteKit
import Foundation

class LevelViewController: UIViewController {
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var stepButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet var settingsPopupView: UIView!
    @IBOutlet weak var popupSpeedSlider: UISlider!
    @IBOutlet weak var popupCloseButton: UIButton!
    
    @IBOutlet var winPopupView: UIView!
    @IBOutlet weak var runtimeScoreLabel: UILabel!
    @IBOutlet weak var moduleScoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var runtimeHighScoreLabel: UILabel!
    @IBOutlet weak var moduleHighScoreLabel: UILabel!
    
    @IBOutlet weak var levelNavItem: UINavigationItem!
    
    @IBOutlet weak var BoardView: SKView!
    
    var world : Int!
    var level : Int!
    var levelData : (name: String, gridSize: Vector, availableModules: [String], gridObjects: [GridObject])!
    
    var background : UIVisualEffectView?
    
    var playing = false
    var speed = Double(2)
    var win = false
    var boardScene: BoardScene?
    var runTimer = Timer()
    
    //increment these to keep track of score
    var totalIterations = 0
    var modulesUsed = 0
    
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
        initScene()
        
        //Render the grid
        boardScene!.renderGrid(gridSize: levelData.gridSize)
        
        //Render all initial modules
        boardScene!.renderInitialModules(gridObjects: levelData.gridObjects)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        playing = false
        speed = 2
        win = false
        if runTimer.isValid {
            runTimer.invalidate()
        }
        runTimer = Timer()
        totalIterations = 0
        modulesUsed = 0
    }
    
    //-----------------------------------------------------------------------------
    
    func reloadGrid() {
        Grid.initialize(size: levelData.gridSize)
        for gridObject in levelData.gridObjects {
            Grid.addGridObject(gridObject: gridObject)
        }
    }
    
    @objc func run() {
        totalIterations += 1
        win = Grid.advanceState()
        
        for gridObject in Grid.getState() {
            gridObject.uiSprite!.run(SKAction.move(to: CGPoint(x: CGFloat(gridObject.position.x) * boardScene!.tileSize + boardScene!.bufferWidth + boardScene!.tileSize / 2, y: boardScene!.size.height - CGFloat(gridObject.position.y) * boardScene!.tileSize - boardScene!.tileSize / 2), duration: getSpeed()))
            gridObject.uiSprite!.run(SKAction.rotate(toAngle: gridObject.facingDirection.toRadians(), duration: getSpeed(), shortestUnitArc: true))
            
            if (gridObject is Piston) {
                if (gridObject as! Piston).extended {
                    gridObject.uiSprite!.children[0].run(SKAction.sequence([SKAction.moveTo(y: boardScene!.moduleSize * 0.8, duration: getSpeed() * 0.4), SKAction.moveTo(y: 0, duration: getSpeed() * 0.6)]))
                }
            } else if (gridObject is TriggerPad) {
                //TODO: Change to triggerWillBeActive once that's implemented
                if (gridObject as! TriggerPad).triggerActive {
                    (gridObject.uiSprite! as! SKSpriteNode).texture = SKTexture(imageNamed: "module-triggerpad-active")
                } else {
                    (gridObject.uiSprite! as! SKSpriteNode).texture = SKTexture(imageNamed: "module-triggerpad-inactive")
                }
            }
        }
        
        if (win && playing) {
            //If we won, we actually need to render one more time
            self.playing = false
            gameWon()
        } else if (!playing && runTimer.isValid) {
            runTimer.invalidate()
        }
    }
    
    func gameWon() {
        runtimeScoreLabel.text = String(totalIterations)
        moduleScoreLabel.text = String(modulesUsed)
        
        let levelReader = LevelFileReader()
        
        let updated = levelReader.updateScore(world: world, level: level, runtimeScore: totalIterations, moduleScore: modulesUsed)
        if updated {
            highScoreLabel.isHidden = false
        } else {
            highScoreLabel.isHidden = true
        }
        
        let newHighScores = levelReader.getLevelSelectData(world: world, level: level)
        runtimeHighScoreLabel.text = String(newHighScores.runtimeScore)
        moduleHighScoreLabel.text = String(newHighScores.moduleScore)
        
        
        winPopupView.frame = CGRect(x: self.view.bounds.width / 2 - 138, y: 200, width: 276, height: 211)
        winPopupView.alpha = 0
        
        background = UIVisualEffectView(frame: self.view.frame)
        background!.effect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        background!.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.winPopupView.alpha = 1
            self.background!.alpha = 1
        }
        self.view.addSubview(background!)
        self.view.addSubview(winPopupView)
    }
    
    //-------------------------------------GRAPHICS--------------------------------
    
    //Initialize the BoardScene to display sprites
    func initScene() {
        //If we still have a previous boardScene
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
    
    func getSpeed() -> Double {
        return 1 / pow(speed, 1.5)
    }
    
    //-----------------------------------------------------------------------------
    
    @IBAction func playPausePressed(_ sender: UIButton) {
        if (!playing) {
            playPauseButton.setTitle("Pause", for: .normal)
            stopButton.isEnabled = true
            playing = true
            runTimer = Timer.scheduledTimer(timeInterval: getSpeed(), target: self, selector: #selector(self.run), userInfo: nil, repeats: true)
        } else {
            playPauseButton.setTitle("Play", for: .normal)
            playing = false
        }
    }
    
    @IBAction func stepPressed(_ sender: UIButton) {
        stopButton.isEnabled = true
        //Only render one step
        run()
    }
    
    @IBAction func stopPressed(_ sender: UIButton) {
        playPauseButton.setTitle("Play", for: .normal)
        stopButton.isEnabled = false
        playing = false
        totalIterations = 0
        reloadGrid()
    }
    
    //-----------------------------------------------------------------------------
    
    @IBAction func levelSelectPressed(_ sender: UIButton) {
        winPopupView.removeFromSuperview()
        background!.removeFromSuperview()
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func settingsPressed(_ sender: UIBarButtonItem) {
        settingsPopupView.frame = CGRect(x: self.view.bounds.width / 2 - 120, y: 200, width: 240, height: 128)
        settingsPopupView.alpha = 0
        
        background = UIVisualEffectView(frame: self.view.frame)
        background!.effect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        background!.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.settingsPopupView.alpha = 1
            self.background!.alpha = 1
        }
        self.view.addSubview(background!)
        self.view.addSubview(settingsPopupView)
    }
    
    @IBAction func popupCloseButtonPressed(_ sender: UIButton) {
        speed = Double(popupSpeedSlider.value)
        UIView.animate(withDuration: 0.5, animations: {
            self.settingsPopupView.alpha = 0
            self.background!.alpha = 0
        }) { (true) in
            self.background!.removeFromSuperview()
            self.settingsPopupView.removeFromSuperview()
        }
    }
}
