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
var mainObjectLayerC3
var generating = false
var loadedX = []
var loadedObjects = []
var biomeObjects = []
var biomes
var planet
var player
var noise = FastNoiseLite.new()
var biomeNoise = FastNoiseLite.new()
var objectNoise = FastNoiseLite.new()
var random = RandomNumberGenerator.new()
var xRandom = RandomNumberGenerator.new()

var tiles = {
	"Grass_0" = 1,
	"Grass_1" = 2,
	"Dirt_0" = 0,
	"Dirt_1" = 3,
	"Dirt_2" = 4
}

func _ready() -> void:
	mainLayerC1 = get_node("MainLayer").get_node("C1")
	mainLayerC2 = get_node("MainLayer").get_node("C2")
	backgroundLayer1 = get_node("BackgroundLayer1").get_node("C1")
	backgroundLayer2 = get_node("BackgroundLayer2").get_node("C1")
	mainObjectLayerC1 = get_node("MainObjectLayer").get_node("C1")
	mainObjectLayerC2 = get_node("MainObjectLayer").get_node("C2")
	mainObjectLayerC3 = get_node("MainObjectLayer").get_node("C3")
	player = get_node("Player")
	noise.noise_type = FastNoiseLite.TYPE_PERLIN

func _generate(pos) -> void:
	var newLoadedX = []
	for i in range(rendDist):
		var x = int(pos.x/32 + i - rendDist/2)
		xRandom.seed = x
		newLoadedX.append(x)
		if true: #loadedX.find(x) == -1:
			var y = _generate_y(planet.id,x)
			var bgy = _generate_y(planet.id+3,x)-planet.scale/20
			var bgy2 = _generate_y(planet.id+6,x)-planet.scale/10
			var bNoise = (biomeNoise.get_noise_1d(x/10)+1)/2
			var currentBiome = int(bNoise*biomes)
			print("Range: " + str(pos.y/32 - rendDist/4) + " - " + str(pos.y/32 + rendDist/4))
			for j in range(rendDist/2):
				var Y = int(pos.y/32 + j - rendDist/4)
				if Y == y:
					mainLayerC2.set_cell(Vector2i(x,y+Y),tiles[biomeObjects[currentBiome][0][4]],Vector2i(0,0),0)
					backgroundLayer1.set_cell(Vector2i(x*1.5,bgy+Y),tiles[biomeObjects[currentBiome][0][4]],Vector2i(0,0),0)
					if x%2 == 0:
						var dir = 1 if x<0 else -1
						backgroundLayer1.set_cell(Vector2i(x*1.5 + dir,bgy+Y),tiles[biomeObjects[currentBiome][0][4]],Vector2i(0,0),0)
					backgroundLayer2.set_cell(Vector2i(x*2,bgy2+Y),tiles[biomeObjects[currentBiome][0][4]],Vector2i(0,0),0)
					backgroundLayer2.set_cell(Vector2i(x*2+1,bgy2+Y),tiles[biomeObjects[currentBiome][0][4]],Vector2i(0,0),0)
				else: if Y > y:
					mainLayerC1.set_cell(Vector2i(x,y+Y),tiles[biomeObjects[currentBiome][0][3]],Vector2i(0,0),0)
					backgroundLayer1.set_cell(Vector2i(x*1.5,bgy+Y),tiles[biomeObjects[currentBiome][0][3]],Vector2i(0,0),0)
					if x%2 == 0:
						var dir = 1 if x<0 else -1
						backgroundLayer1.set_cell(Vector2i(x*1.5 + dir,bgy+Y),tiles[biomeObjects[currentBiome][0][3]],Vector2i(0,0),0)
					backgroundLayer2.set_cell(Vector2i(x*2,bgy2+Y),tiles[biomeObjects[currentBiome][0][3]],Vector2i(0,0),0)
					backgroundLayer2.set_cell(Vector2i(x*2+1,bgy2+Y),tiles[biomeObjects[currentBiome][0][3]],Vector2i(0,0),0)
			for j in range(3):
				var spacing = 20/int(pow(4,j))
				if objectNoise.get_noise_1d(x) < 0.15 and x%spacing==0:
					var count = 5*biomeObjects[currentBiome][0][j]-1
					if count > 0:
						var object = biomeObjects[currentBiome][j+1][xRandom.randi_range(0,count)]
						if object:
							loadedObjects.append([object,Vector2i(x*10-1000,y*10-1000)])
							mainObjectLayerC1.set_pattern(Vector2i(x*10-1000,y*10-1000),object[0])
							mainObjectLayerC2.set_pattern(Vector2i(x*10-1000,y*10-1000),object[1])
							mainObjectLayerC3.set_pattern(Vector2i(x*10-1000,y*10-1000),object[2])
	for x in loadedX:
		if true: #newLoadedX.find(x) == -1:
			var y = _generate_y(planet.id,x)
			var bgy = _generate_y(planet.id+3,x)-planet.scale/20
			var bgy2 = _generate_y(planet.id+6,x)-planet.scale/10
			for j in range(rendDist/2):
				var Y = int(pos.y/32 + j - rendDist/4)
				mainLayerC1.erase_cell(Vector2i(x,y+Y))
				mainLayerC2.erase_cell(Vector2i(x,y+Y))
				backgroundLayer1.erase_cell(Vector2i(x*1.5,bgy+Y))
				if x%2 == 0:
					var dir = 1 if x<0 else -1
					backgroundLayer1.erase_cell(Vector2i(x*1.5 + dir,bgy+Y))
				backgroundLayer2.erase_cell(Vector2i(x*2,bgy2+Y))
				backgroundLayer2.erase_cell(Vector2i(x*2+1,bgy2+Y))
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
	mainObjectLayerC3.clear()
	loadedX = []
	loadedObjects = []
	biomeObjects = []
	
func _gen_planet(p) -> void:
	planet = p
	mainLayerC1.modulate = planet.colors[0]
	mainLayerC2.modulate = planet.colors[1]
	mainObjectLayerC1.modulate = planet.colors[0]
	mainObjectLayerC2.modulate = planet.colors[1]
	var color = planet.colors[2]
	color.a = 0.7
	mainObjectLayerC3.modulate = color
	backgroundLayer1.modulate = planet.colors[0]
	backgroundLayer2.modulate = planet.colors[0]
	player.gravity = int(planet.size)
	player.position = Vector2(0,-100)
	random.seed = planet.id
	noise.seed = planet.id
	biomeNoise.seed = planet.id+1
	objectNoise.seed = planet.id+2
	biomes = random.randi_range(3,10)
	for biome in range(biomes):
		var largeObjects = random.rand_weighted([1,8])
		var mediumObjects = random.rand_weighted([1,8,4])
		var smallObjects = random.rand_weighted([1,2,8,4])
		var dirt = "Dirt_" + str(random.randi_range(0,2))
		var grass = "Grass_" + str(random.randi_range(0,1))
		biomeObjects.append([[largeObjects,mediumObjects,smallObjects,dirt,grass]])
		for objectType in range(3):
			var count = largeObjects if objectType == 0 else mediumObjects if objectType == 1 else smallObjects
			biomeObjects[biome].append([])
			for i in range(count):
				for j in range(5):
					biomeObjects[biome][objectType+1].append(Objects._generatePlant(planet.id+biome*biomes+objectType*5+i*count+j,objectType,planet.id+biome*biomes+objectType*5+i))

func _process(delta: float) -> void:
	timer += delta
	backgroundLayer1.position = player.position/4
	backgroundLayer2.position = player.position/2
	if timer > 1 and generating:
		timer = 0
		_generate(get_node("Player").position)
