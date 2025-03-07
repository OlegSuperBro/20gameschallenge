extends CharacterBody2D

func limit_position(position_y: int) -> int:
	return min(max(position_y, -260), 260)
	

func _physics_process(delta: float) -> void:
	var mouse_possition = get_global_mouse_position()
	position.y = limit_position(mouse_possition.y)
