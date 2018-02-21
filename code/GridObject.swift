class GridObject {
	var position : Vector
	var canMove : Bool
	var hasHitbox : Bool
	var currentVelocity : (speed: Int, direction: Vector)
	init(position: Vector, canMove: Bool, hasHitbox: Bool, currentVelocity: (speed: Int, direction: Vector) {
		self.position = position
		self.canMove = canMove
		self.hasHitbox = hasHitbox
		self.currentVelocity = currentVelocity
	}

	func move() {
		if canMove {
			position = position + currentVelocity.direction * currentVelocity.speed

			//This needs a fleshing out (hitting walls and stuff)
		}
	}
}