extends Control


var bar_red = preload("res://Bar/BarRed.png")
var bar_green = preload("res://Bar/BarGreen.png")
var bar_yellow = preload("res://Bar/BarYellow.png")

onready var healthbar := $HealthBar
onready var health_label := $CenterContainer/Label
onready var tween := $Tween
onready var stats := $Stats


func update_healthbar(new_health: float):
	if not healthbar:
		yield(self, "ready")
	
	health_label.text = "Time: %s" % new_health
	
	var percent = float(new_health / stats.full_duration)
	healthbar.texture_progress = bar_green
	if percent < 0.7:
		healthbar.texture_progress = bar_yellow
	if percent < 0.35:
		healthbar.texture_progress = bar_red
	if percent <= 1:
		show()
	tween.interpolate_property(
		healthbar,
		"value",
		healthbar.value,
		healthbar.max_value * percent,
		0.2,
		Tween.TRANS_CUBIC,
		Tween.EASE_OUT)
	tween.start()


func _on_Stats_time_left_changed(new_health : int):
	update_healthbar(new_health)
