extends Control
class_name CardCollectionManager

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

func make_zone(zone_type: Global.zone_types, zone_owner: Combatant, cards: Array[Card]) -> CardCollection:
	var zone_scene: Resource = zone_defs[zone_type]
	var collection: CardCollection = zone_scene.instantiate()
	add_child(collection)
	
	collection.collection_owner = zone_owner
	for card in cards: 
		collection.add_card(card)
		card.card_owner = collection
	return collection


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

func _on_chown_requested(card: Card, to: Global.zone_types):
	var newOwner: CardCollection = card.card_owner.collection_owner.zones[to]
	chown(card, newOwner)
	
func _ready() -> void:
	Events.card_chown_requested.connect(_on_chown_requested)
