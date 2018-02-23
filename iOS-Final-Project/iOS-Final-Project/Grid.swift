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

	//If manipulating the return value of this does not change the original, this is gonna need some rethinking
	//Probably will involve passing state by reference everywhere, which would super suck
	static func getGridObjectAt(position: Vector) -> GridObject? {
		for gridObject in state {
            if gridObject.position == position && gridObject.hasHitbox {
                return gridObject
            }
        }
		return nil
	}

	static func getAdjacentGridObjectsAt(position: Vector) -> [GridObject] {
		var adjacents : [GridObject] = []
        if let up = getGridObjectAt(position: position + Vector(0, 1)) {
            adjacents.append(up)
        }
        if let right = getGridObjectAt(position: position + Vector(0, 1)) {
            adjacents.append(right)
        }
        if let down = getGridObjectAt(position: position + Vector(0, -1)) {
            adjacents.append(down)
        }
        if let left = getGridObjectAt(position: position + Vector(-1, 0)) {
            adjacents.append(left)
        }
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
            /*
             Big problem:
             This calls the Module definition of this, rather than the overridden definition like I'd like it to.
             In hindsight this is obviously what will happen, but I can't think of a way to do this that would involve horrible hardcoding.
             Gonna need to think on this one...
            */
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
