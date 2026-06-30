extends Node2D
class_name PlayCardsButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.cards_playable.connect(
		func(playable):
			self.visible = playable
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
