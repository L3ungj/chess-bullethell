extends Area2D

var shootspeed = 0
var types = ['P', 'N','B', 'R', 'K', 'Q']
var type = 0
var side = -1
var move = []
var movecycle = 0
var health = 0
var hitted = 0
const HITTIME = 5
var properties = {
	'K': [[0,1,1], [45,1,1], [90,1,1], [135,1,1], [180,1,1], [225,1,1], [270,1,1], [315,1,1]],
	'P': [[315,1,1], [45,1,1]],
	'N': [[30,2,0.7], [330,2,0.7]],
	'R': [[0,2,-1],[90,2,-1],[180,2,-1], [270,2,-1]],
	'Q': [[0,2,-1], [45,2,-1], [90,2,-1], [135,2,-1], [180,2,-1], [225,2,-1], [270,2,-1], [315,2,-1]],
	'B': [[45,2,-1], [135,2,-1], [225,2,-1], [315,2,-1]]
	}
var Bullet = preload("res://Bullet.tscn")

func start(enemy):
	position = enemy[0]
	move = enemy[1]
	movecycle = enemy[2]
	scale = Vector2(enemy[3], enemy[3])
	shootspeed = enemy[4]
	type = enemy[5]
	$Sprite.play(types[type])
	health = enemy[6]

var b=0
func shoot():
	if b == 0:
		$shoot.play()
		for property in properties[types[type]]:
			var bullet = Bullet.instance()
			bullet.start(position, property[1]*128, deg2rad(property[0]), property[2], 0.5, 1)
			get_parent().add_child(bullet)
	b = (b+1)%shootspeed

var a = 0
var pos = -1
func _process(delta):
	shoot()
	if hitted >0:
		$Sprite.self_modulate = Color(1, 0, 0)
		hitted -= 1
	else:
		$Sprite.self_modulate = Color(1, 1, 1)
	if pos+1 < len(move) and move[pos+1][0] <= a:
		pos += 1
	var vec2 = Vector2(move[pos][1], move[pos][2]) * delta * 64
	position += vec2
	a += 1
	if a == movecycle:
		a = 0
		pos = -1

func getside():
	return side
	
func hit():
	$hit.play()
	hitted = HITTIME
	health -= 1
	if health <= 0:
		queue_free()
