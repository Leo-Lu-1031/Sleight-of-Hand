extends CardCollection
class_name Deck

const CARD_WIDTH = 100

var center_screen_x
var deck_array = []
var hand_array = []

# Set by parent
var deck_position: Vector2

func set_deck_position(pos: Vector2) -> void:
	deck_position = pos
	position = pos
	for i in range(deck_array.size()):
		var card = deck_array[i]
		card.position = deck_position - 2 * min(i,10) * Vector2(0, 1)

func shuffle() -> void:
	deck_array.shuffle()
	
#func draw(card: Card) -> void:
	#hand_reference.add_card_to_hand(card)
	#remove_card_from_deck(card)

func remove_card_from_deck(card: Card) -> void:
	if card in deck_array:
		deck_array.erase(card)
"""Unfinished - add update deck position here once done"""


	
"""Code that turns all the cards in the deck non interactable"""
"""Other code that allows to interact with the top of deck"""
"Update Deck looks when something changes"
"func draw card"
