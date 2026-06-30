extends CardCollection
class_name Deck

const CARD_WIDTH = 130
const DECK_DISPLAY_COUNT = 5
@export var EXPANSION_DIRECTION = Vector2(-1,0)

var center_screen_x

var expanded = false

# Set by parent
func _ready() -> void:
	render()

func shuffle() -> void:
	card_array.shuffle()
	
func peek() -> Card:
	if len(card_array) == 0: return null
	return card_array[0]

func render() -> void:
	if len(card_array) == 0: return
	
	var tween = get_tree().create_tween()
	for i in range(len(card_array)):
		var card = card_array[i]
		
		var new_position
		if expanded:
			new_position = position + EXPANSION_DIRECTION * CARD_WIDTH * i
			card.get_node("Area2D/CollisionShape2D").disabled = false
		else:
			new_position = position - 20 * min(i,DECK_DISPLAY_COUNT-1) * Vector2(0, 1)
			card.get_node("Area2D/CollisionShape2D").disabled = true
			
		tween.tween_property(card,"position", new_position, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.set_parallel()	
		card.set_card_z_index(100*(1-i/len(card_array)))
		
		## Later target for optimization: Do not render cards at the bottom
		#if i < DECK_DISPLAY_COUNT + 1:
			#
		
func add_card(card: Card) -> void:
	card_array.insert(0, card)
	render()
	
func remove_card(card: Card) -> void:
	if card in card_array:
		card.get_node("Area2D/CollisionShape2D").disabled = false
		card_array.erase(card)
		render()
		
func toggle_expand() -> void:
	expanded = !expanded
	render()
	
func set_expand(expand: bool) -> void:
	expanded = expand
	render()

"""Unfinished - add update deck position here once done"""


	
"""Code that turns all the cards in the deck non interactable"""
"""Other code that allows to interact with the top of deck"""
"Update Deck looks when something changes"
"func draw card"


func _on_area_2d_mouse_entered() -> void:
	if len(card_array) > 0:
		var top: Card = card_array[0]
		top.emit_signal('hovered', top)

func _on_area_2d_mouse_exited() -> void:
	if len(card_array) > 0:
		var top: Card = card_array[0]
		top.emit_signal('hovered_off', top)
