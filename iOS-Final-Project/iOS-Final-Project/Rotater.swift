import Foundation

class Rotater : Module {
    var clockwise : Bool
    
    init(position: Vector, clockwise: Bool) {
        self.clockwise = clockwise
        super.init(position: position, canMove: true, hasHitbox: true, facingDirection: Direction.neutral, currentVelocity: (0, Direction.neutral))
    }
    
    override func performAction() {
        //This is harder than I thought
        //Revisit this later, it isn't important
    }
}
