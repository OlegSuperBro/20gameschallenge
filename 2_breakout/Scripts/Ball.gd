extends CharacterBody2D

class_name Ball

@export var default_speed: int = 200;
@export var speed_increase_on_break: int = 5
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

func check_collisions() -> void:
	var collision = get_last_slide_collision()

	var collider = collision.get_collider()

	if collider is Paddle:
		var on_paddle_position: Vector2 = collider.to_local(position)
		
		current_direction = current_direction ^ (Directions.UP | Directions.DOWN)
		if on_paddle_position.x > -5 and on_paddle_position.x < 5:
			return
		elif on_paddle_position.x < -5:
			current_direction = (current_direction & (Directions.UP | Directions.DOWN)) | Directions.LEFT
		elif on_paddle_position.x > 5:
			current_direction = (current_direction & (Directions.UP | Directions.DOWN)) | Directions.RIGHT

	else:
		var collision_angle = int(round(rad_to_deg(collision.get_angle())))
		
		if collision_angle in [0, 180]:
			current_direction = current_direction ^ (Directions.UP | Directions.DOWN)
		elif collision_angle == 90:
			current_direction = current_direction ^ (Directions.LEFT | Directions.RIGHT)

		if collision.get_collider() is Block:
			(collision.get_collider() as Block).hit()
			current_speed += speed_increase_on_break

		if audio_player:
			audio_player.play()
		
		return

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
		check_collisions()
