extends Node2D
@export var rendDist = 200

var timer = 0
var mainLayerC1
var mainLayerC2
var backgroundLayer1
var backgroundLayer2
var mainObjectLayerC1
var mainObjectLayerC2
var generating = false
var planet
var player
var noise = FastNoiseLite.new()

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
	for i in range(rendDist):
		var x = int(pos.x/12.8 + i - rendDist/2)
		var y = _generate_y(planet.id,x)
		var bgy = _generate_y(planet.id+3,x)-planet.scale/20
		var bgy2 = _generate_y(planet.id+6,x)-planet.scale/10
		for j in range(rendDist/2):
			var grassNoise = FastNoiseLite.new()
			grassNoise.noise_type = FastNoiseLite.TYPE_CELLULAR
			grassNoise.seed = planet.id
			if j == 0 or j - grassNoise.get_noise_1d(x)*15 < rendDist/16:
				mainLayerC2.set_cell(Vector2i(x,y+j),1,Vector2i(0,0),0)
				backgroundLayer1.set_cell(Vector2i(x,bgy+j),1,Vector2i(0,0),0)
				backgroundLayer2.set_cell(Vector2i(x,bgy2+j),1,Vector2i(0,0),0)
			else:
				mainLayerC1.set_cell(Vector2i(x,y+j),0,Vector2i(0,0),0)
				backgroundLayer1.set_cell(Vector2i(x,bgy+j),0,Vector2i(0,0),0)
				backgroundLayer2.set_cell(Vector2i(x,bgy2+j),0,Vector2i(0,0),0)
			noise.seed = planet.id + 1
			if noise.get_noise_1d(x) < 0.15 and x%20==0:
				var object = Objects._generatePlant(x)
				for tile in object:
					if tile[1] == 0:
						mainObjectLayerC1.set_cell(Vector2i(x+tile[0].x,y+4+tile[0].y),tile[1],Vector2(0,0),0)
					else:
						mainObjectLayerC2.set_cell(Vector2i(x+tile[0].x,y+4+tile[0].y),tile[1],Vector2(0,0),0)
			noise.seed = planet.id
	
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
	
func _gen_planet(p) -> void:
	planet = p
	mainLayerC1.modulate = planet.colors[0]
	mainLayerC2.modulate = planet.colors[1]
	mainObjectLayerC1.modulate = planet.colors[0]
	mainObjectLayerC2.modulate = planet.colors[2]
	backgroundLayer1.modulate = planet.colors[0]
	backgroundLayer2.modulate = planet.colors[0]
	player.gravity = int(planet.size)
	player.position = Vector2(0,planet.scale/10)

func _process(delta: float) -> void:
	timer += delta
	backgroundLayer1.position = player.position/4
	backgroundLayer2.position = player.position/2
	if timer > 1 and generating:
		timer = 0
		_generate(get_node("Player").position)
