extends Node2D

export(String, FILE, "*.txt") var file_name
var moveset_name = 'res://moveset.txt'

var enemies = []
var Enemy = preload("res://Enemy.tscn")
var moveset = []

func _ready():
	var mfile = File.new()
	mfile.open(moveset_name, File.READ)
	var mcontent = mfile.get_as_text() 
	var dex = -1
	for line in mcontent.split('\n'):
		var arr = line.split(' ')
		if line == '' or arr[0] == '//': continue 
		if arr[0] == 'start':
			dex += 1
			moveset.append([[], int(arr[1])])
			continue
		moveset[dex][0].append([int(arr[0]), int(arr[1]), int(arr[2])])
	var file = File.new()
	file.open(file_name, File.READ)
	var content = file.get_as_text()
	var tmptime = -1
	var tmptype
	var movecycle
	var pos
	var size
	var shootspeed
	var hlth
	dex = -1
	for line in content.split('\n'):
		var arr = line.split(' ')
		if line == '' or arr[0] == '//': continue
		if arr[0] == 'enemy':
			dex += 1
			tmptime = float(arr[1])
			pos = Vector2(float(arr[2]),float(arr[3]))
			movecycle = int(arr[4])
			size = float(arr[5])
			shootspeed = int(arr[6])
			tmptype = int(arr[7])
			hlth = int(arr[8])
			enemies.append([tmptime, pos, [], movecycle, size, shootspeed, tmptype, hlth])
			continue
		if arr[0] == 'moveset':
			enemies[dex][2] = moveset[int(arr[1])][0]
			enemies[dex][3] = moveset[int(arr[1])][1]
			continue
		enemies[dex][2].append([int(arr[0]), int(arr[1]), int(arr[2])])
		
var gametime :float = 19
var gametick :float = 0
var epos = 0
func _process(delta):
	var t = gametime+gametick/60
	while true:
		if len(enemies) > epos and t > enemies[epos][0]:
			epos += 1
		elif len(enemies) > epos and t == enemies[epos][0]:
			var enemy = Enemy.instance()
			enemies[epos].pop_front()
			enemy.start(enemies[epos])
			add_child(enemy)
			epos += 1
		else: break
	gametick += 1
	if gametick == 60:
		gametime += 1
		gametick = 0
