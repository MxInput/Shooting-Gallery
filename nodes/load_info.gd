extends Node

@export var timed_high_score : RichTextLabel;
@export var hunting_high_score : RichTextLabel;
@export var last_played : RichTextLabel;

func _ready() -> void:
	timed_high_score.text = "High Score (Timed): " + str(PlayerVariables.high_score_timed) + " points";
	hunting_high_score.text = "High Score (Hunting): " + str(PlayerVariables.high_score_hunting) + " points";
	if (PlayerVariables.game_last_played == ""):
		last_played.text = "No games played yet.";
	else:
		last_played.text = "Score in last played game (" + PlayerVariables.game_last_played + "): " + str(PlayerVariables.points) + " points";
