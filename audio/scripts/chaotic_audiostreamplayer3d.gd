extends AudioStreamPlayer3D

#class_name ChaoticAudioStreamPlayer3D

export(Array, AudioStream) var streams
export(bool) var chaos = true
export(float) var max_delay = 0.5
export(float) var min_delay = 0
export(float, 0, 1) var pitch_shift = 0

# 0 - not playing
# 1 - playing once
# 2 - playing forever
# 3 - waiting
var _mode = 0
var _timer


func _ready():
	randomize()
	_timer = Timer.new()
	_timer.connect("timeout", self, "_timeout_handler")
	_timer.set_one_shot(true)
	add_child(_timer)
	play_forever()

func play_once():
	_queue_and_play()
	_mode = 1

func play_forever():
	_mode = 2
	
func stop():
	stop()
	_mode = 0

func _timeout_handler():
	_queue_and_play()
	_mode = 2

func _queue_and_play():
	if chaos:
		var scale_to = 1 - (randf() * (pitch_shift * 2)) + pitch_shift
		set_pitch_scale(scale_to)
		print(scale_to)
	var index = randi() % len(streams)
	set_stream(streams[index])
	play()
	
func _process(delta):
	if !playing:
		match _mode:
			2:
				if !chaos:
					_queue_and_play()
				else:
					var wait = (randf() * (max_delay - min_delay)) + min_delay
					_timer.set_wait_time(wait)
					_timer.start()
					_mode = 3

