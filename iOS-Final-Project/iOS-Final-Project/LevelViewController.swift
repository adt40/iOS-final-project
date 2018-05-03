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
    
    @IBOutlet var moduleOptionsView: UIView!
    
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
    
    var selectedGridObject : GridObject?
    
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
        
        reloadGrid()
        initScene()
        boardScene!.renderGrid(gridSize: levelData.gridSize)
        boardScene!.renderInitialModules(gridObjects: levelData.gridObjects)
        boardScene!.renderModuleBank(availableModules: levelData.availableModules)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
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
            gridObject.uiSprite!.run(SKAction.move(to: CGPoint(x: CGFloat(gridObject.position.x) * boardScene!.tileSize + boardScene!.bufferWidth + boardScene!.tileSize / 2, y: boardScene!.boardSpace!.height - CGFloat(gridObject.position.y) * boardScene!.tileSize - boardScene!.tileSize / 2), duration: getSpeed()))
            gridObject.uiSprite!.run(SKAction.rotate(toAngle: gridObject.facingDirection.toRadians(), duration: getSpeed(), shortestUnitArc: true))
            
            if (gridObject is Piston) {
                if (gridObject as! Piston).extended {
                    gridObject.uiSprite!.children[0].run(SKAction.sequence([SKAction.moveTo(y: boardScene!.moduleSize * 0.8, duration: getSpeed() * 0.4), SKAction.moveTo(y: 0, duration: getSpeed() * 0.6)]))
                }
            } else if (gridObject is TriggerPad) {
                if (gridObject as! TriggerPad).triggerActive || (gridObject as! TriggerPad).willTriggerNextTick {
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
        boardScene = BoardScene(size: BoardView.bounds.size)
        BoardView.showsFPS = true
        BoardView.showsNodeCount = true
        BoardView.ignoresSiblingOrder = true
        boardScene!.scaleMode = .resizeFill
        boardScene!.superView = self //so boardScene has access to this scenes stuff (maybe)
        BoardView.presentScene(boardScene)
    }
    
    func getSpeed() -> Double {
        return 1 / pow(speed, 1.5)
    }
    
    //------------------------------------------------------------------------------
    //Module Options Menu
    
    func displayOptionsFor(gridObject: GridObject) {
        selectedGridObject = gridObject
        
        for subview in moduleOptionsView.subviews {
            subview.removeFromSuperview()
        }
        
        let height = 25
        let viewWidth = Int(moduleOptionsView.frame.width)
        let viewHeight = Int(moduleOptionsView.frame.height)
        let optionLabelSize: CGFloat = 14
        let optionSize: CGFloat = 15
        
        //things on every module
        let titleLabel = UILabel(frame: CGRect(x: 40, y: 10, width: viewWidth - 80, height: 18))
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textAlignment = NSTextAlignment.center
        moduleOptionsView.addSubview(titleLabel)
        
        let deleteButton = UIButton(frame: CGRect(x: viewWidth - 80, y: 0, width: 80, height: height))
        deleteButton.setTitle("delete", for: .normal)
        deleteButton.setTitleColor(.black, for: .normal)
        //TODO: Give this an action
        moduleOptionsView.addSubview(deleteButton)
        
        //things on specific modules
        if gridObject is Piston {
            titleLabel.text = "Piston"
            
            generateRotationControls(size: height)
            
        } else if gridObject is Rotator {
            titleLabel.text = "Rotator"
            
            generateRotationControls(size: height)
            
            let clockwiseButton = UIButton(frame: CGRect(x: viewWidth / 2, y: height, width: height, height: height))
            let counterclockwiseButton = UIButton(frame: CGRect(x: viewWidth / 2, y: height * 2, width: height, height: height))
            clockwiseButton.setTitle("↻", for: .normal)
            counterclockwiseButton.setTitle("↺", for: .normal)
            clockwiseButton.setTitleColor(.black, for: .normal)
            counterclockwiseButton.setTitleColor(.black, for: .normal)
            clockwiseButton.target(forAction: #selector(clockwisePressed), withSender: clockwiseButton)
            counterclockwiseButton.target(forAction: #selector(counterclockwisePressed), withSender: counterclockwiseButton)
            moduleOptionsView.addSubview(clockwiseButton)
            moduleOptionsView.addSubview(counterclockwiseButton)
            
        } else if gridObject is ColorZapper {
            titleLabel.text = "Color Zapper"
            
            generateRotationControls(size: height)
            
            let redButton = UIButton(frame: CGRect(x: viewWidth / 2, y: height, width: height, height: height))
            let yellowButton = UIButton(frame: CGRect(x: viewWidth / 2, y: height * 2, width: height, height: height))
            let blueButton = UIButton(frame: CGRect(x: viewWidth / 2, y: height * 3, width: height, height: height))
            redButton.backgroundColor = .red
            yellowButton.backgroundColor = .yellow
            blueButton.backgroundColor = .blue
            redButton.target(forAction: #selector(redPressed), withSender: redButton)
            yellowButton.target(forAction: #selector(yellowPressed), withSender: yellowButton)
            blueButton.target(forAction: #selector(bluePressed), withSender: blueButton)
            moduleOptionsView.addSubview(redButton)
            moduleOptionsView.addSubview(yellowButton)
            moduleOptionsView.addSubview(blueButton)
            
        } else if gridObject is TriggerPad {
            titleLabel.text = "Trigger Pad"
            //Left side of controls
            let modeSwitchLabel = UILabel(frame: CGRect(x: viewWidth / 4 - 50, y: viewHeight - 65, width: 100, height: 15))
            let modeSwitch = UISegmentedControl(frame: CGRect(x: viewWidth / 4 - 65, y: viewHeight - 45, width: 130, height: 25))
            modeSwitch.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: optionSize)],
                                                                                      for: .normal)
            modeSwitchLabel.text = "Trigger Mode"
            modeSwitchLabel.font = UIFont(descriptor: modeSwitchLabel.font.fontDescriptor, size: optionLabelSize)
            modeSwitchLabel.textAlignment = NSTextAlignment.center
            modeSwitch.insertSegment(withTitle: "Press", at: 0, animated: true)
            modeSwitch.insertSegment(withTitle: "Timer", at: 1, animated: true)
            if (gridObject as! TriggerPad).triggerOnEnter {
                modeSwitch.selectedSegmentIndex = 0
            } else {
                modeSwitch.selectedSegmentIndex = 1
            }
            
            modeSwitch.addTarget(self, action: #selector(updateTriggerPadMode), for: UIControlEvents.valueChanged)

            moduleOptionsView.addSubview(modeSwitchLabel)
            moduleOptionsView.addSubview(modeSwitch)
            
            //Center divider
            let divider = UIView(frame: CGRect(x: viewWidth / 2, y: 40, width: 1, height: viewHeight - 60))
            divider.backgroundColor = UIColor.gray
            
            moduleOptionsView.addSubview(divider)
            
            //Right side of controls
            let startTimeLabel = UILabel(frame: CGRect(x: 3 * viewWidth / 4 - 60, y: viewHeight - 76, width: 120, height: 15))
            startTimeLabel.text = "Auto Activate After:"
            startTimeLabel.font = UIFont(descriptor: modeSwitchLabel.font.fontDescriptor, size: optionLabelSize - 3)
            startTimeLabel.textAlignment = NSTextAlignment.center
            let startTimeField = UILabel(frame: CGRect(x: 3 * viewWidth / 4 - 70, y: viewHeight - 64, width: 60, height: 20))
            startTimeField.font = UIFont(descriptor: modeSwitchLabel.font.fontDescriptor, size: optionSize - 3)
            startTimeField.textAlignment = NSTextAlignment.center
            startTimeField.text = "\((gridObject as! TriggerPad).triggerOnTimeStart) Step\((gridObject as! TriggerPad).triggerOnTimeStart == 1 ? "" : "s")"
            startTimeField.tag = 10
            let startTimeControl = UISegmentedControl(frame: CGRect(x: 3 * viewWidth / 4 - 10 , y: viewHeight - 62, width: 80, height: 16))
            startTimeControl.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: optionSize)],
                                              for: .normal)
            startTimeControl.insertSegment(withTitle: "-", at: 0, animated: true)
            startTimeControl.insertSegment(withTitle: "+", at: 1, animated: true)
            
            startTimeControl.addTarget(self, action: #selector(updateTriggerPadStartTime), for: UIControlEvents.valueChanged)
            
            moduleOptionsView.addSubview(startTimeLabel)
            moduleOptionsView.addSubview(startTimeField)
            moduleOptionsView.addSubview(startTimeControl)
            
            let repeatTimeLabel = UILabel(frame: CGRect(x: 3 * viewWidth / 4 - 60, y: viewHeight - 40, width: 120, height: 15))
            repeatTimeLabel.text = "Reactivate Every:"
            repeatTimeLabel.font = UIFont(descriptor: modeSwitchLabel.font.fontDescriptor, size: optionLabelSize - 3)
            repeatTimeLabel.textAlignment = NSTextAlignment.center
            let repeatTimeField = UILabel(frame: CGRect(x: 3 * viewWidth / 4 - 70, y: viewHeight - 28, width: 60, height: 20))
            repeatTimeField.font = UIFont(descriptor: modeSwitchLabel.font.fontDescriptor, size: optionSize - 3)
            repeatTimeField.textAlignment = NSTextAlignment.center
            repeatTimeField.text = (gridObject as! TriggerPad).triggerOnTimeRepeat == 0 ? "Never" : "\((gridObject as! TriggerPad).triggerOnTimeRepeat) Step\((gridObject as! TriggerPad).triggerOnTimeRepeat == 1 ? "" : "s")"
            repeatTimeField.tag = 20
            let repeatTimeControl = UISegmentedControl(frame: CGRect(x: 3 * viewWidth / 4 - 10 , y: viewHeight - 26, width: 80, height: 16))
            repeatTimeControl.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: optionSize)],
                                                    for: .normal)
            repeatTimeControl.insertSegment(withTitle: "-", at: 0, animated: true)
            repeatTimeControl.insertSegment(withTitle: "+", at: 1, animated: true)
            
            repeatTimeControl.addTarget(self, action: #selector(updateTriggerPadRepeatTime), for: UIControlEvents.valueChanged)
            
            moduleOptionsView.addSubview(repeatTimeLabel)
            moduleOptionsView.addSubview(repeatTimeField)
            moduleOptionsView.addSubview(repeatTimeControl)
        } else if gridObject is Wall {
            titleLabel.text = "Wall"
        } else {
            //Just in case so that the force unwrap below won't crash everything.
            titleLabel.text = ""
        }
        
        titleLabel.text = titleLabel.text! + " Settings"
        moduleOptionsView.isHidden = false
    }
    
    func generateRotationControls(size: Int) {
        let upButton = UIButton(frame: CGRect(x: size, y: size, width: size, height: size))
        let rightButton = UIButton(frame: CGRect(x: size * 2, y: size * 2, width: size, height: size))
        let downButton = UIButton(frame: CGRect(x: size, y: size * 3, width: size, height: size))
        let leftButton = UIButton(frame: CGRect(x: 0, y: size * 2, width: size, height: size))
        upButton.setTitle("▲", for: .normal)
        rightButton.setTitle("▶", for: .normal)
        downButton.setTitle("▼", for: .normal)
        leftButton.setTitle("◀", for: .normal)
        upButton.setTitleColor(.black, for: .normal)
        rightButton.setTitleColor(.black, for: .normal)
        downButton.setTitleColor(.black, for: .normal)
        leftButton.setTitleColor(.black, for: .normal)
        upButton.addTarget(self, action: #selector(upPressed), for: UIControlEvents.touchUpInside)
        rightButton.addTarget(self, action: #selector(rightPressed), for: UIControlEvents.touchUpInside)
        downButton.addTarget(self, action: #selector(downPressed), for: UIControlEvents.touchUpInside)
        leftButton.addTarget(self, action: #selector(leftPressed), for: UIControlEvents.touchUpInside)
        moduleOptionsView.addSubview(upButton)
        moduleOptionsView.addSubview(rightButton)
        moduleOptionsView.addSubview(downButton)
        moduleOptionsView.addSubview(leftButton)
    }
    
    @objc func upPressed(_ sender: UIButton) {
        selectedGridObject!.facingDirection = Direction.up
        selectedGridObject!.uiSprite!.run(SKAction.rotate(toAngle: selectedGridObject!.facingDirection.toRadians(), duration: 0.2, shortestUnitArc: true))
    }
    @objc func rightPressed(_ sender: UIButton) {
        selectedGridObject!.facingDirection = Direction.right
        selectedGridObject!.uiSprite!.run(SKAction.rotate(toAngle: selectedGridObject!.facingDirection.toRadians(), duration: 0.2, shortestUnitArc: true))
    }
    @objc func downPressed(_ sender: UIButton) {
        selectedGridObject!.facingDirection = Direction.down
        selectedGridObject!.uiSprite!.run(SKAction.rotate(toAngle: selectedGridObject!.facingDirection.toRadians(), duration: 0.2, shortestUnitArc: true))
    }
    @objc func leftPressed(_ sender: UIButton) {
        selectedGridObject!.facingDirection = Direction.left
        selectedGridObject!.uiSprite!.run(SKAction.rotate(toAngle: selectedGridObject!.facingDirection.toRadians(), duration: 0.2, shortestUnitArc: true))
    }
    @objc func clockwisePressed(_ sender: UIButton) {
        let rotator = selectedGridObject! as! Rotator
        rotator.clockwise = true
    }
    @objc func counterclockwisePressed(_ sender: UIButton) {
        let rotator = selectedGridObject! as! Rotator
        rotator.clockwise = false
    }
    @objc func redPressed(_ sender: UIButton) {
        let zapper = selectedGridObject! as! ColorZapper
        zapper.color = MixableColor(1, 0, 0)
    }
    @objc func yellowPressed(_ sender: UIButton) {
        let zapper = selectedGridObject! as! ColorZapper
        zapper.color = MixableColor(0, 1, 0)
    }
    @objc func bluePressed(_ sender: UIButton) {
        let zapper = selectedGridObject! as! ColorZapper
        zapper.color = MixableColor(0, 0, 1)
    }
    
    @objc func updateTriggerPadMode(segmentedControl: UISegmentedControl) {
        (selectedGridObject as! TriggerPad).triggerOnEnter = segmentedControl.selectedSegmentIndex == 0
    }
    
    @objc func updateTriggerPadStartTime(segmentedControl: UISegmentedControl) {
        (selectedGridObject as! TriggerPad).triggerOnTimeStart += segmentedControl.selectedSegmentIndex * 2 - 1
        if (selectedGridObject as! TriggerPad).triggerOnTimeStart < 0 {
            (selectedGridObject as! TriggerPad).triggerOnTimeStart = 0
        }
        for subview in segmentedControl.superview!.subviews {
            if subview.tag == 10 {
                (subview as! UILabel).text = "\((selectedGridObject as! TriggerPad).triggerOnTimeStart) Step\((selectedGridObject as! TriggerPad).triggerOnTimeStart == 1 ? "" : "s")"
            }
        }
        segmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
    }
    
    @objc func updateTriggerPadRepeatTime(segmentedControl: UISegmentedControl) {
        (selectedGridObject as! TriggerPad).triggerOnTimeRepeat += segmentedControl.selectedSegmentIndex * 2 - 1
        if (selectedGridObject as! TriggerPad).triggerOnTimeRepeat < 0 {
            (selectedGridObject as! TriggerPad).triggerOnTimeRepeat = 0
        }
        for subview in segmentedControl.superview!.subviews {
            if subview.tag == 20 {
                (subview as! UILabel).text = (selectedGridObject as! TriggerPad).triggerOnTimeRepeat == 0 ? "Never" : "\((selectedGridObject as! TriggerPad).triggerOnTimeRepeat) Step\((selectedGridObject as! TriggerPad).triggerOnTimeRepeat == 1 ? "" : "s")"
            }
        }
        segmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
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
