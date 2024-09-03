extends Node
class_name Attack

enum attack_types {NORMAL}
enum attack_applied_effects {NONE, BLEEDING}
const attack_names = {
	attack_applied_effects.NONE: "NONE",
	attack_applied_effects.BLEEDING: "BLEEDING"
}

var damage_amount: int = 0
var type: int = attack_types.NORMAL
var applied_effects: Array = []

func init(_amount: int, _type: int, _applied_effects:Array=[]) -> void:
	damage_amount = _amount
	type = _type
	for item in _applied_effects:
		applied_effects.append(attack_names[item])
	
	
