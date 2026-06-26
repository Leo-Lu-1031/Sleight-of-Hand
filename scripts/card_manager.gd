extends Node2D
class_name CardManager

var card_being_dragged
var card_rel_pos

var screen_size
var is_hovering_on_card
var hand_reference


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hand_reference = get_parent()
	

func _input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card_hit = raycast(Global.COLLISION_MASK_CARD)
			if card_hit:
				start_drag(card_hit)
				#raycast_retval[0].flip_card()
		else:
			if card_being_dragged:
				finish_drag()

func raycast(mask: int) -> Node2D:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = mask
	var result = space_state.intersect_point(parameters)
	if result:
		var parent = get_card_with_highest_z_index(result)
		#var offset = parent.position - parameters.position
		return parent
	else:
		return null

func get_card_with_highest_z_index(cards: Array[Dictionary]) -> Card:
	var highest_z_card = null
	var highest_z_index = -1
	
	for i in range(0, cards.size()):
		#prev code was:
		#var current_card = cards[1].collider.get_parent()
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index and current_card is Card:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position() + card_rel_pos
		card_being_dragged.position = Vector2(clamp(mouse_pos.x,0,screen_size.x),
		clamp(mouse_pos.y,0,screen_size.y))
		
func connect_card_signals(card: Card) -> void:
	card.connect("hovered",on_hovered_over_card)
	card.connect("hovered_off",on_hovered_off_card)
	
func on_hovered_over_card(card: Card) -> void:
	if !is_hovering_on_card:
		is_hovering_on_card = true
		highlight_card(card,true)
	
func on_hovered_off_card(card: Card) -> void:
	highlight_card(card,false)
	if !card_being_dragged:
		var new_card_hovered = raycast(Global.COLLISION_MASK_CARD)
		if new_card_hovered:
			highlight_card(new_card_hovered,true)
		else:
			is_hovering_on_card = false	
		
func highlight_card(card: Card, hovered: bool):
	if hovered:
		card.scale = Vector2(1.05,1.05)
		card.memorized_z_index = card.z_index
		card.z_index = 100
	else:
		card.scale = Vector2(1.00,1.00)
		card.z_index = card.memorized_z_index

func start_drag(card: Card) -> void:
	var mouse_pos = get_global_mouse_position()
	card_being_dragged = card
	card_rel_pos = card.position - mouse_pos
	card_being_dragged.scale = Vector2(1,1)
	
func finish_drag() -> void:
	card_being_dragged.scale = Vector2(1.05,1.05)
	var card_slot = raycast(Global.COLLISION_MASK_SLOT)
	if card_slot and !card_slot.card_in_slot:
		hand_reference.remove_card_from_hand(card_being_dragged)
		card_being_dragged.position = card_slot.position
		card_being_dragged.get_node("Area2D/CollisionShape2D").disabled = true
		card_slot.card_in_slot = true
	else:
		hand_reference.add_card_to_hand(card_being_dragged)
	card_being_dragged = null
	card_rel_pos = null

	
