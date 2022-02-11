extends Control


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
