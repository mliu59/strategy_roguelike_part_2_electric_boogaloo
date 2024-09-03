extends Sprite2D
class_name StatusBar

var color_fill_main = ColorRect.new()

@export var main_color: Color = Color(1, 1, 1, 1)
@export var background_color: Color = Color(1, 1, 1, 1)
@export var total_pixel_len: int = 30
const BAR_HEIGHT = 2

func _ready() -> void:
	$background.color = background_color
	color_fill_main.show_behind_parent = false
	color_fill_main.color = main_color
	color_fill_main.position = Vector2(-(total_pixel_len/2-1), -BAR_HEIGHT/2)
	add_child(color_fill_main)
	set_ratio(1)


func set_ratio(ratio: float) -> void:
	color_fill_main.size = Vector2(roundf((total_pixel_len-2)*ratio), BAR_HEIGHT)
