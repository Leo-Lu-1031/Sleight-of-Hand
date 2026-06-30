extends Resource
class_name CardResource

@export_group("Card Attributes")
@export var texture: Texture2D
@export var tooltips: String

func is_eligible_cost(card: Card, caller: Card, currentCosts:Array[Card]) -> bool:
	return false
	
func is_eligible_target(card: Card, caller: Card, currentCosts: Array[Card], currentTargets: Array[Card]) -> bool:
	return false
	
func satisfies_cost(caller: Card, currentCosts: Array[Card]) -> bool:
	return true
	
func satisfies_target(caller: Card, currentTargets: Array[Card], currentCosts: Array[Card]) -> bool:
	return true

# Default card effect is to discard self and cost
func card_effects(caller: Card, costs: Array[Card], targets: Array[Card]):
	for cost in costs:
		Events.card_chown_requested.emit(cost, Global.zone_types.DISCARD)
	Events.card_chown_requested.emit(caller, Global.zone_types.DISCARD)
