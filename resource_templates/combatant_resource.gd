extends Resource
class_name CombatantResource

@export var is_player: bool
@export var starting_cards: Array[CardResource]

func select_cards(_battle: Array[Combatant]) -> Array[Card]:
	return []
