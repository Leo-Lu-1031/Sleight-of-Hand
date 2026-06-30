extends CardResource

func is_eligible_cost(card: Card, caller: Card, currentCosts:Array[Card]) -> bool:
	var owner = card.card_owner
	return owner == caller.card_owner and len(currentCosts) == 0
	
func is_eligible_target(card: Card, caller: Card, currentCosts: Array[Card], currentTargets: Array[Card]) -> bool:
	var owner = card.card_owner
	return owner.collection_owner != caller.card_owner.collection_owner and owner.collection_owner.zones[Global.zone_types.HAND] == owner and len(currentTargets) == 0
	
func satisfies_cost(caller: Card, currentCosts: Array[Card]) -> bool: 
	return len(currentCosts) == 1
	
func satisfies_target(caller: Card, currentCosts: Array[Card], currentTargets: Array[Card]) -> bool:
	return len(currentTargets) == 1

# Default card effect is to discard self and cost
func card_effects(caller: Card, costs: Array[Card], targets: Array[Card]):
	for cost in costs:
		Events.card_chown_requested.emit(cost, Global.zone_types.DISCARD)
	for target in targets:
		Events.card_chown_requested.emit(target, Global.zone_types.DISCARD)
	Events.card_chown_requested.emit(caller, Global.zone_types.DISCARD)
