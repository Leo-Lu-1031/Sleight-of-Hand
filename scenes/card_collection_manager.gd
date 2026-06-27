extends Node2D
class_name CardCollectorManager

const CARD_SCENE_PATH = "res://scenes/card.tscn"
const CARDS_FOLDER_PATH = "res://assets/Cards_Folder/"

var card_manager: CardManager
var decks: Array[Deck]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	card_manager = $'../CardManager'
	decks = [$'EnemyDeck', $'PlayerDeck']
	
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
			card_manager.add_child(card)
			
			decks.pick_random().add_card(card)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
