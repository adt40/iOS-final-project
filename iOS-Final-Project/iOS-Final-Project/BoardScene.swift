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

    var bufferWidth = CGFloat(0)
    var tileSize = CGFloat(0)
    var moduleSize = CGFloat(0)
    var gridRoot: SKNode?
    var moduleRoot: SKNode?
    
    let GRID_LAYER = CGFloat(1)
    let MODULE_LAYER = CGFloat(10)
    
    //Only needs to be called once (renders actual grid lines)
    func renderGrid(gridSize: Vector) {
        //Have to subtract 78 because of the 39 point blue glow on the edges on either side of grid
        print("Grid Width: \(gridSize.x)")
        print("Grid Height: \(gridSize.y)")
        //var tileSize = (size.width - glowEffectSize * 2) / CGFloat(gridSize.x)
        
        //At first, assign tile size based on width
        tileSize = size.width / CGFloat(gridSize.x)
        bufferWidth = CGFloat(0)
        //If the tiles are going to overflow vertically, shrink them and add a buffer on the sides
        if (tileSize * CGFloat(gridSize.y) > size.height) {
            tileSize = size.height / CGFloat(gridSize.y)
            bufferWidth = (size.width - tileSize * CGFloat(gridSize.x)) / 2
        }
        moduleSize = tileSize - 4
        
        gridRoot = SKNode()
        gridRoot!.zPosition = GRID_LAYER
        addChild(gridRoot!)
        var filename: String
        var newSprite: SKSpriteNode
        var currentXpos = tileSize / 2 + bufferWidth
        var currentYpos = size.height - tileSize / 2
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
                filename = "tile-central-"
                
                //Classify tile
                isCorner = x == 0 && y == 0 || x == gridSize.x - 1 && y == 0 || x == 0 && y == gridSize.y - 1 || x == gridSize.x - 1 && y == gridSize.y - 1
                isEdge = x == 0 || x == gridSize.x - 1 || y == 0 || y == gridSize.y - 1
                isCentral = !isCorner && !isEdge
                
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
                //Set its rendering layer
                newSprite.zPosition = GRID_LAYER
                
                //Set its size
                newSprite.size = CGSize(width: tileSize, height: tileSize)
                
                //Figure out position of next tile
                //If this tile was the first in the row, add a little extra for the glow effect
                if (x < gridSize.x - 1) {
                    currentXpos += tileSize
                //If this was the last tile in the row, reset X and add to Y
                } else {
                    currentXpos = tileSize / 2 + bufferWidth
                    currentYpos -= tileSize
                }
                gridRoot!.addChild(newSprite)
            }
        }
        //var testTile = SKSpriteNode(imageNamed: "tile-corner-gray.png")
        //testTile.position = CGPoint(x: testTile.size.width / 2, y: size.height - testTile.size.height / 2)
        //gridRoot.addChild(testTile)
    }
    
    //Only needs to be called once (renders all modules)
    func renderInitialModules(gridObjects: [GridObject]) {
        print("Rendering Modules")
        var newSprite: SKSpriteNode
        var filename: String
        moduleRoot = SKNode()
        moduleRoot!.zPosition = MODULE_LAYER
        addChild(moduleRoot!)
        
        for gridObject in gridObjects {
            print("Module!")
            print("X: \(gridObject.position.x)")
            print("Y: \(gridObject.position.y)")
            print("Direction: \(gridObject.facingDirection)")
            filename = "module-"
            //TEMP until we have icons for all modules (will be gridObject.type rather than "temp")
            filename += "temp"
            filename += ".png"
            
            newSprite = SKSpriteNode(imageNamed: filename)
            newSprite.position = CGPoint(x: bufferWidth + tileSize * CGFloat(gridObject.position.x) + moduleSize / 2 + (tileSize - moduleSize) / 2, y: size.height - tileSize * CGFloat(gridObject.position.y) - moduleSize / 2 - (tileSize - moduleSize) / 2)
            newSprite.zPosition = MODULE_LAYER
            newSprite.size = CGSize(width: moduleSize, height: moduleSize)
            
            if (gridObject.facingDirection == Direction.left) {
                newSprite.zRotation = CGFloat.pi / 2
            } else if (gridObject.facingDirection == Direction.down) {
                newSprite.zRotation = CGFloat.pi
            } else if (gridObject.facingDirection == Direction.right) {
                newSprite.zRotation = 3 * CGFloat.pi / 2
            }
            
            moduleRoot!.addChild(newSprite)
        }
    }
}
