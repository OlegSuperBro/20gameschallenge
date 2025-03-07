extends Node

@export var scored_audio_player: AudioStreamPlayer2D; 
@export var ball_scene: PackedScene;

var ball_instance: Ball;

@export var left_score_label: Label;
@export var right_score_label: Label;
var left_score: int;
var right_score: int;

signal reset(ball: Ball);

func reset_game() -> void:
	if ball_instance != null:
		ball_instance.free()

	ball_instance = ball_scene.instantiate()

	get_parent().add_child.call_deferred(ball_instance)
	emit_signal("reset", ball_instance)

func _ready() -> void:
	update_score_text()
	reset_game()

func update_score_text() -> void:
	left_score_label.text = str(left_score)
	right_score_label.text = str(right_score)

func _on_left_area_body_entered(body: Node2D) -> void:
	right_score += 1
	scored_audio_player.play()
	update_score_text()
	reset_game()

func _on_right_area_body_entered(body: Node2D) -> void:
	left_score += 1
	scored_audio_player.play()
	update_score_text()
	reset_game()
