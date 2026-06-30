extends Node
class_name TurnManager

var turn_count: int = 0
var combatants: Array[Combatant]

# This implementation will crumble and burn when combatants are added and removed
func _on_turn_end(combatant: Combatant):
	assert(combatants[turn_count] == combatant)
	turn_count = (turn_count + 1) % len(combatants)
	var next_combatant = combatants[turn_count]
	Events.turn_began.emit(next_combatant)
	print("Turn changed from ", combatant, " to ", next_combatant)
	
func _ready():
	Events.turn_ended.connect(_on_turn_end)
	await get_parent().ready
	Events.turn_began.emit(combatants[turn_count])
