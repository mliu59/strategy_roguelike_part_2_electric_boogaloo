extends AnimatedSprite2D
class_name WorldDecorBase
var next_animation_play: int
@export var min_time_ms: int = 10000
@export var max_time_ms: int = 15000
@export var animation_name: String

var random = RandomNumberGenerator.new()

func _ready() -> void:
	next_animation_play = Time.get_ticks_msec() + random.randi_range(min_time_ms, max_time_ms)

func _process(_delta: float) -> void:
	if Time.get_ticks_msec() < next_animation_play:
		return
	play(animation_name)
	next_animation_play = Time.get_ticks_msec() + random.randi_range(min_time_ms, max_time_ms)
