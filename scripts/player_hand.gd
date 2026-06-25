extends Node
class_name Hand_Component

const HAND_COUNT = 3

const CARD_SCENE_PATH = "res://scenes/card.tscn"
const CARDS_FOLDER_PATH = "res://assets/Cards_Folder/"

@export var IS_AT_TOP = false
@export var SHOW_FRONT = false
@export var DECK_POS: Vector2

var player_hand = []
var center_screen_x
var hand_y_pos

@onready var CardManager = $"CardManager"
@onready var Deck = $"Deck"

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	var screen_size = get_viewport().size
	center_screen_x = screen_size.x / 2
	hand_y_pos = screen_size.y / 2 + (screen_size.y / 2 - 75 - Global.CARD_HEIGHT/2) * (1 if IS_AT_TOP else -1)
	Deck.set_deck_position(DECK_POS)
		
func add_card_to_hand(card):
	if card not in player_hand:
		player_hand.insert(0,card)
		update_hand_positions()
		if !card.showing_front and SHOW_FRONT:
			card.show_front()
	else:
		animate_card_to_position(card,card.starting_position)
		

func update_hand_positions():
	for i in range(player_hand.size()):
		var new_position = Vector2(calculate_card_position(i), hand_y_pos)
		var card = player_hand[i]
		card.starting_position = new_position
		animate_card_to_position(card, new_position)
		
		
func calculate_card_position(index):
	var total_width = (player_hand.size() - 1)*Global.CARD_WIDTH
	var x_position = center_screen_x + index*Global.CARD_WIDTH - total_width/2.0
	return x_position
	
func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card,"position", new_position, 0.5).set_trans(Tween.TRANS_EXPO)

func remove_card_from_hand(card):
	if card in player_hand:
		player_hand.erase(card)
		update_hand_positions()
