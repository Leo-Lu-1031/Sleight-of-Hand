extends CardCollection
class_name Deck

const CARD_SCENE_PATH = "res://scenes/card.tscn"
const CARDS_FOLDER_PATH = "res://assets/Cards_Folder/"
const CARD_WIDTH = 100

var center_screen_x
var deck_array = []
var hand_array = []
@export var hand_reference: Hand

# Set by parent
var deck_position: Vector2

@onready var CardManager = $"../CardManager"

func set_deck_position(pos: Vector2) -> void:
	deck_position = pos
	position = pos
	for i in range(deck_array.size()):
		var card = deck_array[i]
		card.position = deck_position - 2 * min(i,10) * Vector2(0, 1)
	
func _ready() -> void:
	hand_reference = get_parent()
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
			
			deck_array.append(card)
			card.z_index = x

			card.set_card_texture(texture)
			card.position = - Vector2(0, min(x,0)*2)
			x += 1
			
	shuffle()

func shuffle() -> void:
	deck_array.shuffle()
	
func draw(card: Card) -> void:
	hand_reference.add_card_to_hand(card)
	remove_card_from_deck(card)

func remove_card_from_deck(card: Card) -> void:
	if card in deck_array:
		deck_array.erase(card)
"""Unfinished - add update deck position here once done"""


	
"""Code that turns all the cards in the deck non interactable"""
"""Other code that allows to interact with the top of deck"""
"Update Deck looks when something changes"
"func draw card"
