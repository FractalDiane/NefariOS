extends Light

export(bool) var start_on_ready = false
export(float) var on_duration = 12
export(float) var max_brightness = 8
export(float) var min_brightness = 3
export(bool) var chaos = false
export(float) var on_swing = 3
export(float) var min_wait = 1
export(float) var max_wait = 3

var _timer

# _mode refers to the on-off state
# 0 = off
# 1 = on
# 2 = timer waiting
var _mode = 0


# _state refers to the color and flicker amount
# 0 - healthy
# 1 - bad
# 2 - badder
# 3 - baddest
var _state = 0

var _noise
var _i = 0

var _state_max_brightness = max_brightness

func _ready():
	# Create a timer for looping and chaos
	randomize()
	_timer = Timer.new()
	_timer.connect("timeout", self, "_timeout_handler")
	_timer.set_one_shot(true)
	add_child(_timer)
	
	set_param(Light.PARAM_ENERGY, (max_brightness + min_brightness) / 2)
	
	_noise = OpenSimplexNoise.new()
	_noise.set_octaves(1)
	
	switch_state(0)
	
	if start_on_ready:
		on()
	else:
		off()


func on():
	if chaos:
		_timer.set_wait_time(randf() * (max_wait - min_wait) + min_wait)
		_timer.start()
		_mode = 2
	else:
		set_param(Light.PARAM_ENERGY, (max_brightness + min_brightness) / 2)
		_mode = 1


func off():
	_timer.stop()
	set_param(Light.PARAM_ENERGY, 0)
	_mode = 0
	
	
func switch_state(s):
	_timer.stop()
	match s:
		0:
			chaos = false
			_state_max_brightness = max_brightness
			set_color('00ff00')
		1: 
			chaos = true
			_timer.set_wait_time(randf() * (max_wait - min_wait) + min_wait)
			_noise.set_period(8)
			_state_max_brightness = max_brightness * 0.8
			set_color('ffff00')
			_timer.start()
			_mode = 2
		2:
			chaos = true
			_timer.set_wait_time(randf() * (max_wait - min_wait) + min_wait)
			_noise.set_period(4)
			_state_max_brightness = max_brightness * 0.5
			set_color('ff7f00')
			_timer.start()
			_mode = 2
		3:
			chaos = true
			_timer.set_wait_time(randf() * (max_wait - min_wait) + min_wait)
			_noise.set_period(1)
			_state_max_brightness = max_brightness * 0.2
			set_color('ff0000')
			_timer.start()
			_mode = 2
	
	_state = s

func _timeout_handler():
	match _mode:
		2:
			_timer.set_wait_time(on_duration + (randf() * on_swing * 2) - on_swing )
			_timer.start()
			set_param(Light.PARAM_ENERGY, 0)
			_mode = 1
		1:
			_timer.set_wait_time(randf() * (max_wait - min_wait) + min_wait)
			_timer.start()
			_mode = 2
			

func _physics_process(delta):
	match _mode:
		1:
			#set_param(Light.PARAM_ENERGY, randf() * (max_brightness - min_brightness) + min_brightness)
			if chaos:
				_i += 0.5
				set_param(Light.PARAM_ENERGY, (_noise.get_noise_1d(_i) + 1 )/2 * (_state_max_brightness - min_brightness) + _state_max_brightness)
				if _i > 5000:
					_i = 0
		2:
			set_param(Light.PARAM_ENERGY, 0)
		
