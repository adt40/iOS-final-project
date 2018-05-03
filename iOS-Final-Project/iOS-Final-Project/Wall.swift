/*
 Wall : Module
 
 Description:
 Its a wall. It don't do too much, mostly just blocks stuff.
 
 Important things to know:
 In its current implementation it can't move, so it'll be more for designing levels than actually being useful for the player
 
 */

import Foundation

class Wall : Module {
    init(position: Vector) {
        super.init(position: position, canMove: false, canEdit: true, hasHitbox: true, facingDirection: Direction.neutral, currentVelocity: (speed: 0, direction: Direction.neutral))
    }
}
