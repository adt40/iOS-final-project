/*
 GridObject
 
 Description:
 An object that goes into a position in the Grid. This has only the most basic things all objects in the Grid must have
 
 Important things to know:
 move() will only go if the GridObject can move. If it cannot move, it will set its current speed to zero
 Each GridObject will have its own unique (position, hasHitbox) tuple. This can be used to find specific GridObjects
 
*/
import SpriteKit

class GridObject {
	var position : Vector
	var canMove : Bool
    var canEdit : Bool
	var hasHitbox : Bool
    var facingDirection : Direction
	var currentVelocity : (speed: Int, direction: Direction)
    var uiSprite: SKNode?
    init(position: Vector, canMove: Bool, canEdit: Bool, hasHitbox: Bool, facingDirection: Direction, currentVelocity: (speed: Int, direction: Direction)) {
		self.position = position
		self.canMove = canMove
        self.canEdit = canEdit
		self.hasHitbox = hasHitbox
        self.facingDirection = facingDirection
		self.currentVelocity = currentVelocity
	}
    
    func assignSprite(sprite: SKNode) {
        self.uiSprite = sprite
    }

	func move() {
		if canMove {
            if currentVelocity.speed > 0 {
                let newPosition = position + currentVelocity.direction.toVector() * currentVelocity.speed
                
                if !Grid.isOutside(position: newPosition) && !Grid.isGridObjectAt(position: newPosition, hasHitbox: true) {
                    position = newPosition
                } else {
                    currentVelocity.speed = 0
                    currentVelocity.direction = Direction.neutral
                }
            }
		}
	}
}
