extends Control
class_name InputManager

signal play_cards()
signal toggle_card_select(card: Card)
signal start_drag(card: Card)
signal end_drag()

func _ready() -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var node_found = Global.raycast()
				if node_found is Deck:
					Events.draw_card.emit(node_found)
				if node_found is Card:
					start_drag.emit(node_found)
					if node_found.is_selectible:
						toggle_card_select.emit(node_found)
				if node_found is PlayCardButton:
					play_cards.emit()
			else:
				end_drag.emit()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				var node_found = Global.raycast()
				if node_found is Deck:
					node_found.toggle_expand()
