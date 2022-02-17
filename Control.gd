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
	print(cycling)
	bar_instance.cycling = cycling
	bar_indicators.add_child(bar_instance)


func _on_Save_pressed():
	var save_err = Utilities.save_preset("Test")
	if save_err:
		push_error("Error when saving!")


func _on_SavePreset_pressed():
	$SaveDialog.show()


func _on_LoadPreset_pressed():
	$FileDialog.show()


func _on_FileDialog_file_selected(path):
	var load_err = Utilities.load_preset(path)
	if load_err:
		push_error("Error when loading!")


func _on_SaveDialog_confirmed():
	var preset_name = $SaveDialog/MarginContainer/VBoxContainer/HBoxContainer/LineEdit.text
	if preset_name.empty():
		$SaveDialog/MarginContainer/VBoxContainer/Label.text = "Please insert a name."
		return

	var save_err = Utilities.save_preset(preset_name)
	$SaveDialog/MarginContainer/VBoxContainer/HBoxContainer/LineEdit.text = ""
	
	if save_err:
		$SaveDialog/MarginContainer/VBoxContainer/Label.text = "Save error ocurred."
		push_error("Error when saving!")
