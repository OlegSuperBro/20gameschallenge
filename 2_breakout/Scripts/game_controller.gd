extends Node

@export var ui_container: Control;
@export var ball_scene: PackedScene;
@export var default_lives: int = 3;
@export var live_scene: PackedScene;

var total_score: int = 0
var lives: int = 0;

var parent: Node;

var score_label: Label;
var lives_container: Container;
var ball_instance: Ball;


func _enter_tree() -> void:
	lives = default_lives

	parent = get_parent()

	score_label = ui_container.find_child("Score")
	lives_container = ui_container.find_child("Lives")

	ball_instance = instantiace_ball()

	update_score()
	update_lives()

func instantiace_ball() -> Ball:
	return

func update_score():
	score_label.text = "%010d" % total_score

func update_lives():
	for child in lives_container.get_children():
		lives_container.remove_child(child)
	
	for i in range(lives):
		var live_instance = live_scene.instantiate()
		lives_container.add_child(live_instance)

func _on_block_field_block_destroyed() -> void:
	total_score += 100
	update_score()


func game_over() -> void:
	(parent.find_child("GameOver") as Control).visible = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if ball_instance:
		ball_instance.queue_free()

	lives -= 1
	
	if lives < 0:
		game_over()
		return

	ball_instance = ball_scene.instantiate()
	parent.add_child(ball_instance)
	update_lives()


func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
