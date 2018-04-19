/*
 Piston : Module
 
 Description:
 Module that, on trigger, sets the current velocity of the GridObject in front of it to 1 and in the direction the piston is facing
 
 Important things to know:
 Due to the way Grid deals with two GridObjects in the same position (thing with hitbox on top of thing without hitbox), this will only push things that have a hitbox
 
*/


class Piston : Module {
    var extended = false
    
    init(position: Vector, direction: Direction) {
		super.init(position: position, canMove: true, hasHitbox: true, facingDirection: direction, currentVelocity: (0, Direction.neutral)) //default to up
	}

	override func performAction() {
        if let gridObject = Grid.getHittableGridObjectsAt(position: position + facingDirection.toVector()) {
            gridObject.currentVelocity = (1, facingDirection)
        }
        //TODO: Don't extend piston if extending it would push arm off grid or if it is blocked
        extended = true
	}
}
