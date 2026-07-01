extends Node2D

@onready var player: Player = %Player

@onready var card_collection_manager: CardCollectionManager = $CardCollectionManager
@onready var card_manager: CardManager = $CardManager
@onready var input_manager: InputManager = $InputManager
@onready var turn_manager: TurnManager = $TurnManager
@onready var enemy_handler: EnemyHandler = $EnemyHandler

@onready var playerResource: CombatantResource = preload("res://resources/combatants/player/player.tres")
@onready var enemyResources: Array[CombatantResource] = [preload("res://resources/combatants/enemy1/enemy1.tres")]


var screen_dims: Vector2

var combatants: Array[Combatant] = []
var current_combatant: Combatant

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
	for zone in Global.zone_types.values():
		combatant.zones[zone] = card_collection_manager.make_zone(
			zone, 
			combatant, 
			cards if zone == Global.zone_types.DECK else ([] as Array[Card])
		)
	
	# Maker player hand show front
	if combatant.is_player:
		combatant.zones[Global.zone_types.HAND].SHOW_FRONT = true
	
	combatants.append(combatant)
	reposition_combatants()
	return combatant
	
func reposition_combatants():
	if !is_node_ready(): await ready
	
	var players: Array[Combatant] = combatants.filter(func(c): return c.is_player)
	var enemies: Array[Combatant] = combatants.filter(func(c): return !c.is_player)
	
	for i in range(len(players)):
		var combatant: Combatant = players[i]
		var positions = {
			Global.zone_types.DECK: 
				screen_dims / 2.0 + Vector2(-Global.CARD_WIDTH, Global.CARD_HEIGHT * (i+1)),
			Global.zone_types.DISCARD:
				screen_dims / 2.0 + Vector2(Global.CARD_WIDTH, Global.CARD_HEIGHT * (i+1)),
			Global.zone_types.HAND:
				Vector2(screen_dims.x * (i+1)/(len(players)+1), screen_dims.y - Global.CARD_HEIGHT)
		}
		for zone in Global.zone_types.values():
			combatant.zones[zone].position = positions[zone]
			combatant.zones[zone].render()
			
	for i in range(len(enemies)):
		var combatant: Combatant = enemies[i]
		var positions = {
			Global.zone_types.DECK: 
				screen_dims / 2.0 + Vector2(-Global.CARD_WIDTH, -Global.CARD_HEIGHT * (i+1)),
			Global.zone_types.DISCARD:
				screen_dims / 2.0 + Vector2(Global.CARD_WIDTH, -Global.CARD_HEIGHT * (i+1)),
			Global.zone_types.HAND:
				Vector2(screen_dims.x * (i+1)/(len(players)+1),  Global.CARD_HEIGHT)
		}
		for zone in Global.zone_types.values():
			combatant.zones[zone].position = positions[zone]
			combatant.zones[zone].render()

func attempt_draw(deck: Deck) -> void:
	if current_combatant != deck.collection_owner: return
	card_collection_manager.draw_card(deck, current_combatant.zones[Global.zone_types.HAND])
	Events.turn_ended.emit(current_combatant)

func _on_turn_begin(combatant: Combatant):
	current_combatant = combatant
	if combatant.is_player: return
	enemy_handler.autoplay(combatants, combatant)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_dims = get_viewport().size
	Events.draw_card.connect(attempt_draw)
	Events.turn_began.connect(_on_turn_begin)
	
	make_combatant(playerResource)
	make_combatant(enemyResources[0])
	
	turn_manager.combatants = combatants
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position = player.position - screen_dims / 2
	
# BALABALATRO
