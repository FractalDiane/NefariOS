extends Control


func play_ending() -> void:
	if GameLogic.target_files_found <= 0:
		$VoiceBad.play()
		$TextScale/Text.set_text("You didn't get a single one of them.\n\nI didn't really think you could be counted on, and you proved me right.\n\nI'm afraid this isn't going to end well for you.")
	elif GameLogic.target_files_found < 4:
		$VoiceMeh.play()
		$TextScale/Text.set_text("Well... you got some of them.\n\nNot all of them.\nI'm disappointed.\n\nHere's the payment. Just do better next time.")
	else:
		$VoiceBest.play()
		$TextScale/Text.set_text("Wow... you got them all.\nDidn't expect that.\n\nHere's the payment.\nI think I know who I'll be hiring next time.")
	
	$AnimationPlayer.play("Animation")


func quit_game() -> void:
	get_tree().quit()
