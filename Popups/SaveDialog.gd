extends WindowDialog

onready var name_line := $MarginContainer/VBoxContainer/HBoxContainer/NameLine
onready var status_label := $MarginContainer/VBoxContainer/StatusLabel

signal save_preset


func _validate_name() -> int:
	if name_line.text.empty():
		return 1
	else:
		return 0


func _on_OK_pressed():
	var error = _validate_name()
	match error:
		1:
			status_label.text = "Please provide a name for the preset."
		0:
			emit_signal("save_preset", name_line.text)
			self.hide()


func _on_Cancel_pressed():
	self.hide()
	status_label.text = ""
	name_line.text = ""
