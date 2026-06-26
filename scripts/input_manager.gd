extends Node2D
class_name InputManager

var card_manager_reference: CardManager
var deck_reference: Deck
var hand_reference: Hand

func _ready() -> void:
	card_manager_reference = $"../PlayerHand/CardManager"
	deck_reference = $"../PlayerHand/Deck"
	hand_reference = $"../PlayerHand"
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card_found_in_deck = raycast()
			deck_reference.draw(card_found_in_deck)
		else:
			pass

func raycast() -> Card:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	var result = space_state.intersect_point(parameters)
	if result:
		if result[0].collider.collision_mask == Global.COLLISION_MASK_CARD:
			var card_found: Card = card_manager_reference.get_card_with_highest_z_index(result)
			if card_found in deck_reference.deck_array:
				return card_found
	return null
""" This is somewhat werid since we have decided to use a different structure for our decks- which means that detection for different masking layer is unneeded
I dont think that is too good
Also in the future I need to decide whihc functions should go to which scripts.
This is literally factorio where now every document is somewhat citing each other
"""
