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

var players:= 1
var enemies:= 1
var hand_scene: Resource = preload(HAND_SCENE_PATH)
var deck_scene: Resource = preload(DECK_SCENE_PATH)
var discard_scene: Resource = preload(DISCARD_SCENE_PATH)
'CONSISTENCY ISSUE 
what does character, zone, combatant etc each mean'

var zones_by_character_id = {}

'
var zones_by_character_id = {
	0: {
		"hand": Player0HandNode,
		"deck": Player0DeckNode,
		"discard": Player0DiscardNode
	}
}
'
var zone_defs := [hand_scene, deck_scene, discard_scene]

func _ready() -> void:
	initialize_characters(players, enemies)
	load_cards()

func initialize_characters(players,enemies) -> void: # Something about shadowing
	var x = 0
	for player in players: 
		var player_zones: Array[CardCollection]
		for zone in Global.card_collection_types.values():
			print(zone)
			var zone_type: Resource = zone_defs[zone]
			var collection: CardCollection = zone_defs[zone].instantiate()
			add_child(collection)
			
			collection.character_id = x
			collection.is_player = true
			collection.zone_type = zone
			collection.set_to_screen_position()
			player_zones.append(collection)
		zones_by_character_id[x] = player_zones
		x += 1
	for enemy in enemies:
		var enemy_zones = []
		for zone in Global.card_collection_types.values():
			var zone_type: Resource = zone_defs[zone]
			var collection: CardCollection = zone_defs[zone].instantiate()
			add_child(collection)
			
			collection.character_id = x
			collection.is_player = false
			collection.zone_type = zone
			collection.set_to_screen_position()
			enemy_zones.append(collection)
		zones_by_character_id[x] = enemy_zones
		x += 1
	x = 0
	print(zones_by_character_id)
	

func load_cards() -> void:
	card_manager = $'../CardManager'
	decks = []
	for node in get_children():
		if node is Deck: decks.append(node)
	emit_signal("define_decks", decks)
	current_turn_deck = decks[0]

	var card_scene = preload(CARD_SCENE_PATH)
	var dir := DirAccess.open(CARDS_FOLDER_PATH)
	
	var tooltips_file = FileAccess.open(CARD_TOOLTIPS_PATH, FileAccess.READ)
	#print(tooltips_file)
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
	
func draw_card(character_id: int) -> Card:
	var deck = zones_by_character_id[character_id]["deck"]
	var hand = zones_by_character_id[character_id]["hand"]
	var card = deck.peek()
	if card:
		chown(card, hand)
		deck.set_expand(false)
	return card
	
func play_cards() -> void:
	for card in selected_cards:
		if not card: continue
		var discard = zones_by_character_id[card.card_owner.character_id]["discard"]
		chown(card, discard)
		card.set_select(false)
		card.card_owner.remove_card(card)
	selected_cards = []
	emit_signal("reset_selectible_cards", selected_cards)
		
func animate_auto_turn(auto_character_id: int, auto_selected: Array[Card]):
	assert(selected_cards == [])
	for card in auto_selected: 
		card.set_select(true)
	selected_cards = auto_selected
	play_cards()
	var auto_deck = zones_by_character_id[auto_character_id]["deck"]
	emit_signal("played_cards", auto_deck, auto_selected)
	# Ends turn after 1 second
	get_tree().create_tween().tween_callback(
		func (): 
			var card_drawn: Card = draw_card(auto_character_id)
			emit_signal('end_turn', auto_deck, card_drawn)
	).set_delay(0.3)
	
	
func _on_input_manager_draw_card(character_id: int) -> void:
	var deck = zones_by_character_id[character_id]["deck"]

	# if deck != current_turn_deck: return FIX LATER
	var card_drawn: Card = draw_card(character_id)
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

func _on_logic_god_auto_play(auto_character_id: int, played_cards: Array[Card]) -> void:
	var auto_deck = zones_by_character_id[auto_character_id]["deck"]
	animate_auto_turn(auto_deck, played_cards)
