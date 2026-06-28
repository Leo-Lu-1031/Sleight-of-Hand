extends Node2D
class_name CardCollectorManager

signal reset_selectible_cards
# Asks Logic God to recompute all cards' selectibility
signal define_decks
# Tells Logic God what decks are there
signal played_cards
# Tells Logic God what cards have been played and by whom 
# (A force is identified with a deck)
signal end_turn
# Tells Logic God the current turn has ended and what card was drawn

const CARD_SCENE_PATH = "res://scenes/card.tscn"
const CARDS_FOLDER_PATH = "res://assets/Cards_Folder/"
const CARD_TOOLTIPS_PATH = "res://texts/card_hover_tooltips.json"

const HAND_SCENE_PATH = "res://scenes/hand.tscn"
const DECK_SCENE_PATH = "res://scenes/deck.tscn"
const DISCARD_SCENE_PATH = "res://scenes/discard.tscn"

var card_manager: CardManager
var decks: Array[Deck]
var current_turn_deck: Deck

var selected_cards: Array[Card]

var players: int
var enemies: int

# Temporary Solution

var character_by_id:= {}

# zones_by_character_id[current_character_id][zone_name] = zone

func _ready() -> void:
	initialize_characters(players, enemies)
	load_cards()

func initialize_characters(players,enemies): # Something about shadowing
	# There probably is a thousand ways to make this look more elegant
	var x = 0
	var hand_scene = preload(HAND_SCENE_PATH)
	var deck_scene = preload(DECK_SCENE_PATH)
	var discard_scene = preload(DISCARD_SCENE_PATH)
	for player in players: 
		# Here we should use a for loop
		# Instaniate, character_id, character_id dictionary, is_player	
		var hand: CardCollection = hand_scene.instantiate()
		var deck: CardCollection = deck_scene.instantiate()
		var discard: CardCollection = discard_scene.instantiate()
		hand.character_id = x
		deck.character_id = x
		discard.character_id = x
		hand.is_player = true
		deck.is_player = true
		discard.is_player = true
		character_by_id["player_hand_{id_num}".format({id_num = x})] = x
		character_by_id["player_deck_{id_num}".format({id_num = x})] = x
		character_by_id["player_discard_{id_num}".format({id_num = x})] = x
		x += 1
	for enemy in enemies:
		var hand: CardCollection = hand_scene.instantiate()
		var deck: CardCollection = deck_scene.instantiate()
		var discard: CardCollection = discard_scene.instantiate()
		hand.character_id = x
		deck.character_id = x
		discard.character_id = x
		hand.is_player = false
		deck.is_player = false
		discard.is_player = false
		x += 1
	x = 0

func load_cards():
	card_manager = $'../CardManager'
	decks = []
	for node in get_children():
		if node is Deck: decks.append(node)
	emit_signal("define_decks", decks)
	current_turn_deck = decks[0]
	var card_scene = preload(CARD_SCENE_PATH)
	var dir := DirAccess.open(CARDS_FOLDER_PATH)
	
	var tooltips_file = FileAccess.open(CARD_TOOLTIPS_PATH, FileAccess.READ)
	print(tooltips_file)
	var tooltips_str: String = tooltips_file.get_as_text()
	
	var tooltips: Dictionary = JSON.parse_string(tooltips_str)

	if dir == null:
		print("Could not open folder: ", CARDS_FOLDER_PATH)
		return
	var files := dir.get_files()
	var files_array: Array[String] = []
	for file_name in files: files_array.append(file_name)
	files_array.shuffle()
	
	for file_name in files_array:
		if file_name.ends_with(".png"):
			var image_path := CARDS_FOLDER_PATH + file_name
			var texture := load(image_path)
			var card: Card = card_scene.instantiate()
			#card.set_card_texture(texture)
			card.get_node('CardImg').texture = texture
			card.set_card_tooltips(
				tooltips[file_name] if file_name in tooltips else tooltips['default']
			)
			card.name = file_name

			card_manager.add_child(card)
			
			var deck_in = decks.pick_random()
			deck_in.add_card(card)
			card.card_owner = deck_in
			
	emit_signal("reset_selectible_cards", selected_cards)
	pass
	

func chown(card: Card, newOwner: CardCollection) -> void:
	var prev = card.card_owner
	if prev:
		prev.remove_card(card)
	newOwner.add_card(card)
	card.card_owner = newOwner
	
func draw_card(deck: Deck) -> Card:
	var card = deck.peek()
	if card:
		chown(card, get_node(hand_deck_correspondence[deck.name]))
		deck.set_expand(false)
	return card
	
func play_cards() -> void:
	for card in selected_cards:
		if not card: continue
		chown(card, $PlayerDiscard) # Lets keep it like this for now
		card.set_select(false)
		card.card_owner.remove_card(card)
	selected_cards = []
	emit_signal("reset_selectible_cards", selected_cards)
	
		
func animate_auto_turn(auto_deck: Deck, auto_selected: Array[Card]):
	assert(selected_cards == [])
	for card in auto_selected: 
		card.set_select(true)
	selected_cards = auto_selected
	play_cards()
	emit_signal("played_cards", auto_deck, auto_selected)
	# Ends turn after 1 second
	get_tree().create_tween().tween_callback(
		func (): 
			var card_drawn: Card = draw_card(auto_deck)
			emit_signal('end_turn', auto_deck, card_drawn)
	).set_delay(0.3)
	
	
func _on_input_manager_draw_card(deck: Deck) -> void:
	if deck != current_turn_deck: return
	var card_drawn: Card = draw_card(deck)
	selected_cards = []
	emit_signal("reset_selectible_cards", selected_cards)
	emit_signal('end_turn', deck, card_drawn)

func _on_input_manager_toggle_card_select(card: Card) -> void:
	if card.is_selected:
		card.set_select(false)
		selected_cards.erase(card)
	else:
		card.set_select(true)
		selected_cards.append(card)
	emit_signal("reset_selectible_cards", selected_cards)

func _on_input_manager_toggle_deck_expand(deck: Deck) -> void:
	deck.toggle_expand()

func _on_logic_god_update_turn(deck: Deck) -> void:
	current_turn_deck = deck

func _on_input_manager_play_cards() -> void:
	play_cards()

func _on_logic_god_auto_play(auto_deck: Deck, played_cards: Array[Card]) -> void:
	animate_auto_turn(auto_deck, played_cards)
