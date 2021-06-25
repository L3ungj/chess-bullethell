extends Control

var cooldown = [0,0,0,0,0,0]
var DEFCOOLDOWN = [0, 10, 15 , 20, 30, 60]
var DEFREMTIME = [0,5,5,5,5,5]
var remtime = -1
var types = ['P', 'N','B', 'R', 'K','Q']


func _process(delta):
	for i in range(1,len(cooldown)):
		if cooldown[i] == -1: continue
		if cooldown[i] > 0: cooldown[i] -= delta
		if cooldown[i] < 0: cooldown[i] = 0
		var tmp = "" if cooldown[i] == 0 else str(round(cooldown[i])) 
		get_node("GridContainer/" + types[i]+ "/Label").text = tmp
		
	if remtime != -1 and remtime <= 0:
		remtime = -1
		get_node("../Player").changeType(0)
	if remtime != -1: remtime -= delta


func _on_button_pressed(extra_arg_0):
	if extra_arg_0 == 0:
		get_node("../Player").changeType(0)
		return
	if cooldown[extra_arg_0] == 0:
		cooldown[extra_arg_0] = DEFCOOLDOWN[extra_arg_0]
		remtime = DEFREMTIME[extra_arg_0]
		get_node("../Player").changeType(extra_arg_0)

func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		var key = event.scancode - KEY_0
		if 1 <= key and key <= 6:
			_on_button_pressed(key-1)
