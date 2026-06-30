extends Node2D
class_name CardCollection

var card_array: Array[Card]
var character_id: int

var collection_owner: Combatant

var position_transformations := [
	[
		Vector2(960, 574),
		Vector2(880, 540),
		Vector2(1260, 574)
	],
	[
		Vector2(827, 574),
		Vector2(1040, 540),
		Vector2(500, 574)
	]
]

#LEO EDIT:
#changed indicator from string to an enum, defined in Global.gd
#bc labels are what enums are used for

#Override these

func set_to_screen_position() -> void:
	#position = position_transformations[character_id][zone_type]
	pass
	#FIXLATER
	
func add_card(card: Card):
	card_array.append(card)
	
func add_card_at(index: int, card: Card):
	card_array.insert(index, card)
	
func remove_card(card: Card):
	card_array.erase(card)
	
func render():
	return
