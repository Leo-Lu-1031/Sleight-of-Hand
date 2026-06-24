extends Node

const HAND_COUNT = 3

const CARD_SCENE_PATH = "res://scenes/card.tscn"
const CARDS_FOLDER_PATH = "res://assets/Cards_Folder/"

@onready var CardManager = $"../CardManager"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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

			card.set_card_texture(texture)
			card.position = Vector2(x * 120, 0)

		x += 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
