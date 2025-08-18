extends Element
class_name Liquid

var dispersionRate = 5

func _step(matrix):
	_actOnElement(matrix,matrix._get_element(pos + Vector2i(0,1)),0)

func _actOnElement(matrix, element, depth):
	if element is Empty:
		matrix._swap_elements(self,element)
		return false
	else: if (element is Solid or element is Liquid) and depth == 0:
		var firstDir = 1 if random.randi_range(0,1) == 0 else -1
		var blocked = _actOnElement(matrix,matrix._get_element(pos + Vector2i(firstDir,0)),1)
		if blocked:
			return _actOnElement(matrix,matrix._get_element(pos + Vector2i(-firstDir,0)),1)
		return false
	return true

func _to_string() -> String:
	return "Liquid at " + str(pos)
