/*
 Grid
 
 Description:
 Fingers crossed this works! Saves the state of the board into a static array
 
 Important things to know:
 state is an array of all GridObjects currently in the Grid.
 state is a 1D array, even though the grid itself is 2D. This is because the position of each GridObject is being tracked in the GridObject itself. This makes coding significantly easier, but it could lead to performance hits if a state gets huge. But that shouldn't happen so I'm sticking with this for now
 
*/


class Grid {
	static private var state : [GridObject] = []
    static private var maxGridPosition : Vector = Vector(0, 0)
	static var currentTime : Int = 0
	
    static func initialize(size: Vector) {
        maxGridPosition = Vector(size.x - 1, size.y - 1)
		currentTime = 0
	}
    
    static func addGridObject(gridObject: GridObject) {
        state.append(gridObject)
    }
    
    static func removeGridObject(gridObject: GridObject) {
        //oh boy this is kinda hard
    }
    
    static func getState() -> [GridObject]{
        return state
    }
    
    static func isGridObjectAt(position: Vector) -> Bool {
        for gridObject in state {
            if gridObject.position == position && gridObject.hasHitbox {
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
        if let up = getHittableGridObjectsAt(position: position + Vector(0, 1)) {
            adjacents.append(up)
        }
        if let right = getHittableGridObjectsAt(position: position + Vector(0, 1)) {
            adjacents.append(right)
        }
        if let down = getHittableGridObjectsAt(position: position + Vector(0, -1)) {
            adjacents.append(down)
        }
        if let left = getHittableGridObjectsAt(position: position + Vector(-1, 0)) {
            adjacents.append(left)
        }
		return adjacents
	}
    
    static func getAllAdjacentGridObjectsAt(position: Vector) -> [GridObject] {
        var adjacents : [GridObject] = []
        adjacents.append(contentsOf: getAllGridObjectsAt(position: position + Vector(0, 1)))
        adjacents.append(contentsOf: getAllGridObjectsAt(position: position + Vector(1, 0)))
        adjacents.append(contentsOf: getAllGridObjectsAt(position: position + Vector(0, -1)))
        adjacents.append(contentsOf: getAllGridObjectsAt(position: position + Vector(-1, 0)))
        return adjacents
    }

	static func advanceState() {
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
	}
}
