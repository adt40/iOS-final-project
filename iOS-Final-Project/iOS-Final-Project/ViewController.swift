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
        
        //level setup
        Grid.initialize(size: Vector(4, 4))
        let gridColorRed = GridColor(position: Vector(2, 2), color: MixableColor(1, 0, 0))
        let gridColorBlue = GridColor(position: Vector(1, 2), color: MixableColor(0, 0, 1))
        let gridSocket = GridColorSocket(position: Vector(3, 0), desiredColor: MixableColor(1, 0, 1))
        
        //player additions
        let piston1 = Piston(position: Vector(0, 2))
        piston1.facingDirection = Direction.right
        let piston2 = Piston(position: Vector(3, 3))
        piston2.facingDirection = Direction.up
        let triggerPad1 = TriggerPad(position: Vector(0, 3))
        triggerPad1.setTriggerParameters(triggerOnEnter: false, triggerOnTimeStart: 0, triggerOnTimeRepeat: 0)
        let triggerPad2 = TriggerPad(position: Vector(3, 2))
        triggerPad2.setTriggerParameters(triggerOnEnter: true, triggerOnTimeStart: 0, triggerOnTimeRepeat: 0)
        
        //add objects to grid
        Grid.addGridObject(gridObject: gridColorRed)
        Grid.addGridObject(gridObject: gridColorBlue)
        Grid.addGridObject(gridObject: gridSocket)
        Grid.addGridObject(gridObject: piston1)
        Grid.addGridObject(gridObject: piston2)
        Grid.addGridObject(gridObject: triggerPad1)
        Grid.addGridObject(gridObject: triggerPad2)
        
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

