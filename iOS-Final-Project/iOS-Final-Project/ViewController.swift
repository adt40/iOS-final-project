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
        let piston = Piston(position: Vector(3, 3))
        piston.currentVelocity = (speed: 1, direction: Vector(1, 0))
        Grid.addGridObject(gridObject: piston)
        
        Grid.advanceState()
        print(Grid.getState()[0].position)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

