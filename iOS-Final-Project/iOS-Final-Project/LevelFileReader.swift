//
//  LevelFileReader.swift
//  iOS-Final-Project
//
//  Created by Austin Toot on 3/5/18.
//  Copyright © 2018 Austin Toot. All rights reserved.
//

import Foundation

class LevelFileReader {
    
    var json = JSON.null
    
    func initJSON(filename: String) {
        var jsonData : Data?
        if let file = Bundle.main.path(forResource: filename, ofType: "json") {
            jsonData = try? Data(contentsOf: URL(fileURLWithPath: file))
        } else {
            print("file not found")
        }
        json = try! JSON(data: jsonData!)
    }
    
    func loadLevel(world: Int, level: Int) -> (name: String, gridSize: Vector, availableModules: [String], gridObjects: [GridObject]){
        initJSON(filename: "level" + String(world) + "-" + String(level))
        
        let name = json["name"].stringValue
        let gridSize = Vector(json["GridSize"]["x"].intValue, json["GridSize"]["y"].intValue)
        let availableModules = json["AvailableModules"].arrayValue.map{ $0.stringValue }
        
        var gridObjects : [GridObject] = []
        for gridObject in json["GridObjects"].arrayValue {
            let type = gridObject["type"].stringValue
            switch type {
            case "color":
                let position = Vector(gridObject["position", "x"].intValue, gridObject["position", "y"].intValue)
                let color = MixableColor(gridObject["color", "r"].intValue, gridObject["color", "y"].intValue, gridObject["color", "b"].intValue)
                let gridColor = GridColor(position: position, color: color)
                gridObjects.append(gridColor)
            case "socket":
                let position = Vector(gridObject["position", "x"].intValue, gridObject["position", "y"].intValue)
                let color = MixableColor(gridObject["color", "r"].intValue, gridObject["color", "y"].intValue, gridObject["color", "b"].intValue)
                let gridColorSocket = GridColorSocket(position: position, desiredColor: color)
                gridObjects.append(gridColorSocket)
            case "piston":
                let position = Vector(gridObject["position", "x"].intValue, gridObject["position", "y"].intValue)
                let direction = Direction.fromString(gridObject["direction"].stringValue)
                let piston = Piston(position: position, direction: direction)
                if gridObject["canMove"].exists() {
                    piston.canMove = gridObject["canMove"].boolValue
                }
                gridObjects.append(piston)
            case "rotator":
                let position = Vector(gridObject["position", "x"].intValue, gridObject["position", "y"].intValue)
                let direction = Direction.fromString(gridObject["direction"].stringValue)
                let clockwise = gridObject["clockwise"].boolValue
                let rotator = Rotator(position: position, direction: direction, clockwise: clockwise)
                if gridObject["canMove"].exists() {
                    rotator.canMove = gridObject["canMove"].boolValue
                }
                gridObjects.append(rotator)
            case "colorzapper":
                let position = Vector(gridObject["position", "x"].intValue, gridObject["position", "y"].intValue)
                let direction = Direction.fromString(gridObject["direction"].stringValue)
                let color = MixableColor(gridObject["color", "r"].intValue, gridObject["color", "y"].intValue, gridObject["color", "b"].intValue)
                let colorZapper = ColorZapper(position: position, direction: direction, color: color)
                if gridObject["canMove"].exists() {
                    colorZapper.canMove = gridObject["canMove"].boolValue
                }
                gridObjects.append(colorZapper)
            case "trigger":
                let position = Vector(gridObject["position", "x"].intValue, gridObject["position", "y"].intValue)
                let onEnter = gridObject["onEnter"].boolValue
                let startTime = gridObject["startTime"].intValue
                let repeatTime = gridObject["repeatTime"].intValue
                let trigger = TriggerPad(position: position, triggerOnEnter: onEnter, triggerOnTimeStart: startTime, triggerOnTimeRepeat: repeatTime)
                gridObjects.append(trigger)
            case "wall":
                let position = Vector(gridObject["position", "x"].intValue, gridObject["position", "y"].intValue)
                let wall = Wall(position: position)
                if gridObject["canMove"].exists() {
                    wall.canMove = gridObject["canMove"].boolValue
                }
                gridObjects.append(wall)
            default:
                print("invalid JSON module of type: " + type)
            }
        }
        return (name: name, gridSize: gridSize, availableModules: availableModules, gridObjects: gridObjects)
    }
    
    func getLevelSelectData(world: Int, level: Int) -> (runtimeScore: Int, moduleScore: Int, name: String) {
        initJSON(filename: "level" + String(world) + "-" + String(level))
        let runtimeScore = json["RuntimeScore"].intValue
        let moduleScore = json["ModuleScore"].intValue
        let name = json["name"].stringValue
        return (runtimeScore: runtimeScore, moduleScore: moduleScore, name: name)
    }
    
    //will check to see if scores should be updated, so call this whenever a level is beaten regardless if it is a high score or not
    func updateScore(world: Int, level: Int, runtimeScore: Int, moduleScore: Int) {
        initJSON(filename: "level" + String(world) + "-" + String(level))
        let oldRuntimeScore = json["RuntimeScore"].intValue
        let oldModuleScore = json["ModuleScore"].intValue
        
        //low scores are good, but a score of 0 means it hasn't been beaten yet
        if (runtimeScore < oldRuntimeScore || oldRuntimeScore == 0) {
            json["RuntimeScore"].int = runtimeScore
        }
        
        if (moduleScore < oldModuleScore || oldModuleScore == 0) {
            json["ModuleScore"].int = moduleScore
        }
    }
    
    func getLevelCounts() -> [Int] {
        var levels = [Int]()
        let fileManager = FileManager.default
        do {
            //get files
            var files = try fileManager.contentsOfDirectory(atPath: Bundle.main.bundlePath)
            
            //get only files that start with "level"
            var workingIndex = 0
            for file in files {
                if file.prefix(through: file.index(file.startIndex, offsetBy: 4)) != "level" {
                    files.remove(at: workingIndex)
                } else {
                    workingIndex += 1
                }
            }
            
            //find highest world
            var maxWorld = 0
            for file in files {
                guard let world = Int(String(file[file.index(file.startIndex, offsetBy: 5)])) else {
                    fatalError("File world is not valid")
                }
                if world > maxWorld {
                    maxWorld = world
                }
            }
            
            //initialize bucket array based on highest world
            levels = Array(repeating: 0, count: maxWorld)
            
            //fill bucket
            for file in files {
                guard let world = Int(String(file[file.index(file.startIndex, offsetBy: 5)])) else {
                    fatalError("File world is not valid")
                }
                levels[world - 1] += 1
            }
            
        } catch let error as NSError {
            print("oopsie woopsie: \(error)")
        }
        
        return levels
    }
}


























