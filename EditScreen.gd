extends Control

onready var cycles_list := $Background/VBoxContainer/ScrollContainer/CyclesList

signal cycles_list_items


func _move_cycles():
	var cycles_list_items = cycles_list.get_children()
	for cycle in cycles_list_items:
		cycles_list.remove_child(cycle)


func _on_AddCycle_pressed():
	$AddCycle.show()


func _on_Close_pressed():
	var cycles_list_items = cycles_list.get_children()
	_move_cycles()
	self.hide()
	emit_signal("cycles_list_items", cycles_list_items)


func _on_AddCycle_new_cycle_added(new_cycle):
	cycles_list.add_child(new_cycle)
