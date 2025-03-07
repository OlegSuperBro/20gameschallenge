extends CharacterBody2D

class_name Ball

@export var default_speed: int = 200;
@export var bounce_speed_increase: int = 50;
@export var audio_player: AudioStreamPlayer2D;
@export_flags("LEFT", "RIGHT", "UP", "DOWN") var default_direction: int = 0b1001

enum Directions {
	LEFT = 1 << 0,
	RIGHT = 1 << 1,
	UP = 1 << 2,
	DOWN = 1 << 3,
}

var current_speed = 0;
var current_direction = 0;

func _ready():
	current_speed = default_speed;
	current_direction = default_direction;

func has_flag(value: int, flag: Directions) -> bool:
	return value & flag

func check_collisions() -> int:
	var collision = get_last_slide_collision()
	var collision_angle = int(round(rad_to_deg(collision.get_angle())))
	
	if collision_angle in [0, 180]:
		current_direction = current_direction ^ 0b1100
	elif collision_angle == 90:
		current_direction = current_direction ^ 0b0011
	
	if audio_player:
		audio_player.play()
	
	return -1 if collision_angle != 90 else 1

func _physics_process(delta: float) -> void:
	var result_velocity = Vector2.ZERO;
	
	if has_flag(current_direction, Directions.LEFT):
		result_velocity.x -= current_speed
	if has_flag(current_direction, Directions.RIGHT):
		result_velocity.x += current_speed
	if has_flag(current_direction, Directions.UP):
		result_velocity.y -= current_speed
	if has_flag(current_direction, Directions.DOWN):
		result_velocity.y += current_speed

	velocity = result_velocity

	var collided = move_and_slide()
	if collided:
		if check_collisions() == 1:
			current_speed += bounce_speed_increase
