extends Object
class_name Objects

static func _generatePlant(id):
	var random = RandomNumberGenerator.new()
	random.seed = id
	var size = random.randi_range(10,100)
	var type = 0 #random.randi_range(0,20)
	match type: 
		0: # Block trees
			var object = []
			blockBranch(object,Vector2(0,0),size,1,1,random)
			return object
		1: # Curved trees
			var object = []
			var initialCurve = random.randf_range(-PI/4,PI/4)
			curvedBranch(object,Vector2(0,0),size/2,initialCurve,random,0)
			return object
			
static func curvedBranch(branch, base, size, rotation, random, layer):
	var height = random.randi_range(1,5)*size
	for i in range(height*2):
		for j in range(height*2):
			var x = i-height
			var y = j-height
			var oldx = cos(rotation)*x + sin(rotation)*y
			var oldy = -sin(rotation)*x + cos(rotation)*y
			if oldx > -size/2 and oldx < size/2 and oldy > 0 and oldy < height:
				branch.append([Vector2i(base.x+x,base.y-y),0])
	var branches = random.randi_range(0,pow(size,0.5))
	var endX = base.x - height*sin(rotation) #+ (size/2)*cos(rotation)
	var endY = base.y - height*cos(rotation) #+ (size/2)*sin(rotation)
	for i in range(branches):
		var branchCurve = rotation+random.randf_range(-PI/8,PI/8)
		curvedBranch(branch,Vector2i(endX,endY),size*0.8,branchCurve,random,layer+1)
	if layer > 2:
		for i in range(size*4):
			for j in range(size*4):
				var x = i-size*2
				var y = j-size*2
				if (pow(x,2) + pow(y,2) <= pow(size*2,2)):
					branch.append([Vector2i(endX + x,endY + y),1]) 

static func blockBranch(branch, base, size, direction, side, random):
	var height = random.randi_range(1,5)*size
	for i in range(size):
		for j in range(height):
			var x = base.x + i if direction == 1 else base.x + j*side
			var y = base.y - j*side if direction == 1 else base.y + i
			branch.append([Vector2i(x,y),0])
	var endX = base.x + (size/2) if direction == 1 else base.x + (height + size/2)*side
	var endY = base.y - (height + size/2)*side if direction == 1 else base.y + size/2
	var leaves = []
	for i in range(size*2):
		for j in range(size*2):
			var x = -size + i + endX
			var y = -size + j + endY
			leaves.append([Vector2i(x,y),1])
	var branches = random.randi_range(0,size/2)
	for i in range(branches):
		var newSide = 1 if i%2==0 else -1
		var branchX = base.x + (size/2) * (1+newSide) if direction == 1 else base.x + (height/2 + ((height/2)/(branches))*i)*side
		var branchY = base.y - (height/2 + ((height/2)/(branches))*i)*side if direction == 1 else base.y + (size/2) - (size/2)*newSide
		blockBranch(branch,Vector2(branchX,branchY),size/2,direction*-1,newSide,random)
	branch.append_array(leaves)
	return branch
