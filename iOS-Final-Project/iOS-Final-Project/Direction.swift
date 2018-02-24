/*
 Direction
 
 Description:
 makes life easier by making the code more English
 
 
 */

import Foundation

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
}
