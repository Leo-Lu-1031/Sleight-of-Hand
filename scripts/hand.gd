extends CardCollection
class_name Hand

const HAND_COUNT = 3
const CARD_MARGINS = 20

@export var SHOW_FRONT = false

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	render()

#@Override
func add_card(card: Card) -> void:
	if card is Card:
		card_array.insert(0,card)
		if !card.showing_front and SHOW_FRONT:
			card.show_front()
		if card.showing_front and !SHOW_FRONT:
			card.show_back()
		render()

func render() -> void:
	if len(card_array) == 0: return
	
	var tween = get_tree().create_tween()
	for i in range(len(card_array)):
		var card = card_array[i]
		var new_position = calculate_card_position(i)
			
		tween.tween_property(card,"position", new_position, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.set_parallel()	
		
func calculate_card_position(index: int) -> Vector2:
	var total_width = (card_array.size() - 1)*(Global.CARD_WIDTH+CARD_MARGINS)
	var x_position = index*(Global.CARD_WIDTH+CARD_MARGINS) - total_width/2.0
	return position + Vector2(x_position, 0)

#@Override
func remove_card(card: Card) -> void:
	if card in card_array:
		card_array.erase(card)
		render()
