extends Node
class_name EffectResolver

signal start_next_effect
var effect_queue: Array[Callable]

func append_effect(primary: Card, costs: Array[Card], targets: Array[Card]):
	effect_queue.append(
		func():
			primary.card_resource.card_effects(primary, costs, targets)
			start_next_effect.emit()
	)
	if len(effect_queue) == 1:
		start_next_effect.emit()

func _on_start_next_effect():
	if len(effect_queue) == 0: return
	var effect: Callable = effect_queue.pop_front()
	if !effect: return
	effect.call()

func _ready():
	Events.play_cards.connect(append_effect)
	start_next_effect.connect(_on_start_next_effect)
