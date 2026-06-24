extends Node2D

const CARD_SCENE_PATH = "res://scenes/card.tscn"
const CARDS_FOLDER_PATH = "res://assets/Cards_Folder/"
const CARD_WIDTH = 100

var center_screen_x
var player_deck = []
var player_hand = []
var deck_position_x = 150
var deck_position_y = 890
var player_hand_reference

@onready var CardManager = $"../CardManager"

	
func _ready() -> void:
	player_hand_reference = $"../PlayerHand"
	center_screen_x = get_viewport().size.x / 2
	
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
			CardManager.add_child(card)
			card.name = file_name
			
			player_deck.append(card.name)

			card.set_card_texture(texture)
			card.position = Vector2(deck_position_x, deck_position_y - x * 2)
		if x < 10:	
			x += 1
	shuffle()

func shuffle():
	player_deck.shuffle()


	
"""Code that turns all the cards in the deck non interactable"""
"""Other code that allows to interact with the top of deck"""
"Update Deck looks when something changes"
