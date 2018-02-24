/*
 Vector : CustomStringConvertible
 
 Description:
 Simple vector struct to handle position on a 2D grid
 Implements CustomStringConvertible so calling print(vectorBoy) prints x and y all formatted nicely
 
 Important things to know:
 this class supports common operators like + and -. Add more if needed, it isn't hard
 
*/
struct Vector : CustomStringConvertible{
	var x: Int
	var y: Int
    public var description: String {return "x: \(x), y: \(y)"}
	init(_ x: Int, _ y: Int) {
		self.x = x
		self.y = y
	}

	static func + (left: Vector, right: Vector) -> Vector {
		return Vector(left.x + right.x, left.y + right.y)
	}

	static func - (left: Vector, right: Vector) -> Vector {
		return Vector(left.x - right.x, left.y - right.y)
	}

	static func * (left: Vector, right: Int) -> Vector {
		return Vector(left.x * right, left.y * right)
	}

	static func * (left: Int, right: Vector) -> Vector {
		return Vector(left * right.x, left * right.y)
	}

	static func == (left: Vector, right: Vector) -> Bool {
		return left.x == right.x && left.y == right.y
	}
}
