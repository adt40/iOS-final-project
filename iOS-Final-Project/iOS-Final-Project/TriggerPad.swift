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
		super.init(position: position, canMove: false, canEdit: true, hasHitbox: false, facingDirection: Direction.neutral, currentVelocity: (0, Direction.neutral))
	}
    
    init(position: Vector, triggerOnEnter: Bool, triggerOnTimeStart: Int, triggerOnTimeRepeat: Int) {
        self.triggerOnEnter = triggerOnEnter
        self.triggerOnTimeStart = triggerOnTimeStart
        self.triggerOnTimeRepeat = triggerOnTimeRepeat
        super.init(position: position, canMove: false, canEdit: true, hasHitbox: false, facingDirection: Direction.neutral, currentVelocity: (0, Direction.neutral))
    }
    
    func setTriggerParameters(triggerOnEnter: Bool, triggerOnTimeStart: Int, triggerOnTimeRepeat: Int) {
        self.triggerOnEnter = triggerOnEnter
        self.triggerOnTimeStart = triggerOnTimeStart
        self.triggerOnTimeRepeat = triggerOnTimeRepeat
    }
    
	override func attemptActivateTrigger() {
        if triggerOnEnter {
            if let _ = Grid.getHittableGridObjectsAt(position: position) {
                triggerActive = true
            } else {
                triggerActive = false
            }
        } else {
            //if currentTime is at initial time, or if repeat is nonzero and currentTime is at a repeat time
            if Grid.currentTime == triggerOnTimeStart || (triggerOnTimeRepeat != 0 && (Grid.currentTime - triggerOnTimeStart) % triggerOnTimeRepeat == 0) {
                triggerActive = true
            } else {
                triggerActive = false
            }
        }
	}
}
