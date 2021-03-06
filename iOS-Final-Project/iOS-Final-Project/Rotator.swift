import Foundation

class Rotator : Module {
    var clockwise : Bool
    var rotating: Bool = false
    
    init(position: Vector, direction: Direction, clockwise: Bool) {
        self.clockwise = clockwise
        super.init(position: position, canMove: true, canEdit: true, hasHitbox: true, facingDirection: direction, currentVelocity: (0, Direction.neutral))
    }
    
    override func performAction() {
        if let gridObject = Grid.getHittableGridObjectsAt(position: position + facingDirection.toVector()) {
            if clockwise {
                gridObject.facingDirection = gridObject.facingDirection.clockwise()
                gridObject.currentVelocity.direction = gridObject.currentVelocity.direction.clockwise()
            } else {
                gridObject.facingDirection = gridObject.facingDirection.counterClockwise()
                gridObject.currentVelocity.direction = gridObject.currentVelocity.direction.counterClockwise()
            }
        }
        rotating = true
    }
    
    override func deactivate() {
        rotating = false
    }
}
