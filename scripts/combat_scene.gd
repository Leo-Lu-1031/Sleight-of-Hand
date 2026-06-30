extends Node2D

@onready var player: Player = %Player

@onready var card_collection_manager: CardCollectionManager = $CardCollectionManager
@onready var card_manager: CardManager = $CardManager
@onready var input_manager: InputManager = $InputManager
@onready var enemy_handler: EnemyHandler = $EnemyHandler


var screen_dims: Vector2

var combatants: Array[Combatant] = []
var turn_count: int = 0

func make_combatant(combatant_resource: CombatantResource) -> Combatant:
	if !is_node_ready(): await ready
	
	var combatant: Combatant = Combatant.new()
	combatant.combatant_resource = combatant_resource
	
	# Make the cards
	var card_resources: Array[CardResource] = combatant_resource.starting_cards
	var cards: Array[Card] = []
	for card_resource in card_resources:
		cards.append(card_manager.make_card(card_resource))
		
	# Make hand, deck, and discard piles
	for zone in Global.zone_types:
		combatant.zones[zone] = card_collection_manager.make_zone(
			zone, 
			combatant, 
			cards if zone == Global.zone_types.DECK else []
		)
	
	combatants.append(combatant)
	return combatant

func attempt_draw(deck: Deck) -> void:
	var current_combatant = combatants[turn_count]
	if current_combatant != deck.collection_owner: return
	card_collection_manager.draw_card(deck, current_combatant.zones[Global.zone_types.HAND])
	Events.turn_ended.emit(current_combatant)


func on_turn_begin(combatant: Combatant):
	if combatant.is_player: return
	enemy_handler.autoplay(combatants, combatant)

func on_turn_end(combatant: Combatant):
	assert(combatants[turn_count] == combatant)
	turn_count = (turn_count + 1) % len(combatants)
	var next_combatant = combatants[turn_count]
	Events.turn_began.emit(next_combatant)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_dims = get_viewport().size
	Events.draw_card.connect(attempt_draw)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position = player.position - screen_dims / 2
	
