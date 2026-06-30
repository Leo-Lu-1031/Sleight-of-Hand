extends Control
class_name CardCollectionManager

signal reset_selectible_cards
# Asks Logic God to recompute all cards' selectibility
signal define_decks
# Tells Logic God what decks are there
signal played_cards
# Tells Logic God what cards have been played and by whom 
# (A combatant is identified with a deck)
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

var zone_defs := {
	Global.zone_types.HAND: hand_scene, 
	Global.zone_types.DECK: deck_scene,
	Global.zone_types.DISCARD: discard_scene
}

func _ready() -> void:
	pass

func make_zone(zone_type: Global.zone_types, zone_owner: Combatant, cards: Array[Card] = []) -> CardCollection:
	var zone_scene: Resource = zone_defs[zone_type]
	var collection: CardCollection = zone_scene.instantiate()
	add_child(collection)
	
	collection.collection_owner = zone_owner
	collection.is_player = true
	return collection
	
# Moved functionality to CombatScene
#func initialize_characters(players,enemies) -> void: # Something about shadowing
	#var x = 0
	#for player in players: 
		#var player_zones: Dictionary[Global.zone_types, CardCollection]
		#for zone in Global.zone_types:
			#print(zone)
			#var zone_type: Resource = zone_defs[zone]
			#var collection: CardCollection = zone_defs[zone].instantiate()
			#add_child(collection)
			#
			#collection.character_id = x
			#collection.is_player = true
			#collection.zone_type = zone
			#collection.set_to_screen_position()
			#player_zones[zone] = collection
		#zones_by_character_id[x] = player_zones
		#x += 1
	#for enemy in enemies:
		#var enemy_zones = []
		#for zone in Global.zone_types.values():
			#var zone_type: Resource = zone_defs[zone]
			#var collection: CardCollection = zone_defs[zone].instantiate()
			#add_child(collection)
			#
			#collection.character_id = x
			#collection.is_player = false
			#collection.zone_type = zone
			#collection.set_to_screen_position()
			#enemy_zones.append(collection)
		#zones_by_character_id[x] = enemy_zones
		#x += 1
	#x = 0
	#print(zones_by_character_id)

func chown(card: Card, newOwner: CardCollection) -> void:
	var prev = card.card_owner
	if prev:
		prev.remove_card(card)
	newOwner.add_card(card)
	card.card_owner = newOwner
	
func draw_card(deck: Deck, hand: Hand) -> Card:
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

func _on_input_manager_toggle_card_select(card: Card) -> void:
	if card.is_selected:
		card.set_select(false)
		selected_cards.erase(card)
	else:
		card.set_select(true)
		selected_cards.append(card)
	reset_selectible_cards.emit(selected_cards)

func _on_logic_god_update_turn(deck: Deck) -> void:
	current_turn_deck = deck
