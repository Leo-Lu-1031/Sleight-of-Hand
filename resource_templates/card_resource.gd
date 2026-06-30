extends Resource
class_name CardResource

@export_group("Card Attributes")
@export var texture: Texture2D
@export var tooltips: String

func is_eligible_target(card: Card) -> bool:
	return false
	
func is_eligible_cost(card: Card) -> bool:
	return false

func card_effects():
	pass
