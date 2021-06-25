extends Area2D

var velocity = Vector2(0,0)
var lifetime = 1
var type = 0 #self bullets

func start(pos, spd, dir, t, size, side):
	position = pos
	rotation = dir
	scale = Vector2(size,size)
	type = side
	$AnimatedSprite.play(String(side))
	lifetime = t
	if lifetime == -1:
		lifetime = 1000000
	velocity = Vector2(0,-spd).rotated(dir + PI*side)

func _physics_process(delta):
	position += velocity*delta
	if lifetime <= 0:
		queue_free()
	lifetime -= delta
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Bullet_area_entered(area):
	if not area.has_method("getside"):
		return
	if area.getside() == 0 and type == 1:
		area.hit()
		queue_free()
	if area.getside() == -1 and type == 0:
		area.hit()
		queue_free()
