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
    static var speed: Double = 1
    static var tileSize: CGFloat = 100
    
    static func setTileSize(size: CGFloat) {
        tileSize = size
    }
    
    static func setSpeed(speed: Double) {
        self.speed = speed
    }
    
    static func move(direction: Direction) -> SKAction {
        return SKAction.moveBy(x: tileSize * CGFloat(direction.toVector().x), y: -tileSize * CGFloat(direction.toVector().y), duration: speed)
    }
    
    static func rotate(clockwise: Bool) -> SKAction {
        if (clockwise) {
            return SKAction.rotate(byAngle: -CGFloat.pi / 2, duration: speed)
        } else {
            return SKAction.rotate(byAngle: CGFloat.pi / 2, duration: speed)
        }
    }
}
