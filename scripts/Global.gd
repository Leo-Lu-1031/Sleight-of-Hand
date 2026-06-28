extends Node2D

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_SLOT = 2
const COLLISION_MASK_DECK = 3

const CARD_WIDTH = 100
const CARD_HEIGHT = 150

func raycast() -> Node2D:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	var result = space_state.intersect_point(parameters)
	if result:
		return get_node_with_highest_z_index(result)
	else:
		return null
	
func get_node_with_highest_z_index(nodes: Array[Dictionary]) -> Node2D:
	var highest_z_node = null
	var highest_z_index = -1
	
	for i in range(0, nodes.size()):
		var current_node = nodes[i].collider.get_parent()
		if current_node.z_index > highest_z_index:
			highest_z_node = current_node
			highest_z_index = current_node.z_index
	return highest_z_node


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
