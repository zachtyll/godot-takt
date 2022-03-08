extends Control

onready var cycles_list := $Background/VBoxContainer/ScrollContainer/CyclesList

signal cycles_list_items


func _move_cycles():
	var cycles_list_items = cycles_list.get_children()
	for cycle in cycles_list_items:
		cycles_list.remove_child(cycle)


func _on_AddCycle_pressed():
	$AddCycle.popup_centered()


func _on_Close_pressed():
	var cycles_list_items = cycles_list.get_children()
	for cycle in cycles_list_items:
		cycle.hide_controls()
	_move_cycles()
	self.hide()
	emit_signal("cycles_list_items", cycles_list_items)


func _on_AddCycle_new_cycle_added(new_cycle, persist):
	cycles_list.add_child(new_cycle)
	
	if persist:
		var save_err = Utilities.save_cycle(new_cycle, new_cycle.name)
		if save_err:
			push_error("Error when saving!")


func _on_LoadCycle_pressed():
	$FileDialog.popup_centered()


func _on_FileDialog_file_selected(path):
	var load_err = Utilities.load_cycle(path)
	if load_err:
		push_error("Error when loading!")
