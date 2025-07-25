extends Object
class_name Objects

static func _generatePlant(id):
	var random = RandomNumberGenerator.new()
	random.seed = id
	var size = random.randi_range(1,10)
	var type = 1 #random.randi_range(0,20)
	match type:
		0: # Block trees
			var object = []
			branch(object,Vector2(0,0),size,1,1,random)
			return object
		1: # Wavy growers
			var object = []
			var direction = random.randf_range(-1,1)
			for i in range(size):
				var x = i
				var y = (x*direction + pow((sin(x*direction)),2))*10
				for j in range(size/2):
					object.append([Vector2i(x,y+j-size/4),1])
			return object

static func branch(branch, base, size, direction, side, random):
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
		branch(branch,Vector2(branchX,branchY),size/2,direction*-1,newSide,random)
	branch.append_array(leaves)
	return branch
