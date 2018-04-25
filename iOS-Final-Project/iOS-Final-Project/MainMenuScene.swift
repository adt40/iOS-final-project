//
//  MainMenuScene.swift
//  iOS-Final-Project
//
//  Created by Austin Toot on 4/24/18.
//  Copyright © 2018 Austin Toot. All rights reserved.
//

import UIKit
import SpriteKit

class MainMenuScene: SKScene {
    
    let radius = 75
    var timer = Timer()
    var textSelect = 2 //so the first circle you see says TAP
    
    deinit {
        self.removeAllActions()
        self.removeAllChildren()
    }
    
    func initialize() {
        backgroundColor = .white
        
        let title = SKLabelNode()
        title.text = "MIX"
        title.fontColor = .black
        title.fontSize = 90
        title.position = CGPoint(x: Int(self.size.width) / 2, y: Int(self.size.height) / 2)
        title.alpha = 0
        addChild(title)
        
        let fadeIn = SKAction.fadeAlpha(to: 1, duration: 2)
        title.run(fadeIn)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.addCircle), userInfo: nil, repeats: true)
    }
    
    
    @objc func addCircle() {
        let startSide = Int(arc4random_uniform(UInt32(4)))
        switch startSide {
        case 0:
            //top to bottom
            createCircleSprite(minX: radius, maxX: Int(self.size.width) - radius, minY: -radius, maxY: -radius, spawnLoc: startSide)
        case 1:
            //bottom to top
            createCircleSprite(minX: radius, maxX: Int(self.size.width) - radius, minY: Int(self.size.height) + radius, maxY: Int(self.size.height) + radius, spawnLoc: startSide)
        case 2:
            //left to right
            createCircleSprite(minX: -radius, maxX: -radius, minY: radius, maxY: Int(self.size.height) - radius, spawnLoc: startSide)
        case 3:
            //right to left
            createCircleSprite(minX: Int(self.size.width) + radius, maxX: Int(self.size.width) + radius, minY: radius, maxY: Int(self.size.height) - radius, spawnLoc: startSide)
        default:
            break;
        }
    }
    
    private func createCircleSprite(minX: Int, maxX: Int, minY: Int, maxY: Int, spawnLoc: Int) {
        let xUpper = UInt32(maxX - minX)
        let x = Int(arc4random_uniform(xUpper)) + minX
        
        let yUpper = UInt32(maxY - minY)
        let y = Int(arc4random_uniform(yUpper)) + minY
        
        let mc = randomColor().toRGB()
        let color = UIColor(red: CGFloat(mc.r) / 255.0, green: CGFloat(mc.g) / 255.0, blue: CGFloat(mc.b) / 255.0, alpha: 1)
        
        let circle = SKShapeNode(circleOfRadius: CGFloat(radius))
        circle.position = CGPoint(x: x, y: y)
        circle.fillColor = color
        
        let label = SKLabelNode()
        label.text = getLabelText()
        label.fontSize = 40
        label.fontColor = .black
        label.alpha = 0
        label.position = CGPoint(x: 0, y: -10)
        
        textSelect = (textSelect + 1) % 3
        
        circle.addChild(label)
        addChild(circle)
        
        let duration = Double(arc4random_uniform(3)) + 3
        
        var moveAction : SKAction?
        switch spawnLoc {
        case 0:
            moveAction = SKAction.moveTo(y: self.size.height + CGFloat(radius), duration: duration)
        case 1:
            moveAction = SKAction.moveTo(y: CGFloat(-radius), duration: duration)
        case 2:
            moveAction = SKAction.moveTo(x: self.size.width + CGFloat(radius), duration: duration)
        case 3:
            moveAction = SKAction.moveTo(x: CGFloat(-radius), duration: duration)
        default:
            break;
        }
        
        let despawn = SKAction.removeFromParent()
        
        guard let move = moveAction else {
            fatalError("invalid spawn location")
        }
        let moveSequence = SKAction.sequence([move, despawn])
        circle.run(moveSequence)
        
        let scaleDuration = 0.12
        let scaleUp = SKAction.scale(by: 1.25, duration: scaleDuration)
        let scaleDown = SKAction.scale(by: 0.8, duration: scaleDuration)
        let wait = SKAction.wait(forDuration: 1.0 - scaleDuration * 2.0)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown, wait])
        let repeatScaleForever = SKAction.repeatForever(scaleSequence)
        circle.run(repeatScaleForever)
        
        let fadeIn = SKAction.fadeAlpha(to: 1, duration: scaleDuration)
        let fadeOut = SKAction.fadeAlpha(to: 0, duration: 1.0 - scaleDuration)
        let fadeSequence = SKAction.sequence([fadeIn, fadeOut])
        let repeatFadeForever = SKAction.repeatForever(fadeSequence)
        label.run(repeatFadeForever)

        let textChange = SKAction.customAction(withDuration: 1) {
            node, elapsedTime in
            if let label = node as? SKLabelNode {
                label.text = self.getLabelText()
            }
        }
        let repeatTextForever = SKAction.repeatForever(textChange)
        label.run(repeatTextForever)
        
    }
    
    
    private func randomColor() -> MixableColor {
        var r = 0, y = 0, b = 0
        while (r == 0 && y == 0 && b == 0) || (r == 1 && y == 1 && b == 1) {
            r = Int(arc4random_uniform(2))
            y = Int(arc4random_uniform(2))
            b = Int(arc4random_uniform(2))
        }
        return MixableColor(r, y, b)
    }
    
    private func getLabelText() -> String {
        switch textSelect {
        case 0:
            return "TAP"
        case 1:
            return "TO"
        case 2:
            return "PLAY"
        default:
            return ""
        }
    }
    
}
