extends CanvasLayer

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MASK_RIGHT and event.pressed:
			$InfoBox.hide()
