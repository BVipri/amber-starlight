extends Solid
class_name MoveableSolid

func _look(matrix,dir):
	var target = matrix._get_element(pos + dir)
	if not target:
		return matrix._move_element(self,pos + dir)
	if target is Liquid:
		return matrix._swap_elements(self,target)
	return false

func _step(matrix):
	velocity.y += matrix.gravity
	if isFreefalling: velocity.x *= 0.9
	isFreefalling = _actOnElement(matrix,matrix._get_element(pos + Vector2i(0,1)),0)
	if isFreefalling: _dislodgeNearby(matrix)

func _actOnElement(matrix, element, depth):
	if element is Empty or element is Liquid:
		matrix._swap_elements(self,element)
		return true
	else: if element is Solid and isFreefalling and depth == 0:
		var firstDir = 1 if random.randi_range(0,1) == 0 else -1
		var blocked = _actOnElement(matrix,matrix._get_element(pos + Vector2i(firstDir,1)),1)
		if blocked:
			return _actOnElement(matrix,matrix._get_element(pos + Vector2i(-firstDir,1)),1)
		return true
	return false

func _dislodgeNearby(matrix):
	for i in range(2):
		var element = matrix._get_element(pos + Vector2i(1 if i%2==0 else -1,0))
		if element and element.isFreefalling == false: element._attemptDislodge()
	
func _attemptDislodge():
	isFreefalling =  random.randf_range(0,1) > self.consistency or isFreefalling

func _to_string() -> String:
	return "MoveableSolid at " + str(pos)
