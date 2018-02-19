class Grid {
	static var state : [GridObject?]
	static var currentTime : Int
	
	static func init(x: Int, y: Int) {
		state = Array(repeating: nil, count: x * y)
		currentTime = 0
	}

	static func getGridObjectAt(position: Vector) -> GridObject? {
		for gridLocation in state {
			if let gridObject = gridLocation {
				if gridObject.position == position && gridObject.hasHitbox {
					return gridObject
				}
			}
		}
		return nil
	}

	static func getAdjacentGridObjectsAt(position: Vector) -> [GridObject?] {
		var adjacents : [GridObject?] = []
		adjacents.append(getGridObjectAt(position + Vector(0, 1)))
		adjacents.append(getGridObjectAt(position + Vector(1, 0)))
		adjacents.append(getGridObjectAt(position + Vector(0, -1)))
		adjacents.append(getGridObjectAt(position + Vector(-1, 0)))
		return adjacents
	}

	static func advanceState() {
		var gridObjects : [GridObject] = []
		var modules : [Module] = []
		for gridLocation in state {
			if let gridObject = gridLocation {
				gridObjects.append(gridObject)
				if let module = Module(gridObject) { //see Module.swift comment on same line
					modules.append(module)
				}
			}
		}

		for module in modules {
			module.attemptActivateTrigger()
		}
		for module in modules {
			module.listenForTrigger()
		}
		for gridObject in gridObjects {
			gridObject.move()
		}
	}
}