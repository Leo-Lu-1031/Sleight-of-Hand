extends Node2D

class_name Card

signal hovered
signal hovered_off

#var starting_position

var is_selected: bool = false
var is_hovered: bool = false
var is_selectible: bool = true

@onready var sprite_front = $"CardImg"
@onready var sprite_back = $PokerBack
@onready var glow = $Glow
@onready var fog = $Fog

var memorized_z_index := 0

var card_owner: CardCollection

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
	print('mouse exited ', self)
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
		
func set_card_texture(texture):
	sprite_front.texture = texture

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
		
	print(scale, is_selected, is_selectible, is_hovered)
	
func set_select(selected: bool):
	is_selected = selected
	render()
	
func set_selectible(selectible: bool):
	is_selectible = selectible
	render()

func set_hover(hovered: bool):
	is_hovered = hovered
	render()
	
func set_card_z_index(incoming_z_index: float):
	memorized_z_index = incoming_z_index
	render()
