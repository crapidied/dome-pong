import "dome" for Window, Process
import "input" for Keyboard
import "graphics" for Canvas, Color, Font

import "world" for World
import "actor" for Paddle, Ball, Midline, Score

class Game {
	static init() {
		Window.title = "pong"
		Window.resize(1024, 576)
		Canvas.resize(1024, 576)

		Font.load("font", "PressStart2P.ttf", 64)
		Canvas.font = "font"

		__game = World.new([
			Paddle.new(64, "w", "s"),
			Paddle.new(Canvas.width - 64 - 16, "up", "down"),
			Ball.new(),
			Midline.new(),
			Score.new()
		])
	}

	static update() {
		if (Keyboard["escape"].justPressed) {
			Process.exit()
		}

		__game.update()
	}

	static draw(alpha) {
		Canvas.cls()

		__game.draw(alpha)
	}
}