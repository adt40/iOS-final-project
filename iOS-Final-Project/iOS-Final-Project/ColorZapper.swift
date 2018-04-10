//
//  ColorZapper.swift
//  iOS-Final-Project
//
//  Created by Austin Toot on 4/10/18.
//  Copyright © 2018 Austin Toot. All rights reserved.
//

import Foundation

class ColorZapper : Module {
    
    var color : MixableColor
    
    init(position: Vector, color: MixableColor) {
        self.color = color
        super.init(position: position, canMove: true, hasHitbox: false, facingDirection: Direction.neutral, currentVelocity: (speed: 0, direction: Direction.neutral))
    }
    
    override func performAction() {
        if let gridObject = Grid.getHittableGridObjectsAt(position: position + facingDirection.toVector()) {
            if let gridColor = gridObject as? GridColor {
                gridColor.addColor(color)
            }
        }
    }
}
