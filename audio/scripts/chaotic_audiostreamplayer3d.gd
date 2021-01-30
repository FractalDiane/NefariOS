extends AudioStreamPlayer3D

#class_name ChaoticAudioStreamPlayer3D

export(String) var bus_out = 'Master'
export(bool) var play_on_ready = false
export(Array, AudioStream) var streams
export(bool) var chaos = true
export(float) var max_delay = 0.5
export(float) var min_delay = 0
export(float, 0, 1) var pitch_shift = 0

signal volume_adjusted

# 0 - not playing
# 1 - playing once
# 2 - playing forever
# 3 - timer wait
var _mode = 0
var _timer
var _peak0 = -200
var _peak1 = -200
var _bus_index = 0
var _uid

func play_once():
	_queue_and_play()
	_mode = 1

func play_forever():
	_mode = 2
	
func stop():
	stop()
	_mode = 0

func _ready():
	# Create an audio bus to lsten to and hook onto later
	_uid = String(get_instance_id())
	AudioServer.add_bus()
	AudioServer.set_bus_name(AudioServer.bus_count - 1, _uid)
	# Redirect stream to new bus, redirect bus to prefered out bus
	set_bus(_uid)
	AudioServer.set_bus_send(AudioServer.bus_count - 1, bus_out)
	
	# Create a timer for looping and chaos
	randomize()
	_timer = Timer.new()
	_timer.connect("timeout", self, "_timeout_handler")
	_timer.set_one_shot(true)
	add_child(_timer)
	
	# Begin playing if enabled
	if play_on_ready:
		play_forever()

func _timeout_handler():
	_queue_and_play()
	_mode = 2

func _queue_and_play():
	if chaos:
		var scale_to = 1 - (randf() * (pitch_shift * 2)) + pitch_shift
		set_pitch_scale(scale_to)
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


func _physics_process(delta):
	# Calculate the average peaks on this stream's bus and emit a signal for it
	#
	# Note that for better performance, _bus_index should only be updated when
	# signal bus_layout_changed() from AudioServer is emitted
	_bus_index = AudioServer.get_bus_index(_uid)
	_peak0 = AudioServer.get_bus_peak_volume_left_db(_bus_index, 0)
	_peak1 = AudioServer.get_bus_peak_volume_right_db(_bus_index, 0)
	emit_signal("volume_adjusted", (_peak0 + _peak1)/2)

