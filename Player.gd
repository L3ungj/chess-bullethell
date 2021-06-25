extends Area2D

var pos = Vector2(192,584)
const SCROLLSPEED = 1
const SHOOTSPEED = 25
const HITTIME = 5
const COLLIDEDMG = 60
var types = ['P', 'N','B', 'R', 'K', 'Q']
var type = 0
var side = 0
var health = 5
var hitted = 0
var properties = {
	'K': [[0,1,1], [45,1,1], [90,1,1], [135,1,1], [180,1,1], [225,1,1], [270,1,1], [315,1,1]],
	'P': [[315,1,1], [45,1,1]],
	'N': [[30,2,0.7], [330,2,0.7]],
	'R': [[0,2,-1],[90,2,-1],[180,2,-1], [270,2,-1]],
	'Q': [[0,2,-1], [45,2,-1], [90,2,-1], [135,2,-1], [180,2,-1], [225,2,-1], [270,2,-1], [315,2,-1]],
	'B': [[45,2,-1], [135,2,-1], [225,2,-1], [315,2,-1]]
	}
var Bullet = preload("res://Bullet.tscn")

var a=0
func scroll():
	if a == 0:
		$ParallaxBackground/bg.position.y += 1
		$ParallaxBackground/bg2.position.y += 1
		if $ParallaxBackground/bg.position.y == 700:
			$ParallaxBackground/bg.position.y = -700
		if $ParallaxBackground/bg2.position.y == 700:
			$ParallaxBackground/bg2.position.y = -700
	a = (a+1)%SCROLLSPEED

var b=0
func shoot():
	if b == 0:
		$shoot.play()
		for property in properties[types[type]]:
			var bullet = Bullet.instance()
			bullet.start(position, property[1]*128, deg2rad(property[0]), property[2], 0.5,0)
			get_parent().add_child(bullet)
	b = (b+1)%SHOOTSPEED

func _input(event):
	if event is InputEventMouseMotion:
		pos = event.position
		position = pos
		$ParallaxBackground/bg.position.x = -180 - pos.x/10
		$ParallaxBackground/bg2.position.x = -180 - pos.x/10
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and event.pressed == true:
			changeType((type + 1) % len(types))

func changeType(typ):
	type = typ
	$Sprite.play(types[type])

var cd = 0
func _process(delta):
	cd = max(cd-1, 0)
	scroll()
	shoot()
	if hitted >0:
		$Sprite.self_modulate = Color(1, 0, 0)
		hitted -= 1
	else:
		$Sprite.self_modulate = Color(1, 1, 1)
	
func getside():
	return side

func hit():
	$hit.play()
	hitted = HITTIME
	health -= 1
	if health <= 0:
		get_tree().change_scene("res://Died.tscn")


func _on_Player_area_entered(area):
	if area.has_method("hit"):
		if cd <= 0:
			cd = COLLIDEDMG
			health -= 1
			if health <= 0:
				get_tree().change_scene("res://Died.tscn")
			area.health -= 1
			if area.health <= 0:
				area.queue_free()

