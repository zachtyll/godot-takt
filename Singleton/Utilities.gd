extends Node


func save_preset(file_name: String) -> int:
	var file_path = "user://%s.save" % file_name
	var save_preset = File.new()
	save_preset.open(file_path, File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
			
		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
			
		# Call the node's save function.
		var node_data = node.call("save")
		# Store the save dictionary as a new line in the save file.
		save_preset.store_line(to_json(node_data))
	save_preset.close()
	
	return OK


# Note: This can be called from anywhere inside the tree. This function
# is path independent.
func load_preset(file: String):
	var save_presets = File.new()
	if not save_presets.file_exists(file):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_presets.open(file, File.READ)
	while save_presets.get_position() < save_presets.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_presets.get_line())

		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instance()
		new_object.takt_time = node_data["takt_time"]
		new_object.time_left = node_data["time_left"]
#		new_object.cycling = node_data["cycling"]
		get_node(node_data["parent"]).add_child(new_object)

		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent":
				continue
			new_object.set(i, node_data[i])

	save_presets.close()


func save_cycle(cycle, file_name: String) -> int:
	var file_path = "user://cycles/%s.save" % file_name
	var save_preset = File.new()
	save_preset.open(file_path, File.WRITE)
	# Check the node is an instanced scene so it can be instanced again during load.
	if cycle.filename.empty():
		print("persistent node '%s' is not an instanced scene, skipped" % cycle.name)
		
	# Check the node has a save function.
	if !cycle.has_method("save"):
		print("persistent node '%s' is missing a save() function, skipped" % cycle.name)
		
	# Call the node's save function.
	var node_data = cycle.call("save")
	# Store the save dictionary as a new line in the save file.
	save_preset.store_line(to_json(node_data))
	save_preset.close()
	
	return OK


func load_cycle(file: String):
	var save_presets = File.new()
	if not save_presets.file_exists(file):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_presets.open(file, File.READ)
	while save_presets.get_position() < save_presets.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_presets.get_line())

		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instance()
		new_object.takt_time = node_data["takt_time"]
		new_object.time_left = node_data["time_left"]
#		new_object.cycling = node_data["cycling"]
		get_node(node_data["parent"]).add_child(new_object)

		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent":
				continue
			new_object.set(i, node_data[i])

	save_presets.close()
	

func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files


# Set up directory structure.
func _ready():
	var dir = Directory.new()
	if not dir.dir_exists("user://cycles"):
		dir.make_dir("user://cycles")
	
	if not dir.dir_exists("user://presets"):
		dir.make_dir("user://presets")
