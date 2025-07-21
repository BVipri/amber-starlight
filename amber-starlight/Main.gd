extends Node2D
@export var rendDist = 80
@export var numObjects = 30

var timer = 0
var mainLayerC1
var mainLayerC2
var backgroundLayer1
var backgroundLayer2
var mainObjectLayerC1
var mainObjectLayerC2
var generating = false
var loadedX = []
var objects = []
var loadedObjectX = []
var planet
var player
var noise = FastNoiseLite.new()
var random = RandomNumberGenerator.new()

func _ready() -> void:
	mainLayerC1 = get_node("MainLayer").get_node("C1")
	mainLayerC2 = get_node("MainLayer").get_node("C2")
	backgroundLayer1 = get_node("BackgroundLayer1").get_node("C1")
	backgroundLayer2 = get_node("BackgroundLayer2").get_node("C1")
	mainObjectLayerC1 = get_node("MainObjectLayer").get_node("C1")
	mainObjectLayerC2 = get_node("MainObjectLayer").get_node("C2")
	player = get_node("Player")
	noise.noise_type = FastNoiseLite.TYPE_PERLIN

func _generate(pos) -> void:
	var newLoadedX = []
	for i in range(rendDist):
		var x = int(pos.x/32 + i - rendDist/2)
		newLoadedX.append(x)
		if loadedX.find(x) == -1:
			var y = _generate_y(planet.id,x)
			var bgy = _generate_y(planet.id+3,x)-planet.scale/20
			var bgy2 = _generate_y(planet.id+6,x)-planet.scale/10
			for j in range(rendDist/2):
				var grassNoise = FastNoiseLite.new()
				grassNoise.noise_type = FastNoiseLite.TYPE_CELLULAR
				grassNoise.seed = planet.id
				if j == 0 or j - grassNoise.get_noise_1d(x)*15 < rendDist/16:
					mainLayerC2.set_cell(Vector2i(x,y+j),1,Vector2i(0,0),0)
					backgroundLayer1.set_cell(Vector2i(x*1.5,bgy+j),1,Vector2i(0,0),0)
					if x%2 == 0:
						var dir = 1 if x<0 else -1
						backgroundLayer1.set_cell(Vector2i(x*1.5 + dir,bgy+j),1,Vector2i(0,0),0)
					backgroundLayer2.set_cell(Vector2i(x*2,bgy2+j),1,Vector2i(0,0),0)
					backgroundLayer2.set_cell(Vector2i(x*2+1,bgy2+j),1,Vector2i(0,0),0)
				else:
					mainLayerC1.set_cell(Vector2i(x,y+j),0,Vector2i(0,0),0)
					backgroundLayer1.set_cell(Vector2i(x*1.5,bgy+j),0,Vector2i(0,0),0)
					if x%2 == 0:
						var dir = 1 if x<0 else -1
						backgroundLayer1.set_cell(Vector2i(x*1.5 + dir,bgy+j),0,Vector2i(0,0),0)
					backgroundLayer2.set_cell(Vector2i(x*2,bgy2+j),0,Vector2i(0,0),0)
					backgroundLayer2.set_cell(Vector2i(x*2+1,bgy2+j),0,Vector2i(0,0),0)
			noise.seed = planet.id + 1
			if noise.get_noise_1d(x) < 0.15 and x%20==0 and loadedObjectX.find(x) == -1:
				var object = objects[random.randi_range(0,numObjects-1)]
				loadedObjectX.append(x)
				mainObjectLayerC1.set_pattern(Vector2i(x*10-1000,y*10-1000),object[0])
				mainObjectLayerC2.set_pattern(Vector2i(x*10-1000,y*10-1000),object[1])
			noise.seed = planet.id
	for x in loadedX:
		if newLoadedX.find(x) == -1:
			var y = _generate_y(planet.id,x)
			var bgy = _generate_y(planet.id+3,x)-planet.scale/20
			var bgy2 = _generate_y(planet.id+6,x)-planet.scale/10
			for j in range(rendDist/2):
				mainLayerC1.erase_cell(Vector2i(x,y+j))
				mainLayerC2.erase_cell(Vector2i(x,y+j))
				backgroundLayer1.erase_cell(Vector2i(x*1.5,bgy+j))
				if x%2 == 0:
					var dir = 1 if x<0 else -1
					backgroundLayer1.erase_cell(Vector2i(x*1.5 + dir,bgy+j))
				backgroundLayer2.erase_cell(Vector2i(x*2,bgy2+j))
				backgroundLayer2.erase_cell(Vector2i(x*2+1,bgy2+j))
	#for object in loadedObjects:
		#if newLoadedX.find((object[1].x+1000)/10) == -1:
			#var cells = object[0][0].get_used_cells()
			#for cell in cells:
				#mainObjectLayerC1.set_cell(cell+object[1],-1)
			#cells = object[0][1].get_used_cells()
			#for cell in cells:
				#mainObjectLayerC2.set_cell(cell+object[1],-1)
			#loadedObjects.erase(object)
	loadedX = newLoadedX
	
func _generate_y(seed, x) -> int:
	noise.seed = seed
	var terrain = noise.get_noise_1d(x/100)*planet.scale
	noise.seed = seed+1
	var hills = noise.get_noise_1d(x/10)*planet.scale/2
	noise.seed = seed+2
	var bumps = noise.get_noise_1d(x)*planet.scale/4
	noise.seed = seed
	return terrain + hills + bumps

func _pause() -> void:
	generating = false

func _resume() -> void:
	generating = true
	
func _clear() -> void:
	mainLayerC1.clear()
	mainLayerC2.clear()
	backgroundLayer1.clear()
	backgroundLayer2.clear()
	mainObjectLayerC1.clear()
	mainObjectLayerC2.clear()
	loadedX = []
	loadedObjectX = []
	objects = []
	
func _gen_planet(p) -> void:
	planet = p
	mainLayerC1.modulate = planet.colors[0]
	mainLayerC2.modulate = planet.colors[1]
	mainObjectLayerC1.modulate = planet.colors[0]
	var color = planet.colors[2]
	color.a = 0.7
	mainObjectLayerC2.modulate = color
	backgroundLayer1.modulate = planet.colors[0]
	backgroundLayer2.modulate = planet.colors[0]
	player.gravity = int(planet.size)
	player.position = Vector2(0,-100)
	random.seed = planet.id
	for i in range(numObjects):
		objects.append(Objects._generatePlant(planet.id+i))

func _process(delta: float) -> void:
	timer += delta
	backgroundLayer1.position = player.position/4
	backgroundLayer2.position = player.position/2
	if timer > 1 and generating:
		timer = 0
		_generate(get_node("Player").position)
