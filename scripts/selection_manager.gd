extends Node
class_name SelectionManager

@onready var card_manager: CardManager = $"../CardManager"
@onready var input_manager: InputManager = $"../InputManager"

enum stages {NONE, COST, TARGET}

var primary_card: Card = null
var cost_cards: Array[Card] = []
var target_cards: Array[Card] = []
var current_stage: stages:
	set(stage):
		current_stage = stage
		match stage:
			stages.NONE:
				Events.cards_playable.emit(false) 
			stages.COST:
				Events.cards_playable.emit(false)
			stages.TARGET:
				var target_satisfied: bool = primary_card.card_resource.satisfies_target(primary_card, cost_cards,target_cards)
				Events.cards_playable.emit(target_satisfied) 

# BAD BC MULTIPLE SOURCES OF TRUTH BUT MEH
var current_combatant: Combatant

func try_advance_stage():
	match current_stage:
		stages.NONE:
			#Triggers setter explicitly; this is quite a bad solution
			current_stage = stages.NONE
			
			if !primary_card: return
			current_stage = stages.COST
			try_advance_stage()
		stages.COST:
			current_stage = stages.COST
			if !(primary_card.card_resource.satisfies_cost(primary_card, cost_cards)): return
			current_stage = stages.TARGET
			try_advance_stage()
		stages.TARGET: 
			current_stage = stages.TARGET

func _on_card_select_toggle(card: Card):
	var state = card.selection_state
	match state:
		Global.select_types.UNSELECTIBLE:
			return
		Global.select_types.NONE:
			match current_stage:
				stages.NONE:
					primary_card = card
					card.selection_state = Global.select_types.PRIMARY
					try_advance_stage()
				stages.COST:
					cost_cards.append(card)
					card.selection_state = Global.select_types.COST
					try_advance_stage()
				stages.TARGET:
					target_cards.append(card)
					card.selection_state = Global.select_types.TARGET
					try_advance_stage()
		_:
			for c in target_cards: c.selection_state = Global.select_types.NONE
			target_cards = []
			current_stage = stages.TARGET
			if card in cost_cards or card == primary_card:
				for c in cost_cards: c.selection_state = Global.select_types.NONE
				cost_cards = []
				current_stage = stages.COST
				if card == primary_card:
					primary_card = null
					current_stage = stages.NONE
			card.selection_state = Global.select_types.NONE
			try_advance_stage()
	
	match current_stage:
		stages.NONE:
			# THIS IS COPIUM, multiple sources of truth
			var current_combatant_hand: CardCollection = current_combatant.zones[Global.zone_types.HAND]
			card_manager.apply_selectibility_filter(
				func(c: Card):
					return c.card_owner == current_combatant_hand
			)
		stages.COST:
			var cost_callable = Callable(primary_card.card_resource, "is_eligible_cost").bind(primary_card, cost_cards)
			card_manager.apply_selectibility_filter(cost_callable)
		stages.TARGET:
			var target_callable = Callable(primary_card.card_resource, "is_eligible_target").bind(primary_card, cost_cards, target_cards)
			card_manager.apply_selectibility_filter(target_callable)
	pass

func _on_turn_ended(combatant: Combatant):
	if primary_card:
		# Shorthand for deselecting everything
		_on_card_select_toggle(primary_card)
	current_stage = stages.NONE
		
func _on_turn_began(combatant: Combatant):
	if card_manager == null: await ready
	
	current_combatant = combatant
	var current_combatant_hand: CardCollection = combatant.zones[Global.zone_types.HAND]
	card_manager.apply_selectibility_filter(
		func(c: Card):
			return c.card_owner == current_combatant_hand
	)
	
	current_stage = stages.NONE
	
func _on_play_cards_button():
	if !primary_card.card_resource.satisfies_target(primary_card, cost_cards, target_cards):
		print("Why is this enabled while cards are unplayable?")
		return
	Events.play_cards.emit(primary_card, cost_cards, target_cards)
	_on_card_select_toggle(primary_card)

func _ready():
	Events.card_select_toggle.connect(_on_card_select_toggle)
	Events.turn_began.connect(_on_turn_began)
	Events.turn_ended.connect(_on_turn_ended)
	input_manager.play_cards_button.connect(_on_play_cards_button)
	
