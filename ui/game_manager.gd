extends Control

enum PHASE {
	Startup,
	Game,
	Results,
}

signal enter_phase(newPhase: int)
signal earn_score(score: float)

var timer: float = 3
var lastScore: float = 0
var phase: int = PHASE.Startup

func _process(delta):
	timer -= delta
	
	if timer <= 0:
		switchPhase()

func switchPhase():
	match phase:
		PHASE.Startup:
			timer = 15
			phase = PHASE.Game
		PHASE.Game:
			timer = 3
			phase = PHASE.Results
			emit_signal("earn_score", get_tree().current_scene.score())
		PHASE.Results:
			timer = 3
			phase = PHASE.Startup
			get_tree().reload_current_scene()
	emit_signal("enter_phase", phase)
