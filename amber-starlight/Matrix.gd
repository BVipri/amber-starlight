extends TileMapLayer
class_name Matrix

var grid = []
var size = 100
var barrier = Barrier.new(Vector2i(0,0),2,1)
var gravity = 1

var typeMap = {
	"Sand" = {
		Type = MoveableSolid,
		SourceID = 0,
		Consistency = 0.2
	},
	"Stone" = {
		Type = ImmovableSolid,
		SourceID = 0,
		Consistency = 1
	},
	"Water" = {
		Type = Liquid,
		SourceID = 1,
		Consistency = 0.3
	},
	"Dirt" = {
		Type = MoveableSolid,
		SourceID = 0,
		Consistency = 0.9
	},
	"Empty" = {
		Type = Empty,
		SourceID = 2,
		Consistency = 1
	},
	"Barrier" = {
		Type = Barrier,
		SourceID = 2,
		Consistency = 1
	}
}

func _ready() -> void:
	for i in range(size):
		grid.append([])
		for j in range(size):
			grid[i].append(Empty.new(Vector2i(i,j),typeMap["Empty"].SourceID,typeMap["Empty"].Consistency))
	for i in range(size/2):
		_create_element(Vector2i(i+size/4,size/2),"Stone")
		#for j in range(size/2):
			#_create_element(Vector2i(i+size/4,j),"Sand")

func _process(delta: float) -> void:
	_create_element(Vector2i(size/4,0),"Dirt")
	_create_element(Vector2i(size/2,0),"Water")
	_create_element(Vector2i(3*size/4,0),"Sand")
	_update()

func _update():
	#for element in elements:
		#element._step(self)
	for i in range(size):
		for j in range(size):
			var x = i
			var y = size-j-2
			if grid[x][y] and not grid[x][y] is Empty: grid[x][y]._step(self)

func _get_element(pos):
	if pos.x >= 0 and pos.x < size and pos.y >= 0 and pos.y < size:
		return grid[pos.x][pos.y]
	else:
		return barrier

func _move_element(element,to):
	if (to.x < 0 or to.x >= size or to.y < 0 or to.y >= size):
		return false
	var pos = element.pos
	element.pos = to
	grid[pos.x][pos.y] = null
	grid[to.x][to.y] = element
	self.erase_cell(pos)
	self.set_cell(to,element.sourceID,to%32,0)
	return true

func _swap_elements(element1,element2):
	if element1 is Barrier or element2 is Barrier:
		return false
	var pos1 = element1.pos
	var pos2 = element2.pos
	element1.pos = pos2
	element2.pos = pos1
	grid[pos1.x][pos1.y] = element2
	grid[pos2.x][pos2.y] = element1
	self.set_cell(pos1,element2.sourceID,pos1%32,0)
	self.set_cell(pos2,element1.sourceID,pos2%32,0)
	return true

func _create_element(pos,type):
	if (pos.x < 0 or pos.x >= size or pos.y < 0 or pos.y >= size or not _get_element(pos) is Empty):
		return
	var element = typeMap[type].Type.new(pos,typeMap[type].SourceID,typeMap[type].Consistency)
	#elements.append(element)
	grid[pos.x][pos.y] = element
	self.set_cell(pos,typeMap[type].SourceID,pos%32,0)
