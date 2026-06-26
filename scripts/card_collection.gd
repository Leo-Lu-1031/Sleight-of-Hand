extends Node
class_name CardCollection

var card_array: Array[Card]

#Override this
func add_card(card: Card):
	card_array.append(card)
	
func remove_card(card: Card):
	card_array.erase(card)
