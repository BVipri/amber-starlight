extends Object
class_name Element

var pos
var sourceID
var consistency
var random = RandomNumberGenerator.new()
var isFreefalling = true
var velocity = Vector2(0,1)
var type

func _attemptDislodge():
	return

func _step(matrix):
	return

func _init(pos,ID,c):
	self.pos = pos
	self.sourceID = ID
	self.consistency = c

func _look(matrix,dir):
	var target = matrix._get_element(pos + dir)
	if not target:
		return matrix._move_element(self,pos + dir)
	return false
