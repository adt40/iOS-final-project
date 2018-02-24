/*
 GridObject
 
 Description:
 An object that goes into a position in the Grid. This has only the most basic things all objects in the Grid must have
 
 Important things to know:
 move() will only go if the GridObject can move. If it cannot move, it will set its current speed to zero
 Each GridObject will have its own unique (position, hasHitbox) tuple. This can be used to find specific GridObjects
 
*/

class GridObject {
	var position : Vector
	var canMove : Bool
	var hasHitbox : Bool
    var facingDirection : Direction
	var currentVelocity : (speed: Int, direction: Direction)
    init(position: Vector, canMove: Bool, hasHitbox: Bool, facingDirection: Direction, currentVelocity: (speed: Int, direction: Direction)) {
		self.position = position
		self.canMove = canMove
		self.hasHitbox = hasHitbox
        self.facingDirection = facingDirection
		self.currentVelocity = currentVelocity
	}

	func move() {
		if canMove {
            if currentVelocity.speed > 0 {
                let newPosition = position + currentVelocity.direction.toVector() * currentVelocity.speed
                
                if !Grid.isOutside(position: newPosition) && !Grid.isGridObjectAt(position: newPosition) {
                    position = newPosition
                } else {
                    currentVelocity.speed = 0
                    currentVelocity.direction = Direction.neutral
                }
            }
		}
	}
}
