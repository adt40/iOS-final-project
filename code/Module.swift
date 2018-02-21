class Module : GridObject {
	var triggerActive = false
	
	//override in child if applicable
	func attemptActivateTrigger() {}

	func listenForTrigger() {
		let adjacents = Grid.getAdjacentGridObjectsAt(position: position);
		for gridLocation in adjacents {
			if let gridObject = gridLocation {
				if let module = gridObject as Module { //Attempt to cast (maybe replace with typeof? idk what the standard for doing this is)
					if module.triggerActive {
						performAction()
					}
				}
			}
		}
	}

	//override in child if applicable
	func performAction() {}
}
