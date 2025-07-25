extends Object
class_name Objects

static func _generatePlant(id,objType,typeID):
	var object = [TileMapPattern.new(),TileMapPattern.new(),TileMapPattern.new()]
	var random = RandomNumberGenerator.new()
	random.seed = id
	var size = random.randi_range(10,40)
	random.seed = typeID
	match objType:
		0: # Large object
			var type = random.randi_range(0,2)
			random.seed = id
			match type: 
				0: # Block tree
					blockBranch(object,Vector2(0,0),size,1,1,random)
					return object
				1: # Curved tree
					curvedBranch(object,Vector2(0,0),size/2,random.randf_range(-PI/6,PI/6),random,0,false)
					return object
				2: # Pearlstring tree
					curvedBranch(object,Vector2(0,0),size/4,random.randf_range(-PI/12,PI/12),random,0,true)
					return object
		1: # Medium Object
			var type = random.randi_range(0,4)
			random.seed = id
			match type:
				0: # Circle bush
					for i in range(size*1.5):
						for j in range(size*0.8):
							var angle = (2*PI/(size*1.5))*i
							var x = cos(angle)*j+1000
							var y = -sin(angle)*j+1000
							object[1].set_cell(Vector2i(x,y),1,Vector2i(0,0),0)
					return object
				1: # Fountain bush
					for i in range(size):
						for j in range(size):
							var angle = (PI/(size))*i + random.randf_range(-PI/128,PI/128)
							var x = cos(angle)*j
							var y = sin(angle)*j
							if (x <= -pow(pow(size,2)-pow(y,2),0.5)+size and x >= pow(pow(size,2)-pow(y,2),0.5)-size):
								object[1].set_cell(Vector2i(x+1000,-y+1000+3),1,Vector2i(0,0),0)
					return object
				2: # Tall sinusoidal grass
					for i in range(size/6):
						var length = random.randf_range(0,1)
						for j in range(size):
							var y = -j*length
							var x = sin(y/PI)*3 + i*2
							object[1].set_cell(Vector2i(x+1000,y+1000),1,Vector2i(0,0),0)
					return object
				3: # Block towers
					var y = 0
					var blocks = random.randi_range(1,10)
					var scale = size/3
					for i in range(blocks):
						var shift = scale*random.randf_range(-0.5,0.3)
						for j in range(scale+1):
							object[0].set_cell(Vector2i(j+shift+1000,-y+1000),0,Vector2i(0,0),0)
							object[0].set_cell(Vector2i(j+shift+1000,-y-scale+1000),0,Vector2i(0,0),0)
							object[0].set_cell(Vector2i(shift+1000,-y-j+1000),0,Vector2i(0,0),0)
							object[0].set_cell(Vector2i(scale+shift+1000,-y-j+1000),0,Vector2i(0,0),0)
						y = y+scale
						scale = scale*0.8
					return object
				4: # Circle towers:
					var yLevel = 0
					var blocks = random.randi_range(1,10)
					var scale = size/3
					for i in range(blocks):
						var shift = scale*random.randf_range(-0.5,0.3)
						for angle in range(360):
							var rad = ((2*PI)/360)*angle
							var x = cos(rad)*scale
							var y = sin(rad)*scale
							object[1].set_cell(Vector2i(x+shift+1000,-y-yLevel+1000),1,Vector2i(0,0),0)
						yLevel = yLevel+scale*2
						scale = scale*0.8
					return object
		2: # Small Object
			var type = random.randi_range(0,2)
			random.seed = id
			match type:
				0: # Simple grass
					for i in range(size/6):
						var length = random.randf_range(0,1)
						for j in range(size/3):
							var x = i*2
							var y = -j*length
							object[1].set_cell(Vector2i(x+1000,y+1000),1,Vector2i(0,0),0)
					return object
				1: # Sinusoidal grass
					for i in range(size/6):
						var length = random.randf_range(0,1)
						for j in range(size/2):
							var y = -j*length
							var x = sin(y/PI)*3 + i*2
							object[1].set_cell(Vector2i(x+1000,y+1000),1,Vector2i(0,0),0)
					return object
				2: # Wheel herbs
					for angle in range(360):
						var rad = ((2*PI)/360)*angle
						for radius in range(size/8):
							var x = cos(rad)*radius*4
							var y = sin(rad)*radius*4
							object[1].set_cell(Vector2i(x+1000,y+1000),1,Vector2i(0,0),0)
					return object
			
static func curvedBranch(object, base, size, rotation, random, layer, isBead):
	var height = random.randi_range(1,5)*size if isBead == false else random.randi_range(3,8)*size
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
	if layer < 5 or layer < 10 if isBead == true else false:
		var branches = random.rand_weighted([2,4,8,2,1]) if isBead == false else random.rand_weighted([1,8,2])
		for i in range(branches):
			var branchCurve = rotation + (random.randf_range(-PI/8,PI/8) if isBead == false else random.randf_range(-PI/4,PI/4))
			curvedBranch(object,Vector2i(endX,endY),size*0.8,branchCurve,random,layer+1,isBead)
	if layer > 2 or isBead == true:
		for i in range(size*4):
			for j in range(size*4):
				var x = i-size*2
				var y = j-size*2
				if (pow(x,2) + pow(y,2) <= pow(size*2,2)):
					var color = 2 if isBead == false else 1
					object[color].set_cell(Vector2i(endX+x+1000,endY+y+1000),1,Vector2i(0,0),0)

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
			branch[2].set_cell(Vector2i(x+1000,y+1000),1,Vector2i(0,0),0)
	return branch

static func resizeObject(object, size, source):
	var cells = object.get_used_cells()
	for cell in cells:
		for i in range(size.x):
			object.set_cell(cell*size.x+Vector2i(i,0),source,Vector2i(0,0),0)
		for j in range(size.y):
			object.set_cell(cell*size.y+Vector2i(0,j),source,Vector2i(0,0),0)
