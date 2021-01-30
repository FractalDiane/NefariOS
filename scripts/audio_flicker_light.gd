extends SpotLight


export(bool) var debug = false
export(float) var energy_max = 1.0
export(float) var energy_min = 0.0

export(int, -200, 0) var vol_threshold = -200	# The volume in which the light will light up
export(int, -200, 0) var vol_peak = 0			# The volume in which the light will be the brightest

var _streamer
var _peak_adjusted
var _energy_lerped


func _ready():
	set_param(Light.PARAM_ENERGY, 0)
	_streamer = get_node("ChaoticAudioStreamPlayer3D")
	_streamer.connect("volume_adjusted", self, "_on_volume_adjusted")

func _on_volume_adjusted(peak):
	if debug:
		print(peak)
		
	if peak == -200 || peak == 0:
		set_param(Light.PARAM_ENERGY, energy_min)
		return
		
	_peak_adjusted = clamp(abs((peak - vol_threshold) / (vol_peak - vol_threshold)), 0, 1)
	_energy_lerped = lerp(energy_min, energy_max, _peak_adjusted)
	set_param(Light.PARAM_ENERGY, _energy_lerped)
	
	
