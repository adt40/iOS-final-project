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
    
    init(filename: String) {
        var jsonData : Data?
        if let file = Bundle.main.path(forResource: filename, ofType: "json") {
            jsonData = try? Data(contentsOf: URL(fileURLWithPath: file))
        } else {
            print("file not found")
        }
        json = try! JSON(data: jsonData!)
    }
    
    func loadLevel(level: Int) {
        //oof
    }
    
}
