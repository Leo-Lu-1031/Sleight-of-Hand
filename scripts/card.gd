extends Node2D

class_name Card

signal hovered
signal hovered_off

#var starting_position

var is_selected: bool = false:
	set(selected):
		is_selected = selected
		render()
		
var is_hovered: bool = false:
	set(hovered):
		is_hovered = hovered
		render()
		
var is_selectible: bool = false:
	set(selectible):
		is_selectible = selectible
		render()
		Events.card_selected_toggle(self, selectible)
		
var memorized_z_index := 0:
	set(incoming_z_index):
		memorized_z_index = incoming_z_index
		render()

@onready var sprite_front = $CardImg
@onready var sprite_back = $PokerBack
@onready var glow = $Glow
@onready var fog = $Fog

var card_owner: CardCollection
var card_resource: CardResource: 
	set(card_resource):
		if not is_node_ready(): await ready
		self.card_resource = card_resource
		sprite_front.texture = card_resource.texture
		get_node('Tooltips').text = card_resource.tooltips

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().connect_card_signals(self)
	show_front()
	$"Glow".visible = false
	$"Fog".visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered", self)

func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off", self)

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
	if is_selected:
		scale *= 1.1
	glow.visible = is_selected
	
	if !is_selectible:
		fog.visible = true
	else:
		fog.visible = false
		
	if is_hovered: 
		scale *= 1.1
		if z_index != 100: memorized_z_index = z_index
		z_index = 100
	else:
		z_index = memorized_z_index
		
	get_node("Tooltips").visible = is_hovered
