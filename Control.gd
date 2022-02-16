extends Control

var takt_indicator := preload("res://Bar/HealthDisplay.tscn")

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
	get_tree().call_group("Stats", "set_cycling", toggled)


func _on_AddCycle_pressed():
	if not int(new_cycle_time.text) > 0:
		return
	var bar_instance = takt_indicator.instance()
	bar_instance.takt_time = new_cycle_time.text
	bar_indicators.add_child(bar_instance)
