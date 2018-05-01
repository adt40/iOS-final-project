/*
 Direction
 
 Description:
 makes life easier by making the code more English
 
 
 */

import Foundation
import SpriteKit

enum Direction {
    case up, down, left, right, neutral
    
    func toVector() -> Vector {
        switch self {
        case .up:
            return Vector(0, -1)
        case .down:
            return Vector(0, 1)
        case .left:
            return Vector(-1, 0)
        case .right:
            return Vector(1, 0)
        case .neutral:
            return Vector(0, 0)
        }
    }
    
    func toRadians() -> CGFloat {
        switch self {
        case .up:
            return 0
        case .down:
            return CGFloat.pi
        case .left:
            return CGFloat.pi / 2
        case .right:
            return 3 * CGFloat.pi / 2
        case .neutral:
            return 0
        }
    }
    
    func clockwise() -> Direction {
        switch self {
        case .up:
            return .right
        case .right:
            return .down
        case .down:
            return .left
        case .left:
            return .up
        case .neutral:
            return .neutral
        }
    }
    
    func counterClockwise() -> Direction {
        switch self {
        case .up:
            return .left
        case .right:
            return .up
        case .down:
            return .right
        case .left:
            return .down
        case .neutral:
            return .neutral
        }
    }
    
    static func fromString(_ str : String) -> Direction {
        switch str {
        case "up":
            return .up
        case "left":
            return .left
        case "down":
            return .down
        case "right":
            return .right
        case "neutral":
            return .neutral
        default:
            return .neutral
        }
    }
}
