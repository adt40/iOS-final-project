/*
 Piston : Module
 
 Description:
 Module that, on trigger, sets the current velocity of the GridObject in front of it to 1 and in the direction the piston is facing
 
 Important things to know:
 Due to the way Grid deals with two GridObjects in the same position (thing with hitbox on top of thing without hitbox), this will only push things that have a hitbox
 
*/


class Piston : Module {
	init(position: Vector) {
		super.init(position: position, canMove: true, hasHitbox: true, facingDirection: Vector(0, 1), currentVelocity: (0, Vector(0, 1))) //default to up direction
	}

	override func performAction() {
        if let gridObject = Grid.getHittableGridObjectsAt(position: position + facingDirection) {
            gridObject.currentVelocity = (1, facingDirection)
        }
	}
}
