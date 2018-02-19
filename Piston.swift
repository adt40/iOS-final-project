class Piston : Module {
	init(position: Vector) {
		super.init(position: position, canMove: true, hasHitbox: true, currentVelocity: (0, Vector(1, 0)))
	}

	override func performAction() {
		Grid.getGridObjectAt(position: position + currentVelocity.direction).currentVelocity = (1, currentVelocity.direction)
	}
}