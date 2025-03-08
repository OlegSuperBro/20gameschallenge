extends CharacterBody2D
class_name Paddle


func limit_positions(position_x: int) -> int:
	return min(max(position_x, -460), 215)

func _physics_process(delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	position.x = limit_positions(mouse_position.x)
