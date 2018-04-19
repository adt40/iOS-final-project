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
        var filename: String
        moduleRoot = SKNode()
        moduleRoot!.zPosition = MODULE_LAYER
        addChild(moduleRoot!)
        
        for gridObject in gridObjects {
            if let module = gridObject as? GridColor {
                let path = CGMutablePath()
                path.addArc(center: CGPoint.zero, radius: moduleSize / 4, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
                var newShape = SKShapeNode(path: path)
                newShape.lineWidth = 1
                var color = module.color.toRGB()
                newShape.fillColor = SKColor(red: CGFloat(color.r)/255, green: CGFloat(color.g)/255, blue: CGFloat(color.b)/255, alpha: 0.8)
                newShape.strokeColor = SKColor.white
                
                newShape.position = CGPoint(x: bufferWidth + tileSize * CGFloat(gridObject.position.x) + moduleSize / 2 + (tileSize - moduleSize) / 2, y: size.height - tileSize * CGFloat(gridObject.position.y) - moduleSize / 2 - (tileSize - moduleSize) / 2)
                newShape.zPosition = MODULE_LAYER + 1
                moduleRoot!.addChild(newShape)
            } else {
                //Select image file
                var type: String
                if let _ = gridObject as? Piston {
                    type = "piston"
                } else if let obj = gridObject as? TriggerPad {
                    type = "triggerpad-"
                    if (!obj.triggerActive) {
                        type += "in"
                    }
                    type += "active"
                } else if let _ = gridObject as? Rotator {
                    type = "rotator"
                } else {
                    type = "temp"
                }
                
                filename = "module-\(type).png"
                
                //Generate Sprite
                var newSprite = SKSpriteNode(imageNamed: filename)
                
                //Set Sprite position
                newSprite.position = CGPoint(x: bufferWidth + tileSize * CGFloat(gridObject.position.x) + moduleSize / 2 + (tileSize - moduleSize) / 2, y: size.height - tileSize * CGFloat(gridObject.position.y) - moduleSize / 2 - (tileSize - moduleSize) / 2)
                
                //Set sprite rendering order
                if (type == "triggerpad-active" || type == "triggerpad-inactive") {
                    newSprite.zPosition = MODULE_LAYER - 2
                } else {
                    newSprite.zPosition = MODULE_LAYER
                }
                
                //Account for minor differences in size between modules
                if (type == "rotator") {
                    //Rotator is bigger so that it stretches into adjacent tiles to make rotation ability more intuitive
                    newSprite.size = CGSize(width: moduleSize * 1.5, height: moduleSize * 1.5)
                } else {
                    newSprite.size = CGSize(width: moduleSize, height: moduleSize)
                }
            
                //Set Sprite direction
                if (gridObject.facingDirection == Direction.left) {
                    newSprite.zRotation = CGFloat.pi / 2
                } else if (gridObject.facingDirection == Direction.down) {
                    newSprite.zRotation = CGFloat.pi
                } else if (gridObject.facingDirection == Direction.right) {
                    newSprite.zRotation = 3 * CGFloat.pi / 2
                }
            
                //Render any relevant subcomponents
                if (type == "piston") {
                    var pistonArm = SKSpriteNode(imageNamed: "module-piston-extension.png")
                    pistonArm.size = newSprite.size
                    pistonArm.position = CGPoint.zero
                    let piston = gridObject as! Piston
                    if (piston.extended) {
                        piston.extended = false
                        if (gridObject.facingDirection == Direction.up) {
                            pistonArm.position = CGPoint(x: 0, y: -moduleSize * (6/8))
                        } else if (gridObject.facingDirection == Direction.right) {
                            pistonArm.position = CGPoint(x: moduleSize * (6/8), y: 0)
                        } else if (gridObject.facingDirection == Direction.down) {
                            pistonArm.position = CGPoint(x: 0, y: moduleSize * (6/8))
                        } else {
                            pistonArm.position = CGPoint(x: -moduleSize * (6/8), y: 0)
                        }
                    }
                    pistonArm.zPosition = -1
                    newSprite.addChild(pistonArm)
                }
                moduleRoot!.addChild(newSprite)
            }
        }
    }
}
