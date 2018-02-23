/*
 Module : GridObject
 
 Description:
 GridObject that represents all the machine-like components the player can place into the grid
 
 Important things to know:
 This should not really be instantiated on its own (not sure how to enforce that)
 Rather, you should extend it in other classes where you implement either attemptActivateTrigger or performAction depending on the Module
 
*/

class Module : GridObject {
	var triggerActive = false
	
	//override in child if applicable
	func attemptActivateTrigger() {}

	func listenForTrigger() {
		let adjacents = Grid.getAllAdjacentGridObjectsAt(position: position)
		for gridObject in adjacents {
            if let module = gridObject as? Module {
                if module.triggerActive {
                    performAction()
                }
            }
        }
    }

	//override in child if applicable
	func performAction() {}
}
