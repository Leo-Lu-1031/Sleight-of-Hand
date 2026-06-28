extends Node2D
class_name CardManager

var is_hovering_on_card: bool

var card_being_dragged: Card
var card_rel_pos: Vector2
var screen_size: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	pass
	
func _process(delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position() + card_rel_pos
		card_being_dragged.position = Vector2(clamp(mouse_pos.x,0,screen_size.x),
		clamp(mouse_pos.y,0,screen_size.y))

func _on_input_manager_start_drag(card: Card) -> void:
	var mouse_pos = get_global_mouse_position()
	card_being_dragged = card
	card_rel_pos = card.position - mouse_pos
	card_being_dragged.set_hover(false)
	
func _on_input_manager_end_drag() -> void:
	if !card_being_dragged: return
	card_being_dragged.set_hover(true)
	#var card_slot = raycast(Global.COLLISION_MASK_SLOT)
	#if card_slot and !card_slot.card_in_slot:
		#hand_reference.remove_card_from_hand(card_being_dragged)
		#card_being_dragged.position = card_slot.position
		#card_being_dragged.get_node("Area2D/CollisionShape2D").disabled = true
		#card_slot.card_in_slot = true
	
	card_being_dragged.card_owner.render()
	card_being_dragged = null
	
func connect_card_signals(card: Card) -> void:
	card.connect("hovered",on_hovered_over_card)
	card.connect("hovered_off",on_hovered_off_card)

func on_hovered_over_card(card: Card) -> void:
	card.set_hover(true)
	
func on_hovered_off_card(card: Card) -> void:
	card.set_hover(false)
	if !card_being_dragged:
		var new_card_hovered = Global.raycast()
		if new_card_hovered is Card:
			new_card_hovered.set_hover(true)
		else:
			is_hovering_on_card = false	
			

func _on_logic_god_update_selectibles(selectibility_func: Callable) -> void:
	for card: Card in get_children():
		card.set_selectible(selectibility_func.call(card))
		
	
	
	
	
