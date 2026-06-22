extends Node2D

var card_being_dragged
var card_rel_pos

var screen_size

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var raycast_retval = raycast(Global.COLLISION_MASK_CARD)
			if raycast_retval:
				card_being_dragged = raycast_retval[0]
				card_rel_pos = raycast_retval[1]
			else:
				card_being_dragged = null
				card_rel_pos = null
		else:
			var raycast_retval = raycast(Global.COLLISION_MASK_AREA)
			if raycast_retval and raycast_retval[0] == $PlayArea:
				card_being_dragged.play()
			card_being_dragged = null
			card_rel_pos = null

func raycast(mask):
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = mask
	var result = space_state.intersect_point(parameters)
	if result:
		print(result[0].collider.get_parent())
		var parent = result[0].collider.get_parent()
		var offset = parent.position - parameters.position
		return [parent, offset]
	else:
		return null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position() + card_rel_pos
		card_being_dragged.position = Vector2(clamp(mouse_pos.x,0,screen_size.x),
		clamp(mouse_pos.y,0,screen_size.y))
		
func connect_card_signals(card):
	card.connect("hovered",on_hovered_over_card)
	card.connect("hovered_off",on_hovered_off_card)
	
func on_hovered_over_card(card):
	print("Hovered")
	
func on_hovered_off_card(card):
	print("Hovered off")
