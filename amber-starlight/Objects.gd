extends Object
class_name Objects

static func _generatePlant(id):
	var object = [TileMapPattern.new(),TileMapPattern.new()]
	var random = RandomNumberGenerator.new()
	random.seed = id
	var size = random.randi_range(10,40)
	var type = random.randi_range(0,1)
	match type: 
		0: # Block trees
			blockBranch(object,Vector2(0,0),size,1,1,random)
			return object
		1: # Curved trees
			curvedBranch(object,Vector2(0,0),size/2,random.randf_range(-PI/6,PI/6),random,0)
			return object
			
static func curvedBranch(object, base, size, rotation, random, layer):
	var height = random.randi_range(1,5)*size
	for i in range(height*2):
		for j in range(height*2):
			var x = i-height
			var y = j-height
			var oldx = cos(rotation)*x + sin(rotation)*y
			var oldy = -sin(rotation)*x + cos(rotation)*y
			if oldx > -size/2 and oldx < size/2 and oldy > 0 and oldy < height:
				object[0].set_cell(Vector2i(base.x+x+1000,base.y-y+1000),0,Vector2i(0,0),0)
	var endX = base.x - height*sin(rotation) #+ (size/2)*cos(rotation)
	var endY = base.y - height*cos(rotation) #+ (size/2)*sin(rotation)
	if layer < 5:
		var branches = random.rand_weighted([2,4,8,2,1])
		for i in range(branches):
			var branchCurve = rotation+random.randf_range(-PI/8,PI/8)
			curvedBranch(object,Vector2i(endX,endY),size*0.8,branchCurve,random,layer+1)
	if layer > 2:
		for i in range(size*4):
			for j in range(size*4):
				var x = i-size*2
				var y = j-size*2
				if (pow(x,2) + pow(y,2) <= pow(size*2,2)):
					object[1].set_cell(Vector2i(endX+x+1000,endY+y+1000),1,Vector2i(0,0),0)

static func blockBranch(branch, base, size, direction, side, random):
	var height = random.randi_range(1,5)*size
	for i in range(size):
		for j in range(height):
			var x = base.x + i if direction == 1 else base.x + j*side
			var y = base.y - j*side if direction == 1 else base.y + i
			branch[0].set_cell(Vector2i(x+1000,y+1000),0,Vector2i(0,0),0)
	var endX = base.x + (size/2) if direction == 1 else base.x + (height + size/2)*side
	var endY = base.y - (height + size/2)*side if direction == 1 else base.y + size/2
	var branches = random.randi_range(0,size/2)
	for i in range(branches):
		var newSide = 1 if i%2==0 else -1
		var branchX = base.x + (size/2) * (1+newSide) if direction == 1 else base.x + (height/2 + ((height/2)/(branches))*i)*side
		var branchY = base.y - (height/2 + ((height/2)/(branches))*i)*side if direction == 1 else base.y + (size/2) - (size/2)*newSide
		blockBranch(branch,Vector2(branchX,branchY),size/2,direction*-1,newSide,random)
	for i in range(size*2):
		for j in range(size*2):
			var x = -size + i + endX
			var y = -size + j + endY
			branch[1].set_cell(Vector2i(x+1000,y+1000),1,Vector2i(0,0),0)
	return branch

static func resizeObject(object, size, source):
	var cells = object.get_used_cells()
	for cell in cells:
		for i in range(size.x):
			for j in range(size.y):
				var x = (cell.x-1000)*size.x + i + 1000
				var y = (cell.y-1000)*size.y + j + 1000
				object.set_cell(Vector2i(x,y),source,Vector2i(0,0),0)
