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
    
    init(position: Vector, direction: Direction, color: MixableColor) {
        self.color = color
        super.init(position: position, canMove: true, canEdit: true, hasHitbox: true, facingDirection: direction, currentVelocity: (speed: 0, direction: Direction.neutral))
    }
    
    override func performAction() {
        if let gridObject = Grid.getHittableGridObjectsAt(position: position + facingDirection.toVector()) {
            if let gridColor = gridObject as? GridColor {
                gridColor.addColor(color)
            }
        }
    }
}
