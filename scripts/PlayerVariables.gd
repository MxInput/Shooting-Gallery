extends Node

var points := 0;
var game_last_played := "";
var high_score_hunting := 0;
var high_score_timed := 0;
var target_color := Color.WHITE;
var num_shot = {
	"WHITE_TARGET": 0,
	"COLORED_TARGET": 0,
	"RED_TARGET": 0,
	"YELLOW_DUCK": 0,
	"BROWN_DUCK": 0,
	"WHITE_DUCK": 0
}
var num_shot_ducks := 0;
var num_shot_targets := 0;
