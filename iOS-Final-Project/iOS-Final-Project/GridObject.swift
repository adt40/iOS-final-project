/*
 GridObject
 
 Description:
 An object that goes into a position in the Grid. This has only the most basic things all objects in the Grid must have
 
 Important things to know:
 move() will only go if the GridObject can move. If it cannot move, it will set its current speed to zero
 
*/

class GridObject {
	var position : Vector
	var canMove : Bool
	var hasHitbox : Bool
    var facingDirection : Vector
	var currentVelocity : (speed: Int, direction: Vector)
    init(position: Vector, canMove: Bool, hasHitbox: Bool, facingDirection: Vector, currentVelocity: (speed: Int, direction: Vector)) {
		self.position = position
		self.canMove = canMove
		self.hasHitbox = hasHitbox
        self.facingDirection = facingDirection
		self.currentVelocity = currentVelocity
	}

	func move() {
		if canMove {
			let newPosition = position + currentVelocity.direction * currentVelocity.speed
            
            if !Grid.isGridObjectAt(position: newPosition) {
                position = newPosition
            }
		}
	}
}
