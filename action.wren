import "math" for Math, Vector
import "input" for Keyboard
import "graphics" for Canvas, Color

var Movement = Fn.new {|actor|
	actor.direction.x = Math.min(actor.direction.x, 1)
	actor.direction.y = Math.min(actor.direction.y, 1)

	actor.x = actor.x + actor.speed * actor.direction.unit.x
	actor.y = actor.y + actor.speed * actor.direction.unit.y

	actor.y = Math.max(actor.y, 0)
	actor.y = Math.min(actor.y, Canvas.height - actor.height)
}

var Input = Fn.new {|actor|
	actor.direction.y = 0

	if (Keyboard[actor.upKey].down) {
		actor.direction.y = actor.direction.y - 1
	}
	if (Keyboard[actor.downKey].down) {
		actor.direction.y = actor.direction.y + 1
	}
}

var Bounce = Fn.new {|actor|
	if (actor.y == 0 || actor.y == Canvas.height - actor.height) {
		actor.direction.y = -actor.direction.y
	}
}

var Collision = Fn.new {|actor, world|
	for (other in world.actors) {
		if (other.toString == "instance of Paddle") {
			if (actor.x < other.x + other.width && actor.x + actor.width > other.x &&
			actor.y < other.y + other.height && actor.y + actor.height > other.y) {
				if (!actor.hasCollided) {
					actor.speed = 15
					actor.hasCollided = true
				}

				var xPenetration
				var yPenetration

				if (actor.x + actor.width < other.x + other.width) {
					xPenetration = other.x - (actor.x + actor.width)
				} else {
					xPenetration = other.x + other.width - actor.x
				}
				if (actor.y + actor.height < other.y + other.height) {
					yPenetration = other.y - (actor.y + actor.height)
				} else {
					yPenetration = other.y + other.height - actor.y
				}

				if (Math.abs(xPenetration) < Math.abs(yPenetration)) {
					actor.direction.x = -actor.direction.x
					actor.direction.y = ((actor.y + actor.height / 2) - (other.y + other.height / 2)) / (other.height / 2)
				} else {
					actor.direction.y = actor.direction.y * (yPenetration / Math.abs(yPenetration))
				}
			}
		}
	}
}

var UpdateScore = Fn.new {|actor, world|
	for (other in world.actors) {
		if (other.toString == "instance of Ball") {
			if (actor.left < actor.pointsToWin && actor.right < actor.pointsToWin) {
				if (other.x + other.width < -128) {
					actor.right = actor.right + 1

					if (actor.right < actor.pointsToWin) {
						other.reset()
					}
				} else if (other.x > Canvas.width + 128) {
					actor.left = actor.left + 1

					if (actor.left < actor.pointsToWin) {
						other.reset()
					}
				}
			} else {
				actor.gameOver = true
			}
		}

		if (actor.gameOver) {
			if (other.type.supertype.toString == "GameObject") {
				for (i in 0...other.update.count) {
					if (other.update[i] == Movement) {
						other.update.removeAt(i)
						break
					}
				}
			}
		}
	}

	if (actor.gameOver && Keyboard["space"].justPressed) {
		for (other in world.actors) {
			if (other.type.supertype.toString == "GameObject") {
				other.update.add(Movement)
			}

			world.reset()
		}
	}
}

var DrawRectangle = Fn.new {|alpha, actor|
	Canvas.rectfill(actor.x, actor.y, actor.width, actor.height, Color.white)
}

var DrawMidline = Fn.new {|alpha, actor|
	var x = Canvas.width / 2 - actor.width / 2
	var width = actor.width
	var height = Canvas.height / actor.segments / 2

	for (i in 0...actor.segments) {
		var y = Canvas.height / actor.segments * i

		Canvas.rectfill(x, y, width, height, Color.white)
	}
}

var DrawScore = Fn.new {|alpha, actor|
	Canvas.print(actor.left, Canvas.width / 4 - 32, 32, Color.white)
	Canvas.print(actor.right, Canvas.width / (4 / 3) - 32, 32, Color.white)

	if (actor.gameOver) {
		if (actor.left > actor.right) {
 			Canvas.print("Left Wins!", Canvas.width / 4 - 64, Canvas.height / 2 - 16, Color.white)
		} else {
 			Canvas.print("Right Wins!", Canvas.width / 4 - 88, Canvas.height / 2 - 16, Color.white)
		}
	}
}