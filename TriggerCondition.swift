enum TriggerCondition {
	case Time(initial: Int, repeatEvery: Int)
	case OnEnter
}