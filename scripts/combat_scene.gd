extends Node2D

@onready var Player = %Player
var screen_dims: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_dims = get_viewport().size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = Player.position - screen_dims / 2
