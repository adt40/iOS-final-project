//
//  Animations.swift
//  iOS-Final-Project
//
//  Created by Aaron Magid on 4/30/18.
//  Copyright © 2018 Austin Toot. All rights reserved.
//

import Foundation
import SpriteKit

class Animation {
    var speed: Double = 1
    var tileSize: CGFloat = 100
    
    func setTileSize(size: CGFloat) {
        tileSize = size
    }
    
    func setSpeed(speed: Double) {
        self.speed = speed
    }
    
    func move(direction: Direction) {
        return SKAction.moveBy(x: tileSize * direction.toVector().x, y: tileSize * direction.toVector().y, duration: speed)
    }
    
    func rotate(clockwise: Bool) {
        if (clockwise) {
            return SKAction.rotate(byAngle: -Mathf.pi / 2, duration: speed)
        } else {
            return SKAction.rotate(byAngle: Mathf.pi / 2, duration: speed)
        }
    }
}
