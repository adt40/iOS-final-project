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
        Grid.initialize(size: Vector(5, 5))
        
        //Bouncing a piston from left to right
        
        let pistonLeft = Piston(position: Vector(0, 2))
        pistonLeft.facingDirection = Vector(1, 0)
        
        let pistonRight = Piston(position: Vector(4, 2))
        pistonRight.facingDirection = Vector(-1, 0)
        
        let triggerLeft = TriggerPad(position: Vector(1, 2), onEnter: true, startAt: 0, repeatAt: 0)
        
        let triggerRight = TriggerPad(position: Vector(3, 2), onEnter: true, startAt: 0, repeatAt: 0)
        
        let movingPiston = Piston(position: Vector(1, 2))
        
        Grid.addGridObject(gridObject: pistonLeft)
        Grid.addGridObject(gridObject: pistonRight)
        Grid.addGridObject(gridObject: triggerLeft)
        Grid.addGridObject(gridObject: triggerRight)
        Grid.addGridObject(gridObject: movingPiston)
        
        for _ in 0..<10 {
            Grid.advanceState()
            for gridObject in Grid.getState() {
                print(gridObject.position)
            }
            print()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

