/*
 Piston : Module
 
 Description:
 Module that, on trigger, sets the current velocity of the GridObject in front of it to 1 and in the direction the piston is facing
 
 Important things to know:
 Due to the way Grid deals with two GridObjects in the same position (thing with hitbox on top of thing without hitbox), this will only push things that have a hitbox
 
*/


class Piston : Module {
	init(position: Vector) {
		super.init(position: position, canMove: true, hasHitbox: true, currentVelocity: (0, Vector(1, 0)))
	}

	override func performAction() {
        if let gridObject = Grid.getGridObjectAt(position: position + currentVelocity.direction) {
            gridObject.currentVelocity = (1, currentVelocity.direction)
        }
	}
}
