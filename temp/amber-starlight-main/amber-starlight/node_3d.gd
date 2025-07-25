extends CharacterBody2D
@export var speed = 800
@export var gravity = 800
var Uni = Universe.new(1,10,10)

func _physics_process(delta: float) -> void:
	velocity.y += gravity*delta
	
	if Input.is_action_pressed("left"):
		velocity.x = -speed
	else: if Input.is_action_pressed("right"):
		velocity.x = speed
	else: velocity.x = 0
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = -speed
	
	if Input.is_action_just_pressed("change_planet"):
		get_parent()._pause()
		get_parent()._clear()
		var p = Uni.universe.pick_random().planets.pick_random()
		print(p)
		get_parent()._gen_planet(p)
		get_parent()._resume()
		
	move_and_slide()
	self.get_parent().find_child("Camera2D").position = position
