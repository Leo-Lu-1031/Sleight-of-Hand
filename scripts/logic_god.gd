extends Control
class_name EnemyHandler

@onready var selection_timer: Timer = $SelectionTimer

# func(card: Card) -> bool: return ('jack' not in card.name and 'queen' not in card.name and 'king' not in card.name)

func autoplay(battle: Array[Combatant], combatant: Combatant):
	if not is_node_ready(): await ready
	var cards_played = combatant.combatant_resource.select_cards(battle)
	while (cards_played != []):
		for card in cards_played:
			selection_timer.start(0.1)
			await selection_timer.timeout
			card.is_selected = true
		cards_played = combatant.combatant_resource.select_cards(battle)
		
	selection_timer.start(0.5)
	await selection_timer.timeout
	var deck = combatant.zones[Global.zone_types.DECK]
	Events.draw_card.emit(deck)
