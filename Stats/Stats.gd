extends Node


# Cycle
var cycling := false
# Seconds left
var time_left := 0 setget set_time_left, get_time_left
# Unit is seconds
var full_duration = 0 setget set_duration

signal time_left_changed
signal time_ran_out

func set_time_left(value) -> void:
# warning-ignore:narrowing_conversion
	time_left = clamp(value, 0, full_duration)
	emit_signal("time_left_changed", time_left)
	
	if has_run_out():
		emit_signal("time_ran_out")
		if is_cycling():
			reset()


func set_duration(new_duration:int) -> void:
	full_duration = new_duration


func decrement_second() -> void:
	self.time_left -= 1


func decrement_minute() -> void:
	self.time_left -= 60


func decrement_hour() -> void:
	self.time_left -= 3600


func increment_second() -> void:
	self.time_left += 1


func increment_minute() -> void:
	self.time_left += 60


func increment_hour() -> void:
	self.time_left += 3600


func reset() -> void:
	self.time_left = full_duration


func get_time_left() -> int:
	return time_left


func get_full_duration() -> int:
	return self.full_duration


func set_cycling(value) -> void:
	self.cycling = value


func is_cycling() -> bool:
	return self.cycling


func has_run_out() -> bool:
	if time_left == 0:
		return true
	else:
		return false
