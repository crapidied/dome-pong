import "math" for Vector
import "graphics" for Canvas

import "action" for Movement, Input, Bounce, Collision,
UpdateScore, DrawRectangle, DrawMidline, DrawScore

class Actor {
	reset() {}

	update { _update || [] }
	draw { _draw || [] }

	update=(value) { _update = value }
	draw=(value) { _draw = value }
}

class GameObject is Actor {
	construct new(x, y, width, height, speed, xDirection, yDirection) {
		_x = x
		_y = y
		_width = width
		_height = height

		_speed = speed
		_direction = Vector.new(xDirection, yDirection)

		update = [
			Movement
		]

		draw = [
			DrawRectangle
		]
	}

	x { _x }
	y { _y }
	width { _width }
	height { _height }
	speed { _speed }
	direction { _direction }

	x=(value) { _x = value }
	y=(value) { _y = value }
	speed=(value) { _speed = value }
}

class Paddle is GameObject {
	construct new(x, upKey, downKey) {
		super(x, 0, 16, 96, 20, 0, 0)

		_upKey = upKey
		_downKey = downKey

		update.add(Input)
	}

	reset() {
		y = 0
	}

	upKey { _upKey }
	downKey { _downKey }
}

class Ball is GameObject {
	construct new() {
		super(Canvas.width / 2 - 8, Canvas.height / 2 - 8, 16, 16, 5, -1, 0)

		_hasCollided = false

		update.add(Bounce)
		update.add(Collision)
	}

	reset() {
		x = Canvas.width / 2 - width / 2
		y = Canvas.height / 2 - height / 2
		direction.y = 0
		speed = 5
		hasCollided = false
	}


	hasCollided { _hasCollided }

	hasCollided=(value) { _hasCollided = value }
}

class Midline is Actor {
	construct new() {
		draw = [
			DrawMidline
		]
	}

	width { 4 }
	segments { 8 }
}

class Score is Actor {
	construct new() {
		_left = 0
		_right = 0
		_gameOver = false

		update = [
			UpdateScore
		]

		draw = [
			DrawScore
		]
	}

	reset() {
		_left = 0
		_right = 0
		_gameOver = false
	}

	left { _left }
	right { _right }
	pointsToWin { 2 }
	gameOver { _gameOver }

	left=(value) { _left = value }
	right=(value) { _right = value }
	gameOver=(value) { _gameOver = value }
}