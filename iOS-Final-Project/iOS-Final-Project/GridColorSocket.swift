/*
 GridColorSocket : GridObject
 
 Description:
 This is the colored socket that the player is trying to put the correct GridColor into
 
 Important things to know:
 move() has been overridden to give it the functionality of checking for a GridColor of the correct color in the same position as self.position
 
 
 */

import Foundation

class GridColorSocket : GridObject {
    let desiredColor : MixableColor
    var waitATurn = false
    var gridColorToRemove : GridColor?
    
    init(position: Vector, desiredColor: MixableColor) {
        self.desiredColor = desiredColor
        super.init(position: position, canMove: false, hasHitbox: false, facingDirection: Direction.neutral, currentVelocity: (speed: 0, direction: Direction.neutral))
    }
    
    override func move() {
        if !waitATurn {
            if let gridObject = Grid.getHittableGridObjectsAt(position: position) {
                if let gridColor = gridObject as? GridColor {
                    if gridColor.color == desiredColor {
                        //You did it!
                        waitATurn = true
                        gridColorToRemove = gridColor
                    }
                }
            }
        } else {
            Grid.removeGridObject(gridObject: gridColorToRemove!)
            Grid.removeGridObject(gridObject: self)
            waitATurn = false
        }
        
    }
}
