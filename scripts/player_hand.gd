extends Node

const HAND_COUNT = 3

const CARD_SCENE_PATH = "res://scenes/card.tscn"
const CARDS_FOLDER_PATH = "res://assets/Cards_Folder/"
const CARD_WIDTH = 100
const HAND_Y_POS = 500

var player_hand = []
var center_screen_x

@onready var CardManager = $"../CardManager"

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2
'''
	var card_scene = preload(CARD_SCENE_PATH)
	var dir := DirAccess.open(CARDS_FOLDER_PATH)

	if dir == null:
		print("Could not open folder: ", CARDS_FOLDER_PATH)
		return
	var files := dir.get_files()
	var x := 0
	for file_name in files:
		if file_name.ends_with(".png"):
			var image_path := CARDS_FOLDER_PATH + file_name
			var texture := load(image_path)
			var card = card_scene.instantiate()
			#print("instantiated ", file_name)
			CardManager.add_child(card)
			card.name = file_name
			if player_hand.size() < HAND_COUNT:
				add_card_to_hand(card)
			
			card.set_card_texture(texture)
			card.position = Vector2(x * 120, 0)
			
		x += 1
'''

		
func add_card_to_hand(card):
	if card not in player_hand:
		player_hand.insert(0,card)
		update_hand_positions()
	else:
		animate_card_to_position(card,card.starting_position)
		

func update_hand_positions():
	for i in range(player_hand.size()):
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POS)
		var card = player_hand[i]
		card.starting_position = new_position
		animate_card_to_position(card, new_position)
			
		
func calculate_card_position(index):
	var total_width = player_hand.size() - 1*CARD_WIDTH
	var x_position = center_screen_x + index*CARD_WIDTH - total_width/2
	return x_position
	
func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card,"position", new_position, 0.1)

func remove_card_from_hand(card):
	if card in player_hand:
		player_hand.erase(card)
		update_hand_positions()
