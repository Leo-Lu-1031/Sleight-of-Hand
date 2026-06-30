extends Node2D
class_name CardCollection

var card_array: Array[Card]
var character_id: int
var is_player: bool
var is_alive: bool = true
var zone_type : String # "deck", "hand", or "discard"
var position_transformations := [
	{"deck":Vector2(960, 574),"hand":Vector2(880, 540),"discard":Vector2(1260, 574)},
	{"deck":Vector2(827, 574),"hand":Vector2(1040, 540),"discard":Vector2(500, 574)}
]

#Override these

func set_to_screen_position() -> void:
	position = position_transformations[character_id][zone_type]
	
func add_card(card: Card):
	card_array.append(card)
	
func add_card_at(index: int, card: Card):
	card_array.insert(index, card)
	
func remove_card(card: Card):
	card_array.erase(card)
	
func render():
	return
