//
//  BoardScene.swift
//  iOS-Final-Project
//
//  Created by Aaron Magid on 4/18/18.
//  Copyright © 2018 Austin Toot. All rights reserved.
//

import UIKit
import SpriteKit

class BoardScene: SKScene {

    
    //Only needs to be called once (renders actual grid lines)
    func renderGrid(gridSize: Vector) {
        var gridRoot = SKNode()
        gridRoot.position = CGPoint(x: 0, y: 0)
        addChild(gridRoot)
//        for x in 0..<gridSize.x {
//            for y in 0..<gridSize.y {
//
//            }
//        }
        var testTile = SKSpriteNode(imageNamed: "tile-corner-gray.png")
        testTile.position = CGPoint(x: testTile.size.width / 2, y: size.height - testTile.size.height / 2)
        gridRoot.addChild(testTile)
    }
    
    //Only needs to be called once (renders all modules)
    func renderInitialModules() {
        
    }
}
