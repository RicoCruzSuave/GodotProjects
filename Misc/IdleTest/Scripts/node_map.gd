@tool
extends Node2D

@export_tool_button("Generate Town") var gt_var : = generate_town
@export_tool_button("Generate POIs") var gp_var : = generate_pois
#@export_tool_button("Connect POIs") var cp_var : = connect_pois
@export_tool_button("Connect Connections") var pr_var : = prune_connections
@export_tool_button("Repel POIs") var rp_var : = repel_pois
@export_tool_button("Clear Connections") var cp_clear_var : = clear
@export_tool_button("Create Bridge") var cb_var : = create_bridge

@export var bounds : = Rect2i(0, 0, 480, 270)
@export var density : = 100
@export var repel_radius : = 16
@export var mst_range : = Vector2i(2,8)
@export var tree_chance : = 0.5
@export var number_of_bridges : = 16
@export var line_width : = 3.0
#@export var starting_point : = bounds.position + bounds.size / 2
@onready var pois: Node2D = $POIs
@onready var town: Node2D = $Town

var core_route : = []
var connections : = []
var attempted_connections : = []
var repel : = false

#func _ready() -> void:
	#generate_town()
	#generate_pois()
	#prune_connections()
	#for _i in number_of_bridges:
		#create_bridge()

func _draw() -> void:
	draw_rect(bounds, Color.RED, false, 2.0)
	for poi in pois.get_children():
		draw_circle(poi.position, 1.0, Color.GREEN)
	for t in town.get_children():
		draw_circle(t.position, 5.0, Color.DARK_GREEN)
	for connection in connections:
		draw_line(connection[0].position, connection[1].position, Color.FIREBRICK, line_width, false)
	for connection in core_route:
		draw_line(connection[0].position, connection[1].position, Color.PINK, line_width, false)
	for connection in attempted_connections:
		draw_line(connection[0].position, connection[1].position, Color.BLUE, line_width, false)


func _process(_delta: float) -> void:
	queue_redraw()


func generate_town() -> void:
	connections.clear()
	for child in town.get_children():
		if child is Marker2D:
			child.queue_free()
	var new_town : = Marker2D.new()
	town.add_child(new_town)
	new_town.owner = get_tree().edited_scene_root
	new_town.position.x = randi_range(bounds.position.x, bounds.end.x)
	new_town.position.y = randi_range(bounds.position.y, bounds.end.y)

func generate_pois() -> void:
	##TODO: Some method of overlap prevention
	connections.clear()
	for child in pois.get_children():
		if child is Marker2D:
			child.queue_free()
	## Naive implementation
	#for _i in density:
		#var new_marker : = Marker2D.new()
		#pois.add_child(new_marker)
		#new_marker.position.x = randi_range(bounds.position.x, bounds.end.x)
		#new_marker.position.y = randi_range(bounds.position.y, bounds.end.y)
		#new_marker.name = str(new_marker.position)
	## Spatial hashing
	var min_dist : = int(repel_radius)
	var used_coords : = []
	var break_counter : = 12
	for _i in density:
		var new_marker : = Marker2D.new()
		pois.add_child(new_marker)
		var new_coords : = Vector2i(
			randi_range(bounds.position.x, bounds.end.x),
			randi_range(bounds.position.y, bounds.end.y)
		)
		var new_hash : = new_coords / min_dist
		while used_coords.has(new_hash) and break_counter > 0:
			new_coords = Vector2i(
				randi_range(bounds.position.x, bounds.end.x),
				randi_range(bounds.position.y, bounds.end.y)
			)
			new_hash = new_coords / min_dist
			break_counter -= 1
		if break_counter <= 0:
			print_debug("skipped point")
			continue
		used_coords.append(new_hash)
		new_marker.position = new_coords
		new_marker.name = str(new_marker.position)
	## Poisson
	#var min_dist : = repel_radius
	#var max_dist : = repel_radius * 6
	#var break_counter : = 12
	#var grid : = []
	#var cell_size : float
	#var active_list : = []
	#var points : = []
	#var used_points : = []


#func connect_pois() -> void:
	###BUG: Naive approach
	#connections.clear()
	#for poi in pois.get_children():
		#var num_of_connects: = randi_range(5,5)
		#var other_pois : = pois.get_children().filter(func(a): return a != poi && not connections.has([a, poi]) && not connections.has([poi, a]))
		#other_pois.append(town.get_child(0))
		#other_pois.sort_custom(func(a,b):
			#return poi.position.distance_to(a.position) < poi.position.distance_to(b.position)
		#)
		#for _i in num_of_connects:
			#connections.append([poi, other_pois.pop_front()])


func clear():
	connections.clear()
	attempted_connections.clear()

func repel_pois():
	var pois_shuffled : = pois.get_children()
	pois_shuffled.shuffle()
	for poi in pois_shuffled:
		#var poi : Marker2D = pois.get_children().pick_random()
		var poi_connections : = connections.filter(func(connection : Array): return connection.has(poi))
		var impulse : = Vector2.ZERO
		for connection in poi_connections:
			if connection[0].position.distance_to(connection[1].position) < repel_radius:
				impulse += connection[0].position.direction_to(connection[1].position) * repel_radius
		poi.position += impulse

func prune_connections():
	connections.clear()
	var unvisited_nodes : = pois.get_children()
	var visited_nodes : = [town.get_child(0)]
	var break_counter : = 256
	var new_connections : = []
	# Create a guranteed path through the nodes, Primm algo
	while unvisited_nodes.size() and break_counter > 0:
		break_counter -= 1

		var min_val : = INF
		var new_connection : Array
		for v_node in visited_nodes:
			for uv_node in unvisited_nodes:
				var dist : int = v_node.position.distance_to(uv_node.position)
				if dist < min_val and not new_connections.has([v_node, uv_node]): #and randf() < tree_chance:
					min_val = dist
					new_connection = [v_node, uv_node]
		visited_nodes.append(new_connection[1])
		unvisited_nodes.erase(new_connection[1])
		new_connections.append(new_connection)

	core_route = new_connections.duplicate()

	## Create MST for each node of given size
	var mst_size : = randi_range(mst_range.x, mst_range.y)
	var nodes : = pois.get_children()
	nodes.append(town.get_child(0))
	for node in nodes:
		var _unvisited_nodes : = pois.get_children()
		unvisited_nodes.erase(node)
		var _visited_nodes := [node]
		var min_val : = INF
		var new_connection : Array
		for _i in mst_size:
			for v_node in _visited_nodes:
				for uv_node in _unvisited_nodes:
					if v_node == uv_node:
						continue
					var dist : int = v_node.position.distance_to(uv_node.position)
					if dist < min_val and randf() < tree_chance and not new_connections.has([v_node, uv_node]):
						min_val = dist
						new_connection = [v_node, uv_node]

			visited_nodes.append(new_connection[1])
			unvisited_nodes.erase(new_connection[1])
			new_connections.append(new_connection)
	connections = new_connections
	## Clean up connections
	var dedup : = []
	for connection in connections:
		if connection[0] == connection[1]:
			continue
		if not dedup.has(connection):
			dedup.append(connection)
	connections = dedup
	#debug_print_nodes()

func create_bridge():
	## Connect leaf nodes with only one connection
	attempted_connections.clear()
	var nodes : = pois.get_children()
	var leaf_nodes : = nodes.filter(func(a):
		#debug_print_nodes()
		return get_connections_to(a).size() <= 3)
	var town_node : = town.get_child(0)
	leaf_nodes.sort_custom(func(a,b):
		return a.global_position.distance_to(town_node.global_position) > \
		b.global_position.distance_to(town_node.global_position)
	)
	print(leaf_nodes)
	for leaf_node_a in leaf_nodes:
		for other_node in nodes:
			if leaf_node_a == other_node:
				continue
			var bridge : = [leaf_node_a, other_node]
			var clear_shot : = true
			for connection in connections:
				if connection.has(bridge[0]) or connection.has(bridge[1]):
					continue
				if Geometry2D.segment_intersects_segment(
					bridge[0].position, bridge[1].position,
					connection[0].position, connection[1].position
				):
					clear_shot = false
					break
			if clear_shot:
				connections.append(bridge)
				attempted_connections.append(bridge)
				print_debug("Bridge created ", bridge)
				return
		print_debug("No bridge created")

	#nodes.sort_custom(func(a,b):
		#return get_connections_to(a).size() < get_connections_to(b).size()
	#)

	## Create a bridge
	#attempted_connections.clear()
	#var nodes : = pois.get_children()
	#nodes.sort_custom(func(a,b):
		#return get_connections_to(a).size() < get_connections_to(b).size()
	#)
	#nodes.slice(0,10)
	#var rand_node = nodes.pick_random()
	#nodes.erase(rand_node)
	#for other_node in nodes:
		#var bridge : = [rand_node, other_node]
		#var clear_shot : = true
		#for connection in connections:
			#if connection.has(bridge[0]) or connection.has(bridge[1]):
				#continue
			#if Geometry2D.segment_intersects_segment(
				#bridge[0].position, bridge[1].position,
				#connection[0].position, connection[1].position
			#):
				#clear_shot = false
				#break
		#if clear_shot:
			#connections.append(bridge)
			#attempted_connections.append(bridge)
			#print_debug("Bridge created ", bridge)
			#return
	#print_debug("No bridge created")

func debug_print_nodes():
	for a in pois.get_children():
		var self_count : = 0
		var already_printed : = []
		var _connects : = get_connections_to(a)
		for _i in _connects:
			if already_printed.has(_i):
				continue
			if _i[0] == a and _i[1] == a:
				self_count += 1
			print(_i,":",_connects.count(_i) - 1)
			already_printed.append(_i)
		#
		#print(get_connections_to(a).size(),"\n")
		print("\nMarker: {0}\nSelf Count: {1}\nConnections: {2}\n".format(
			[a, self_count, get_connections_to(a).size()]))


func get_connections_to(node) -> Array:
	return connections.filter(func(connection : Array): return connection.has(node))
