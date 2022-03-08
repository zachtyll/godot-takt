extends ConfirmationDialog

const takt_indicator := preload("res://Bar/HealthDisplay.tscn")

var persist := false

onready var cycle_name := $VBoxContainer/GridContainer/CycleName
onready var duration_seconds := $VBoxContainer/GridContainer/HBoxContainer/DurationSeconds
onready var duration_minutes := $VBoxContainer/GridContainer/HBoxContainer/DurationMinutes
onready var duration_hours := $VBoxContainer/GridContainer/HBoxContainer/DurationHours

onready var status_label := $VBoxContainer/StatusLabel

signal new_cycle_added


func _convert_to_seconds() -> int:
	var seconds = int(duration_seconds.text)
	var minutes = int(duration_minutes.text)
	var hours = int(duration_hours.text)
	var total_time = seconds + (minutes*60) + (hours*3600)
	
	return total_time


func _validate_seconds() -> int:
	if duration_seconds.text.empty():
		status_label.text = "Please provide a duration in seconds."
		return 1
	elif int(duration_seconds.text) < 0:
		status_label.text = "Seconds must be a positive number."
		return 2
	else:
		return 0


func _validate_minutes() -> int:
	if duration_minutes.text.empty():
		status_label.text = "Please provide a duration in minutes."
		return 1
	elif int(duration_minutes.text) < 0:
		status_label.text = "Minutes must be a positive number."
		return 2
	else:
		return 0


func _validate_hours() -> int:
	if duration_hours.text.empty():
		status_label.text = "Please provide a duration in hours."
		return 1
	elif int(duration_hours.text) < 0:
		status_label.text = "Hours must be a positive number."
		return 2
	else:
		return 0


func _on_AddCycle_confirmed():
	var err_sec = _validate_seconds()
	var err_min = _validate_minutes()
	var err_hrs = _validate_hours()
	if err_sec or err_min or err_hrs:
		self.show()
		return
	
	if cycle_name.text.empty():
		status_label.text = "Please provide a name."
		return

	var total_time := _convert_to_seconds()
	var new_cycle = takt_indicator.instance()
	new_cycle.takt_time = total_time
	new_cycle.time_left = total_time
	new_cycle.name = cycle_name.text
	
	emit_signal("new_cycle_added", new_cycle, persist)
	


func _on_CheckButton_toggled(button_pressed):
	persist = button_pressed
