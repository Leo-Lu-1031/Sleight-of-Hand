extends RefCounted
class_name Combatant

var is_player: bool
var is_alive: bool = true

var combatant_resource: CombatantResource:
	set(new_resource):
		combatant_resource = new_resource
		is_player = combatant_resource.is_player

var zones: Dictionary[Global.zone_types, CardCollection]
