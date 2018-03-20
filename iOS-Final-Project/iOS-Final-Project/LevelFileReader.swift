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
    
    func loadLevel(world: Int, level: Int) -> (name: String, gridSize: Vector, gridObjects: [GridObject]){
        initJSON(filename: "level" + String(world) + "-" + String(level))
        let name = json["name"].stringValue
        let gridSize = Vector(json["GridSize"]["x"].intValue, json["GridSize"]["y"].intValue)
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
                gridObjects.append(piston)
            case "rotator":
                let position = Vector(gridObject["position", "x"].intValue, gridObject["position", "y"].intValue)
                let direction = Direction.fromString(gridObject["direction"].stringValue)
                let clockwise = gridObject["clockwise"].boolValue
                let rotator = Rotator(position: position, direction: direction, clockwise: clockwise)
                gridObjects.append(rotator)
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
                gridObjects.append(wall)
            default:
                print("invalid JSON type: " + type)
            }
        }
        return (name: name, gridSize: gridSize, gridObjects: gridObjects)
    }
}
