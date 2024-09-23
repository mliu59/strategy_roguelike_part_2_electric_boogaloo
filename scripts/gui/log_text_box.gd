extends Label

func _init() -> void:
	_clear()
	
func _clear() -> void:
	update_text("")

func update_text(input: String) -> void:
	self.text = input

func loginfo(new_str: String) -> void:
	if len(self.text) > 0:
		self.text += "\n"
	var output = "INFO | " + new_str
	self.text += output
	print(output)

func logerr(new_str: String) -> void:
	if len(self.text) > 0:
		self.text += "\n"
	var output = "ERR  | " + new_str
	self.text += output
	print(output)
