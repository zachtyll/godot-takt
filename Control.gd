extends Control

var takt_indicator := preload("res://Bar/HealthDisplay.tscn")
var cycling := false

onready var new_cycle_time := $HBoxContainer/SidePanel/OptionsList/CycleTime
onready var bar_indicators := $HBoxContainer/BarContainer


func _on_Button_pressed():
	$Timer.start()


func _on_Timer_timeout():
	get_tree().call_group("Stats", "decrement_second")


func _on_Reset_pressed():
	$Timer.stop()
	get_tree().call_group("Stats", "reset")


func _on_Pause_pressed():
	$Timer.stop()


func _on_Cycle_toggled(toggled:bool):
	cycling = toggled
	get_tree().call_group("Stats", "set_cycling", cycling)


func _on_AddCycle_pressed():
	if not int(new_cycle_time.text) > 0:
		return
	var bar_instance = takt_indicator.instance()
	bar_instance.takt_time = new_cycle_time.text
	bar_instance.time_left = new_cycle_time.text
	bar_instance.cycling = cycling
	bar_indicators.add_child(bar_instance)


func _on_SavePreset_pressed():
	$SaveDialog.show()


func _on_LoadPreset_pressed():
	$FileDialog.show()


func _on_FileDialog_file_selected(path):
	var load_err = Utilities.load_preset(path)
	if load_err:
		push_error("Error when loading!")


func _on_EditScreen_pressed():
	var cycle_list = bar_indicators.get_children()
	for cycle in cycle_list:
		bar_indicators.remove_child(cycle)
	for cycle in cycle_list:
		$EditScreen.cycles_list.add_child(cycle)
	$EditScreen.show()


func _on_SaveDialog_save_preset(preset_name : String):
	var save_err = Utilities.save_preset(preset_name)
	if save_err:
		push_error("Error when saving!")


func _on_EditScreen_cycles_list_items(cycles_list):
	for cycle in bar_indicators.get_children():
		bar_indicators.remove_child(cycle)
	for cycle in cycles_list:
		bar_indicators.add_child(cycle)
