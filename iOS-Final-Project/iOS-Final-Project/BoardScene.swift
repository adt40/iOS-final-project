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
        //Have to subtract 78 because of the 39 point blue glow on the edges on either side of grid
        print("Grid Width: \(gridSize.x)")
        print("Grid Height: \(gridSize.y)")
        let glowEffectSize = CGFloat(39)
        var tileSize = (size.width - glowEffectSize * 2) / CGFloat(gridSize.x)
        var gridRoot = SKNode()
        gridRoot.position = CGPoint(x: 0, y: 0)
        addChild(gridRoot)
        var filename: String
        var newSprite: SKSpriteNode
        var currentXpos = (glowEffectSize + tileSize) / 2
        var currentYpos = size.height - (glowEffectSize + tileSize) / 2
        var isCorner = true
        var isEdge = false
        var isCentral = false
        for y in 0..<gridSize.y {
            for x in 0..<gridSize.x {
                print("New Sprite!")
                print("Grid X: \(x)")
                print("Grid Y: \(y)")
                print("X Pos: \(currentXpos)")
                print("Y Pos: \(currentYpos)")
                //Initialize filename
                filename = "tile-"
                
                //Classify tile
                isCorner = x == 0 && y == 0 || x == gridSize.x - 1 && y == 0 || x == 0 && y == gridSize.y - 1 || x == gridSize.x - 1 && y == gridSize.y - 1
                isEdge = x == 0 || x == gridSize.x - 1 || y == 0 || y == gridSize.y - 1
                isCentral = !isCorner && !isEdge
                
                //Generate Filename
                //If it's a corner, add "corner-"
                if (isCorner) {
                    filename += "corner-"
                //If it's an edge, add "edge-"
                } else if (isEdge) {
                    filename += "edge-"
                //Otherwise, it's a central tile, so add "central-"
                } else {
                    filename += "central-"
                }
                
                //Decide on color. Fun fact: on a checkerboard, the manhattan distance determines color!
                if ((x + y) % 2 == 1) {
                    filename += "white"
                } else {
                    filename += "gray"
                }
                
                //Append file extension to filename
                filename += ".png"
                
                //Instantiate tile sprite
                newSprite = SKSpriteNode(imageNamed: filename)
                //Set its position
                newSprite.position = CGPoint(x: currentXpos, y: currentYpos)
                
                //Set its size
                if (isCorner) {
                    newSprite.size = CGSize(width: glowEffectSize + tileSize, height: glowEffectSize + tileSize)
                } else if (isEdge) {
                    newSprite.size = CGSize(width: tileSize, height: glowEffectSize + tileSize)
                } else {
                    newSprite.size = CGSize(width: tileSize, height: tileSize)
                }
                
                //Set its rotation (SpriteKit does rotations in radians, counterclockwise)
                //If its on the right edge, rotate by 3*pi/2 (270deg)
                if (x == gridSize.x - 1) {
                    newSprite.zRotation = 3 * CGFloat.pi / 2
                }
                //If its on the bottom edge, rotate by pi (180deg)
                if (y == gridSize.y - 1) {
                    newSprite.zRotation = CGFloat.pi
                }
                //If its on the left edge BUT IS NOT the top left corner, rotate by pi/2 (90deg)
                if (x == 0 && y != 0) {
                    newSprite.zRotation = CGFloat.pi / 2
                }
                
                //Figure out position of next tile
                //If this tile was the first in the row, add a little extra for the glow effect
                if (x == 0) {
                    currentXpos += (newSprite.size.width + tileSize) / 2
                //If this tile was not the first, add a standard tile size
                } else if (x < gridSize.x - 1) {
                    currentXpos += tileSize
                    //If this tile was the second-to-last in the row, add a little extra for the glow effect on the right
                    if (x == gridSize.x - 2) {
                        currentXpos += glowEffectSize / 2
                    }
                //If this was the last tile in the row, reset X and add to Y
                } else {
                    currentXpos = (glowEffectSize + tileSize) / 2
                    //If this was the first row, add a little extra for the glow effect
                    if (y == 0) {
                        currentYpos += (newSprite.size.height + tileSize) / 2
                    //If not, add a standard tile size
                    } else if (y < gridSize.y - 1) {
                        currentYpos += tileSize
                        //If this was the second-to-last row, add a little adjustment for the glow effect on the bottom
                        if (y == gridSize.y - 2) {
                            currentYpos += glowEffectSize / 2
                        }
                    }
                }
                gridRoot.addChild(newSprite)
            }
        }
        //var testTile = SKSpriteNode(imageNamed: "tile-corner-gray.png")
        //testTile.position = CGPoint(x: testTile.size.width / 2, y: size.height - testTile.size.height / 2)
        //gridRoot.addChild(testTile)
    }
    
    //Only needs to be called once (renders all modules)
    func renderInitialModules() {
        
    }
}
