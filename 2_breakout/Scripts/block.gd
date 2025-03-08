extends StaticBody2D
class_name Block

@export var color: Color = Color.WHITE

signal destroyed(block: Block);

func _ready() -> void:
	$ColorRect.modulate = color

func hit() -> void:
	emit_signal("destroyed", self)
	queue_free()
