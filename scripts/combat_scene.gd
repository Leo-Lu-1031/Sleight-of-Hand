extends Node2D

@onready var player: Player = %Player

@onready var card_collection_manager: CardCollectionManager = $CardCollectionManager
@onready var input_manager: InputManager = $InputManager



var screen_dims: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_dims = get_viewport().size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = player.position - screen_dims / 2
