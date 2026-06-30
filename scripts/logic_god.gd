extends Control

signal update_selectibles
# emit_signal("update_selectibles", selectibles: func(Card): boolean)
# Tells CardManager what cards to mark as selectible
signal update_turn
# emit_signal("update_turn", current_turn: Deck)
# Tells CardCollectionManager whose turn it is
signal auto_play
# emit_signal("auto_play", auto_deck: Deck, cards_played: Array[Array[Cards]])
# Tells CardCollectionManager which enemy 
# wants to play cards and what they play
# ArrayArray because an enemy can first play one combo then another


# @NATHAN THIS IS YOUR PLAYGROUND
# FIRE AWAY
# IVE PUT SOME RUDIMENTARY TESTING CODE

var decks_in_play: Array[Deck]
var current_turn: int = 0

func enemy_play_logic(deck: Deck) -> Array[Card]:
	# Simple implementation where each enemy only draws;
	# Each play is separated by a null, so an attack followed by a defend is like
	# [Attack, Attack, null, Defend]
	return []

func _on_card_collection_manager_define_decks(decks: Array[Deck]) -> void:
	decks_in_play = decks
	emit_signal("update_turn", decks[0])
	if !decks[0].PLAYER_DRAWABLE:
		emit_signal("auto_play", decks[0], enemy_play_logic(decks[0]))

func _on_card_collection_manager_reset_selectible_cards(selected_cards: Array[Card]) -> void:
	# Simple implementation where all cards are selectible except for the face cards
	emit_signal("update_selectibles",
		func(card: Card) -> bool: return ('jack' not in card.name and 'queen' not in card.name and 'king' not in card.name))

func _on_card_collection_manager_end_turn(current_deck: Deck, card_drawn: Card) -> void:
	current_turn += 1
	current_turn %= len(decks_in_play)
	var current_turn_deck = decks_in_play[current_turn]
	emit_signal("update_turn", current_turn_deck)
	if !current_turn_deck.PLAYER_DRAWABLE:
		emit_signal("auto_play", current_turn_deck, enemy_play_logic(current_turn_deck))


func _on_card_collection_manager_played_cards(deck: Deck, played_cards: Array[Card]) -> void:
	pass # Replace with function body.
