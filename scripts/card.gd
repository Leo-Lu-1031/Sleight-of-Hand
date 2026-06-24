extends Node2D

signal hovered
signal hovered_off

@onready var sprite_front = $"CardImg"
@onready var sprite_back = $PokerBack

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().connect_card_signals(self)
	show_back()
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
		
func set_card_texture(texture):
	sprite_front.texture = texture
