class World {
	construct new(actors) {
		_actors = actors
	}

	update() {
		for (actor in _actors) {
			for (action in actor.update) {
				if (action.arity == 1) {
					action.call(actor)
				} else {
					action.call(actor, this)
				}
			}
		}
	}

	draw(alpha) {
		for (actor in _actors) {
			for (action in actor.draw) {
				if (action.arity == 2) {
					action.call(alpha, actor)
				} else {
					action.call(alpha, actor, this)
				}
			}
		}
	}

	reset() {
		for (actor in _actors) {
			actor.reset()
		}
	}

	actors { _actors }
}