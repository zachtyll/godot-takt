extends Control


var bar_red = preload("res://Bar/BarRed.png")
var bar_green = preload("res://Bar/BarGreen.png")
var bar_yellow = preload("res://Bar/BarYellow.png")

var takt_time := 0
var time_left := 0
var cycling := false


onready var healthbar := $HealthBar
onready var health_label := $CenterContainer/Label
onready var tween := $Tween
onready var stats := $Stats


func update_healthbar(new_health: float):
	if not healthbar:
		yield(self, "ready")
	elif not stats:
		yield(self, "ready")
	
	# Set label units.
	if new_health <= 60:
		health_label.text = "Sekunder kvar: %s" % new_health
	elif new_health >= 60:
		health_label.text = "Minuter kvar: %s" % ceil(new_health / 60)
	
	# Set bar colour.
	var percent = float(new_health / stats.full_duration)
	healthbar.texture_progress = bar_green
	if percent < 0.7:
		healthbar.texture_progress = bar_yellow
	if percent < 0.35:
		healthbar.texture_progress = bar_red
	if percent <= 1:
		show()
	
	# Animate bar.
	tween.interpolate_property(
		healthbar,
		"value",
		healthbar.value,
		healthbar.max_value * percent,
		0.2,
		Tween.TRANS_CUBIC,
		Tween.EASE_OUT)
	tween.start()


func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"takt_time" : stats.get_full_duration(),
		"time_left" : stats.get_time_left()
	}
	return save_dict


func _on_Stats_time_left_changed(new_health : int):
	update_healthbar(new_health)


func _ready():
	stats.set_duration(takt_time)
	stats.set_time_left(time_left)
	stats.set_cycling(cycling)
