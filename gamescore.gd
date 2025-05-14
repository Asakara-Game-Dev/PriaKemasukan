extends Node

var score = 0
@onready var score_label = $score_label
func add_point():
	score += 1
	score_label.text = "Luwh Dapet " + str(score) + " koin."
