extends CardCollection
class_name Hand

const HAND_COUNT = 3

@export var IS_AT_TOP = false
@export var SHOW_FRONT = false
@export var DECK_POS: Vector2

var center_screen_x
var hand_y_pos

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	var screen_size = get_viewport().size
	center_screen_x = screen_size.x / 2.0
	hand_y_pos = screen_size.y / 2.0 + (screen_size.y / 2.0 - 75 - Global.CARD_HEIGHT/2) * (1 if IS_AT_TOP else -1)

#@Override
func add_card(card: Card) -> void:
	if card is Card:
		if card not in card_array:
			card_array.insert(0,card)
			update_hand_positions()
			if !card.showing_front and SHOW_FRONT:
				card.show_front()
			if card.showing_front and !SHOW_FRONT:
				card.show_back()
		else:
			animate_card_to_position(card,card.starting_position)

func update_hand_positions() -> void:
	for i in range(card_array.size()):
		var new_position = Vector2(calculate_card_position(i), hand_y_pos)
		var card = card_array[i]
		print(self, card_array)
		card.starting_position = new_position
		animate_card_to_position(card, new_position)
		
func calculate_card_position(index: int) -> float:
	var total_width = (card_array.size() - 1)*Global.CARD_WIDTH
	var x_position = center_screen_x + index*Global.CARD_WIDTH - total_width/2.0
	return x_position
	
func animate_card_to_position(card: Card, new_position: Vector2) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(card,"position", new_position, 0.5).set_trans(Tween.TRANS_EXPO)

#@Override
func remove_card(card: Card) -> void:
	if card in card_array:
		card_array.erase(card)
		update_hand_positions()
