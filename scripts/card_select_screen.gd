extends Control
'''
I feel a sense of intuitive unease with this code.
It seems to share lots of functionalities from SelectionManager and InputManager,
and yet it's different enough that an abstraction feels arbitrary and convoluted.
Guess you lose either way. 
'''

var phantoms: Array[Card] = []
var select_logic: Callable
var select_type: Global.select_types

func _init(cards: Array[Card], new_select_type: Global.select_types, new_select_logic: Callable):
	select_type = new_select_type
	select_logic = func(card: Card):
		return new_select_logic.call(card.is_phantom_of)
	if not is_node_ready(): await ready
	for card in cards: 
		var phantom = card.duplicate()
		phantom.is_phantom_of = card
		phantoms.append(phantom)
