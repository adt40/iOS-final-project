class TriggerPad : Module {
	var triggerCondition : TriggerCondition

	init(position: Vector) {
		triggerCondition = .Time(initial: 0, repeat: 0)
		super.init(position: position, canMove: false, hasHitbox: false, currentVelocity: (0, Vector(1, 0)))
	}

	override func attemptActivateTrigger() {
		if triggerCondition == .OnEnter {
			if let gridObject = Grid.getGridObjectAt(position: position) {
				triggerActive = true
			}
		} else {
			//if currentTime is at initial time, or if repeat is nonzero and currentTime is at a repeat time
			if currentTime = triggerCondition.initial || (triggerCondition.repeat != 0 && (currentTime - triggerCondition.initial) % triggerCondition.repeat) {
				triggerActive = true
			}
		}
	}
}