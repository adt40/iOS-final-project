class Vector {
	var x: Int
	var y: Int
	init(_ x: Int, _ y: Int) {
		self.x = x
		self.y = y
	}

	static func + (left: Vector, right: Vector) -> {
		return Vector(left.x + right.x, left.y + right.y)
	}

	static func - (left: Vector, right: Vector) -> {
		return Vector(left.x - right.x, left.y - right.y)
	}

	static func * (left: Vector, right: Int) -> {
		return Vector(left.x * right, left.y * right)
	}

	static func * (left: Int, right: Vector) -> {
		return Vector(left * right.x, left * right.y)
	}

	static func == (left: Vector, right: Vector) -> {
		return Vector(left.x == right.x, left.y == right.y)
	}
}