/*
 Grid
 
 Description:
 Saves the state of the board into a static array
 
 Important things to know:
 state is an array of all GridObjects currently in the Grid.
 state is a 1D array, even though the grid itself is 2D. This is because the position of each GridObject is being tracked in the GridObject itself. This makes coding significantly easier, but it could lead to performance hits if a state gets huge. But that shouldn't happen so I'm sticking with this for now
 
*/

import SpriteKit

class Grid {
	static private var state : [GridObject] = []
    static private var maxGridPosition : Vector = Vector(0, 0)
	static var currentTime : Int = 0
    static var speed : Double = 2
	
    static func initialize(size: Vector) {
        maxGridPosition = Vector(size.x - 1, size.y - 1)
		currentTime = 0
        state = []
	}
    
    static func addGridObject(gridObject: GridObject) {
        state.append(gridObject)
    }
    
    //A grid object is uniquely determined by its position and whether it has a hitbox or not
    static func removeGridObject(gridObject: GridObject) {
        for i in 0..<state.count {
            if (state[i].position == gridObject.position) && (state[i].hasHitbox == gridObject.hasHitbox) {
                state.remove(at: i)
                gridObject.uiSprite?.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 1 / pow(speed, 1.5)), SKAction.removeFromParent()]))
                break
            }
        }
    }
    
    static func getState() -> [GridObject]{
        return state
    }
    
    static func isGridObjectAt(position: Vector, hasHitbox: Bool) -> Bool {
        for gridObject in state {
            if gridObject.position == position && (hasHitbox ? gridObject.hasHitbox : !gridObject.hasHitbox) {
                return true
            }
        }
        return false
    }

	static func getHittableGridObjectsAt(position: Vector) -> GridObject? {
		for gridObject in state {
            if gridObject.position == position && gridObject.hasHitbox {
                return gridObject
            }
        }
		return nil
	}
    
    static func getAllGridObjectsAt(position: Vector) -> [GridObject] {
        var gridObjects : [GridObject] = []
        for gridObject in state {
            if gridObject.position == position {
                gridObjects.append(gridObject)
            }
        }
        return gridObjects
    }

	static func getAdjacentHittableGridObjectsAt(position: Vector) -> [GridObject] {
		var adjacents : [GridObject] = []
        if let up = getHittableGridObjectsAt(position: position + Direction.up.toVector()) {
            adjacents.append(up)
        }
        if let right = getHittableGridObjectsAt(position: position + Direction.right.toVector()) {
            adjacents.append(right)
        }
        if let down = getHittableGridObjectsAt(position: position + Direction.down.toVector()) {
            adjacents.append(down)
        }
        if let left = getHittableGridObjectsAt(position: position + Direction.left.toVector()) {
            adjacents.append(left)
        }
		return adjacents
	}
    
    static func getAllAdjacentGridObjectsAt(position: Vector) -> [GridObject] {
        var adjacents : [GridObject] = []
        adjacents.append(contentsOf: getAllGridObjectsAt(position: position + Direction.up.toVector()))
        adjacents.append(contentsOf: getAllGridObjectsAt(position: position + Direction.right.toVector()))
        adjacents.append(contentsOf: getAllGridObjectsAt(position: position + Direction.down.toVector()))
        adjacents.append(contentsOf: getAllGridObjectsAt(position: position + Direction.left.toVector()))
        return adjacents
    }

    static func isOutside(position: Vector) -> Bool {
        return maxGridPosition.x < position.x || maxGridPosition.y < position.y || 0 > position.x || 0 > position.y
    }
    
	static func advanceState() -> Bool {
		var modules : [Module] = []
		for gridObject in state {
            if let module = gridObject as? Module {
                modules.append(module)
            }
		}
        for module in modules {
            module.attemptActivateTrigger()
        }
        for module in modules {
            module.listenForTrigger()
        }
        for gridObject in state {
            gridObject.move()
        }
        currentTime += 1
        for gridObject in state {
            if let trigger = gridObject as? TriggerPad {
                trigger.setWillTriggerNextTick()
            }
        }
        let win = testForWin()
        if win {
            return win
        }
        return false
	}
    
    //Game is won when there are no more colors or sockets left
    static func testForWin() -> Bool {
        var isWin = true
        for gridObject in state {
            if gridObject is GridColorSocket || gridObject is GridColor {
                isWin = false
                break
            }
        }
        return isWin
    }
}
