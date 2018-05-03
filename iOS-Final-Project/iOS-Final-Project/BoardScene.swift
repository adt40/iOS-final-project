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
    var moduleBankRoot: SKNode?
    var boardSpace: CGSize?
    var currentlyDragging: (node: SKNode?, startPosition: CGPoint?, touchStart: CGPoint?, active: Bool) = (nil, nil, nil, false)
    let moduleBankHeight: CGFloat = 100
    let moduleBankPadding: CGFloat = 10
    let bankModuleSpacing: CGFloat = 10
    
    let GRID_LAYER = CGFloat(1)
    let MODULE_LAYER = CGFloat(10)
    let MODULE_BANK_LAYER = CGFloat(20)
    
    var superView : LevelViewController?
    
    deinit {
        self.removeAllActions()
        self.removeAllChildren()
        gridRoot!.removeAllActions()
        gridRoot!.removeAllChildren()
        gridRoot = nil
        moduleRoot!.removeAllActions()
        moduleRoot!.removeAllChildren()
        moduleRoot = nil
    }
    
    func renderModuleBank(availableModules: [String]) {
        //Initialize Module Bank Container
        moduleBankRoot = SKNode()
        moduleBankRoot!.zPosition = MODULE_BANK_LAYER
        addChild(moduleBankRoot!)
        
        //render module bank background
        let moduleBankBackground = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size.width, height: moduleBankHeight))
        moduleBankBackground.fillColor = SKColor.white
        moduleBankBackground.strokeColor = SKColor.gray
        moduleBankBackground.zPosition = -1
        moduleBankRoot!.addChild(moduleBankBackground)
        
        //calculate the size of modules in the bank
        let moduleBankRenderingRatio = floor((boardSpace!.width - 2 * moduleBankPadding) / (moduleBankHeight - 2 * moduleBankPadding))
        let moduleGroups = ceil(CGFloat(availableModules.count) / moduleBankRenderingRatio)
        let bankModuleSize = (moduleBankHeight - 2 * moduleBankPadding) / ceil(sqrt(moduleGroups)) - 2 * bankModuleSpacing
        //Render them in the pattern described by the ratio we found
        var x = CGFloat(0), y = CGFloat(0)
        var newSprite: SKSpriteNode
        var filename: String
        for module in availableModules {
            filename = "module-" + module
            if module == "trigger" {
                filename += "pad-inactive"
            }
            newSprite = SKSpriteNode(imageNamed: filename)
            newSprite.zPosition = 2
            moduleBankRoot!.addChild(newSprite)
            
            newSprite.size = CGSize(width: bankModuleSize, height: bankModuleSize)
            let xPos = moduleBankPadding + (x * ((2 * bankModuleSpacing) + bankModuleSize)) +  bankModuleSpacing + (bankModuleSize / 2)
            let yPos = moduleBankHeight - moduleBankPadding - (y * (2 * bankModuleSpacing + bankModuleSize)) -  (bankModuleSpacing + bankModuleSize / 2)
            newSprite.position = CGPoint(x: xPos, y: yPos)
            newSprite.name = "module-bank-" + module
            
            //Render any relevant subcomponents
            if (module == "piston") {
                let pistonArm = SKSpriteNode(imageNamed: "module-piston-extension.png")
                pistonArm.size = newSprite.size
                pistonArm.position = CGPoint.zero
                pistonArm.zPosition = -1
                newSprite.addChild(pistonArm)
            }
            
            if x < ceil(sqrt(moduleGroups)) * moduleBankRenderingRatio - 1 {
                x += 1
            } else if x >= ceil(sqrt(moduleGroups)) * moduleBankRenderingRatio - 1 {
                x = 0
                y += 1
            }
        }
    }
    
    //Only needs to be called once (renders actual grid lines)
    func renderGrid(gridSize: Vector) {
        boardSpace = CGSize(width: size.width, height: size.height - 100)
        //Have to subtract 78 because of the 39 point blue glow on the edges on either side of grid
        //var tileSize = (size.width - glowEffectSize * 2) / CGFloat(gridSize.x)
        
        //At first, assign tile size based on width
        tileSize = boardSpace!.width / CGFloat(gridSize.x)
        bufferWidth = CGFloat(0)
        //If the tiles are going to overflow vertically, shrink them and add a buffer on the sides
        if (tileSize * CGFloat(gridSize.y) > boardSpace!.height) {
            tileSize = boardSpace!.height / CGFloat(gridSize.y)
            bufferWidth = (boardSpace!.width - tileSize * CGFloat(gridSize.x)) / 2
        }
        moduleSize = tileSize - 4
        
        gridRoot = SKNode()
        gridRoot!.position.y = moduleBankHeight
        gridRoot!.zPosition = GRID_LAYER
        addChild(gridRoot!)
        var filename: String
        var newSprite: SKSpriteNode
        var currentXpos = tileSize / 2 + bufferWidth
        var currentYpos = boardSpace!.height - tileSize / 2
        
        for y in 0..<gridSize.y {
            for x in 0..<gridSize.x {
                //Initialize filename
                filename = "tile-central-"
                
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
                newSprite.name = "tile(\(Int(newSprite.position.x)),\(Int(newSprite.position.y)))"
                
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
        moduleRoot = SKNode()
        moduleRoot!.position.y = moduleBankHeight
        moduleRoot!.zPosition = MODULE_LAYER
        addChild(moduleRoot!)
        
        for gridObject in gridObjects {
            generateModuleSprite(gridObject: gridObject)
        }
    }
    
    func generateModuleSprite(gridObject: GridObject) {
        var filename: String
        //Determine type of module
        var type: String
        if let _ = gridObject as? Piston {
            type = "piston"
        } else if let obj = gridObject as? TriggerPad {
            type = "triggerpad-"
            //TODO: Change to triggerWillBeActive once that's implemented
            if (!obj.triggerActive) {
                type += "in"
            }
            type += "active"
        } else if let _ = gridObject as? Rotator {
            type = "rotator-noarrow"
        } else if gridObject is GridColor {
            type = "gridcolor"
        } else if gridObject is GridColorSocket {
            type = "gridcolorsocket"
        } else if gridObject is Wall {
            type = "wall"
        } else {
            type = "temp"
        }
        
        if type == "gridcolor" {
            let path = CGMutablePath()
            let module = gridObject as! GridColor
            path.addArc(center: CGPoint.zero, radius: moduleSize / 4, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
            let newShape = SKShapeNode(path: path)
            newShape.lineWidth = 1
            let color = module.color.toRGB()
            newShape.fillColor = SKColor(red: CGFloat(color.r)/255, green: CGFloat(color.g)/255, blue: CGFloat(color.b)/255, alpha: 0.8)
            newShape.strokeColor = SKColor.white
            
            newShape.position = CGPoint(x: bufferWidth + tileSize * CGFloat(gridObject.position.x) + moduleSize / 2 + (tileSize - moduleSize) / 2, y: boardSpace!.height - tileSize * CGFloat(gridObject.position.y) - moduleSize / 2 - (tileSize - moduleSize) / 2)
            newShape.zPosition = MODULE_LAYER + 1
            moduleRoot!.addChild(newShape)
            gridObject.assignSprite(sprite: newShape)
        } else if type == "gridcolorsocket" {
            let module = gridObject as! GridColorSocket
            var path = CGMutablePath()
            path.addRect(CGRect(x: -moduleSize / 2, y: -moduleSize / 2, width: moduleSize, height: moduleSize))
            let newShape = SKShapeNode(path: path)
            newShape.lineWidth = 1
            let color = module.desiredColor.toRGB()
            newShape.fillColor = SKColor(red: CGFloat(color.r)/255, green: CGFloat(color.g)/255, blue: CGFloat(color.b)/255, alpha: 0.8)
            newShape.strokeColor = SKColor.white
            
            newShape.position = CGPoint(x: bufferWidth + tileSize * CGFloat(gridObject.position.x) + moduleSize / 2 + (tileSize - moduleSize) / 2, y: boardSpace!.height - tileSize * CGFloat(gridObject.position.y) - moduleSize / 2 - (tileSize - moduleSize) / 2)
            newShape.zPosition = MODULE_LAYER - 1
            moduleRoot!.addChild(newShape)
            
            path = CGMutablePath()
            path.addArc(center: CGPoint.zero, radius: moduleSize / 4, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
            let holeShape = SKShapeNode(path: path)
            holeShape.fillColor = SKColor.white
            holeShape.strokeColor = SKColor.black
            holeShape.position = CGPoint.zero
            holeShape.zPosition = 1
            
            newShape.addChild(holeShape)
            gridObject.assignSprite(sprite: newShape)
        } else {
            //Select image file
            
            filename = "module-\(type).png"
            
            //Generate Sprite
            let newSprite = SKSpriteNode(imageNamed: filename)
            newSprite.name = "inplay-\(type)"
            
            //Set Sprite position
            newSprite.position = CGPoint(x: bufferWidth + tileSize * CGFloat(gridObject.position.x) + moduleSize / 2 + (tileSize - moduleSize) / 2, y: boardSpace!.height - tileSize * CGFloat(gridObject.position.y) - moduleSize / 2 - (tileSize - moduleSize) / 2)
            
            //Set sprite rendering order
            if (type == "triggerpad-active" || type == "triggerpad-inactive") {
                newSprite.zPosition = MODULE_LAYER - 2
            } else if (type == "rotator") {
                newSprite.zPosition = MODULE_LAYER + 2
            } else {
                newSprite.zPosition = MODULE_LAYER
            }
        
            //Set Sprite direction
            if (gridObject.facingDirection == Direction.left) {
                newSprite.zRotation = CGFloat.pi / 2
            } else if (gridObject.facingDirection == Direction.down) {
                newSprite.zRotation = CGFloat.pi
            } else if (gridObject.facingDirection == Direction.right) {
                newSprite.zRotation = 3 * CGFloat.pi / 2
            }
            
            //Account for minor differences in size between modules
            if (type == "rotator-noarrow") {
                //Rotator is bigger so that it stretches into adjacent tiles to make rotation ability more intuitive
                newSprite.size = CGSize(width: moduleSize, height: moduleSize * (73 / 60))
                //Adjust position
                if (gridObject.facingDirection == Direction.left) {
                    newSprite.position.x -= moduleSize * (13/120)
                } else if (gridObject.facingDirection == Direction.down) {
                    newSprite.position.y -= moduleSize * (13/120)
                } else if (gridObject.facingDirection == Direction.right) {
                    newSprite.position.x += moduleSize * (13/120)
                } else {
                    newSprite.position.y += moduleSize * (13/120)
                }
            } else {
                newSprite.size = CGSize(width: moduleSize, height: moduleSize)
            }
        
            //Render any relevant subcomponents
            if (type == "piston") {
                let pistonArm = SKSpriteNode(imageNamed: "module-piston-extension.png")
                pistonArm.size = newSprite.size
                pistonArm.position = CGPoint.zero
                let piston = gridObject as! Piston
                if (piston.extended) {
                    pistonArm.position = CGPoint(x: 0, y: moduleSize * (6/8))
                }
                pistonArm.zPosition = -1
                newSprite.addChild(pistonArm)
            } else if (type == "rotator-noarrow") {
                var arrow: SKSpriteNode
                if (gridObject as! Rotator).clockwise {
                    arrow = SKSpriteNode(imageNamed: "module-rotator-arrow-clockwise.png")
                } else {
                    arrow = SKSpriteNode(imageNamed: "module-rotator-arrow-counterclockwise.png")
                }
                arrow.position = CGPoint(x: 0, y: -moduleSize * (13/120))
                arrow.zPosition = 1
                
                newSprite.addChild(arrow)
                
                let gear1 = SKSpriteNode(imageNamed: "module-rotator-gear.png")
                let gear2 = SKSpriteNode(imageNamed: "module-rotator-gear.png")
                
                gear1.zPosition = -1
                gear2.zPosition = -1
                
                gear1.position = CGPoint(x: -moduleSize * (3/8), y: moduleSize / 2 + moduleSize * (1/10))
                gear2.position = CGPoint(x: moduleSize * (3/8), y: moduleSize / 2 + moduleSize * (1/10))
                
                gear1.size = CGSize(width: moduleSize * (14 / 60), height: moduleSize * (14 / 60))
                gear2.size = CGSize(width: moduleSize * (14 / 60), height: moduleSize * (14 / 60))
                
                newSprite.addChild(gear1)
                newSprite.addChild(gear2)
            }
            moduleRoot!.addChild(newSprite)
            gridObject.assignSprite(sprite: newSprite)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 1 {
            let touch = touches.first!
            let positionInScene = touch.location(in: self)
            let touchedNodes = self.nodes(at: positionInScene)
            var touchedModule: SKSpriteNode?
            for node in touchedNodes {
                if node.name != nil && node.name!.contains("module-bank-") {
                    touchedModule = node as? SKSpriteNode
                    break
                } else if node.name != nil && node.name!.contains("inplay-") {
                    let position = Vector(Int(floor((positionInScene.x - bufferWidth) / tileSize)), Int(floor((boardSpace!.height - positionInScene.y) / tileSize)) + 1)
                    let gridObjectsAtPosition = Grid.getAllGridObjectsAt(position: position)
                    for obj in gridObjectsAtPosition {
                        if obj.canEdit {
                            DispatchQueue.main.async {
                                self.superView!.displayOptionsFor(gridObject: obj)
                            }
                            break //this sucks because you can place two objects on the same tile but oh well
                        }
                    }
                } else {
                    superView!.moduleOptionsView.isHidden = true
                }
            }
            if touchedModule == nil {
                return
            }
            currentlyDragging.touchStart = positionInScene
            currentlyDragging.startPosition = CGPoint(x: touchedModule!.position.x, y: touchedModule!.position.y)
            currentlyDragging.node = touchedModule
            currentlyDragging.active = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (currentlyDragging.active) {
            let newTouchPosition = touches.first!.location(in: self)
            currentlyDragging.node!.position = newTouchPosition
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (currentlyDragging.active) {
            let newTouchPosition = touches.first!.location(in: self)
            let touchedNodes = self.nodes(at: newTouchPosition)
            var touchedTile: SKSpriteNode?
            for node in touchedNodes {
                if (node.name != nil && node.name!.contains("tile")) {
                    touchedTile = node as? SKSpriteNode
                    break;
                }
            }
            if (touchedTile != nil) {
                let position = Vector(Int(floor((touchedTile!.position.x - bufferWidth) / tileSize)), Int(floor((boardSpace!.height - touchedTile!.position.y) / tileSize)))
                var gridObject: GridObject?
                if (currentlyDragging.node!.name!.contains("piston")) {
                    if (!Grid.isGridObjectAt(position: position, hasHitbox: true)) {
                        gridObject = Piston(position: position, direction: Direction.up)
                    }
                } else if (currentlyDragging.node!.name!.contains("trigger")) {
                    if (!Grid.isGridObjectAt(position: position, hasHitbox: false)) {
                        gridObject = TriggerPad(position: position)
                    }
                } else if (currentlyDragging.node!.name!.contains("wall")) {
                    if (!Grid.isGridObjectAt(position: position, hasHitbox: true)) {
                        gridObject = Wall(position: position)
                    }
                } else if (currentlyDragging.node!.name!.contains("rotator")) {
                    if (!Grid.isGridObjectAt(position: position, hasHitbox: true)) {
                        gridObject = Rotator(position: position, direction: Direction.up, clockwise: true)
                    }
                } else if (currentlyDragging.node!.name!.contains("colorzapper")) {
                    if (!Grid.isGridObjectAt(position: position, hasHitbox: true)) {
                        gridObject = ColorZapper(position: position, direction: Direction.up, color: MixableColor(1, 0, 0))
                    }
                } else {
                    fatalError("No Correspinding Module Type Coded For Bank Module: \"\(currentlyDragging.node!.name!)\"")
                }
                if let placedObject = gridObject {
                    superView!.modulesUsed += 1
                    Grid.addGridObject(gridObject: placedObject)
                    generateModuleSprite(gridObject: placedObject)
                    currentlyDragging.node!.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.4), SKAction.move(to: currentlyDragging.startPosition!, duration: 0), SKAction.fadeIn(withDuration: 0.4)]))
                    placedObject.uiSprite!.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0), SKAction.fadeIn(withDuration: 0.5)]))
                } else {
                    currentlyDragging.node!.run(SKAction.move(to: currentlyDragging.startPosition!, duration: 0.4))
                }
            } else {
                currentlyDragging.node!.run(SKAction.move(to: currentlyDragging.startPosition!, duration: 0.4))
            }
            currentlyDragging.node = nil
            currentlyDragging.active = false
            currentlyDragging.startPosition = nil
            currentlyDragging.touchStart = nil
        }
    }
}
