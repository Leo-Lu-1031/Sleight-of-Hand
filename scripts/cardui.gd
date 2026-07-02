extends Node2D

class_name Card

var carduis: Array[CardUI] = []

var selection_state: Global.select_types = Global.select_types.NONE:
	set(state):
		selection_state = state
		for cardui in carduis:
			cardui.selection_state = selection_state
		
var is_hovered: bool = false:
	set(hovered):
		is_hovered = hovered
		for cardui in carduis:
			cardui.is_hovered = is_hovered

var card_owner: CardCollection
var card_resource: CardResource: 
	set(new_card_resource):
		if not is_node_ready(): await ready
		card_resource = new_card_resource
		for cardui in carduis:
			cardui.sprite_front.texture = card_resource.texture
			cardui.get_node('Tooltips').text = card_resource.tooltips

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

var showing_front := false

func show_front():
	sprite_front.visible = true
	sprite_back.visible = false
	showing_front = true

func show_back():
	sprite_front.visible = false
	sprite_back.visible = true
	showing_front = false

func flip_card():
	if showing_front == true:
		show_back()
	elif showing_front == false:
		show_front()
	

func render():
	scale = Vector2(1,1)
	rotation = 0
	if selection_state != Global.select_types.UNSELECTIBLE and selection_state != Global.select_types.NONE:
		scale *= 1.1
		
	for state in state_sprites:
		var sprite = state_sprites[state]
		if !sprite: continue
		sprite.visible = (state == selection_state)
		
	if is_hovered: 
		scale *= 1.1
		if z_index != 100: _memorized_z_index = z_index
		z_index = 100
	else:
		z_index = _memorized_z_index
		
	get_node("Tooltips").visible = is_hovered and showing_front
