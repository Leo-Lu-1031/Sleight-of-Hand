extends Node

@export var card_scene = preload("res://card.tscn")
@export var cards_folder := "res://Cards_Folder/"

@onready var CardLogic = $"/root/Main/CardLogic"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_cards_from_folder()

func load_cards_from_folder():
	var dir := DirAccess.open(cards_folder)

	if dir == null:
		print("Could not open folder: ", cards_folder)
		return
	var files := dir.get_files()
	var x := 0
	for file_name in files:
		if file_name.ends_with(".png"):
			var image_path := cards_folder + file_name
			var texture := load(image_path)

			var card = card_scene.instantiate()
			print("instantiated ", file_name)
			CardLogic.add_child(card)

			card.set_card_texture(texture)
			card.position = Vector2(x * 120, 0)

		x += 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
