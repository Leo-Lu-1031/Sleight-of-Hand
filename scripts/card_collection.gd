extends Node2D
class_name CardCollection

var card_array: Array[Card]
var character_id: int # Need better suggestions

#Override these
func add_card(card: Card):
	card_array.append(card)
	
func add_card_at(index: int, card: Card):
	card_array.insert(index, card)
	
func remove_card(card: Card):
	card_array.erase(card)
	
func render():
	return
