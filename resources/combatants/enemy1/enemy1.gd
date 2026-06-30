extends CombatantResource

# This enemy always draws cards
func select_cards(_battle: Array[Combatant]) -> Array[Card]:
	return []
