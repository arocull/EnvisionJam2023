extends Control

func _ready():
	GameManager.connect("earn_score", show_score)

func show_score(newScore: float):
	$score_screen/Score.text = str(newScore)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameManager.phase == GameManager.PHASE.Results:
		$score_screen.visible = true
	else:
		$score_screen.visible = false
	
	$countdown.text = str(ceilf(GameManager.timer))
