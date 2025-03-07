extends Control

@onready var rich_text_label: RichTextLabel = $ColorRect/VBoxContainer/RichTextLabel

func print_region_info(text: String) -> void:
	rich_text_label.clear()
	rich_text_label.append_text(text)
