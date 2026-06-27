extends Node2D
class_name CardCollectorManager

const CARD_SCENE_PATH = "res://scenes/card.tscn"
const CARDS_FOLDER_PATH = "res://assets/Cards_Folder/"

var card_manager: CardManager
var decks: Array[Deck]

var selected_cards: Array[Card]

# Temporary Solution
var hand_deck_correspondence = {
	'PlayerHand': 'PlayerDeck',
	'PlayerDeck': 'PlayerHand',
	'EnemyHand': 'EnemyDeck',
	'EnemyDeck': 'EnemyHand'
}

func chown(card: Card, newOwner: CardCollection) -> void:
	var prev = card.card_owner
	if prev:
		prev.remove_card(card)
	newOwner.add_card(card)

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
			var card: Card = card_scene.instantiate()
			#card.set_card_texture(texture)
			card.get_node('CardImg').texture = texture
			card.name = file_name

			card_manager.add_child(card)
			
			var deck_in = decks.pick_random()
			deck_in.add_card(card)
			card.card_owner = deck_in
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_input_manager_draw_card(deck: Deck) -> void:
	var card = deck.peek()
	if card:
		chown(card, get_node(hand_deck_correspondence[deck.name]))
		deck.set_expand(false)

func _on_input_manager_toggle_card_select(card: Card) -> void:
	if card.is_selected:
		card.set_select(false)
		selected_cards.erase(card)
	else:
		card.set_select(true)
		selected_cards.append(card)

func _on_input_manager_toggle_deck_expand(deck: Deck) -> void:
	deck.toggle_expand()
