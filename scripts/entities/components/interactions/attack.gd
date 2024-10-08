extends Node
class_name Attack

enum attack_types {NORMAL, RANGED}

var _ranged: bool = false
var damage_amount: int = 0
var heal_amount: int = 0
var type: int = attack_types.NORMAL
var applied_effects: Array = []

func init(_amount: int, _type: int, _applied_effects:Array=[], _heal_amount:int=0) -> void:
	damage_amount = _amount
	heal_amount = _heal_amount
	type = _type
	applied_effects.append_array(_applied_effects)
	
func is_ranged() -> bool:
	return _ranged
