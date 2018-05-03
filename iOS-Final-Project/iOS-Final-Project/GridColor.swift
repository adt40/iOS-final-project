/*
 GridColor : GridObject
 
 Description:
 These are the colored circles the player will be trying to move around with modules.
 
 Important things to know:
 Overrides move to check for mixing with another GridColor
 
 */

import Foundation

class GridColor : GridObject {
    
    var color : MixableColor
    
    init(position: Vector, color: MixableColor) {
        self.color = color
        super.init(position: position, canMove: true, canEdit: false, hasHitbox: true, facingDirection: Direction.neutral, currentVelocity: (speed: 0, direction: Direction.neutral))
    }
    
    override func move() {
        if canMove {
            if currentVelocity.speed > 0 {
                let newPosition = position + currentVelocity.direction.toVector() * currentVelocity.speed
                
                if !Grid.isOutside(position: newPosition) && !Grid.isGridObjectAt(position: newPosition) {
                    position = newPosition
                } else if let gridColor = Grid.getHittableGridObjectsAt(position: newPosition) as? GridColor {
                    mix(with: gridColor)
                    position = newPosition
                    //might need to calculate new velocity for specific cases
                } else {
                    currentVelocity.speed = 0
                    currentVelocity.direction = Direction.neutral
                }
            }
        }
    }
    
    func mix(with gridColor: GridColor) {
        addColor(gridColor.color)
        Grid.removeGridObject(gridObject: gridColor)
    }
    
    func addColor(_ color: MixableColor) {
        self.color = self.color + color
    }
}
