/*
 TriggerPad : Module
 
 Description:
 This is the module that broadcasts a trigger on certain states
 
 Important things to know:
 triggerOnEnter, triggerOnTimeStart, and triggerOnTimeRepeat are the options that will be available in the GUI
 set triggerOnTimeRepeat to 0 if you don't want it to repeat
 
*/
class TriggerPad : Module {
    var triggerOnEnter : Bool
    
    //These might have to be optionals
    var triggerOnTimeStart : Int
    var triggerOnTimeRepeat : Int //0 for no repetition
    
	init(position: Vector) {
		triggerOnEnter = false
        triggerOnTimeStart = 0
        triggerOnTimeRepeat = 0
		super.init(position: position, canMove: false, hasHitbox: false, facingDirection: Vector(1, 0), currentVelocity: (0, Vector(1, 0)))
	}
    
    init(position: Vector, onEnter: Bool, startAt: Int, repeatAt: Int) {
        triggerOnEnter = onEnter
        triggerOnTimeStart = startAt
        triggerOnTimeRepeat = repeatAt
        super.init(position: position, canMove: false, hasHitbox: false, facingDirection: Vector(1, 0), currentVelocity: (0, Vector(1, 0)))
    }

	override func attemptActivateTrigger() {
        if triggerOnEnter {
            if let _ = Grid.getHittableGridObjectsAt(position: position) {
                triggerActive = true
            }
        } else {
            //if currentTime is at initial time, or if repeat is nonzero and currentTime is at a repeat time
            if Grid.currentTime == triggerOnTimeStart || (triggerOnTimeRepeat != 0 && (Grid.currentTime - triggerOnTimeStart) % triggerOnTimeRepeat == 0) {
                triggerActive = true
            }
        }
	}
}
