extends CharacterBody2D

@export var max_speed = 5

var tracking_target: Node2D;

func limit_position(position_y: int) -> int:
	var new_position = position_y
	if abs(position.y - position_y) > max_speed:
		new_position = position.y - max_speed * (1 if (position.y - position_y) > 0 else -1)
	
	return min(max(new_position, -260), 260)

func _physics_process(delta: float) -> void:
	position.y = limit_position(tracking_target.position.y)


func _on_game_controller_reset(ball: Ball) -> void:
	tracking_target = ball
