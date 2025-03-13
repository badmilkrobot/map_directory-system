extends Control

@onready var rich_text_label: RichTextLabel = $ColorRect/VBoxContainer/RichTextLabel

func _ready() -> void:
	rich_text_label.connect("meta_clicked", _on_meta_clicked)


func _on_meta_clicked(meta: String) -> void:
	OS.shell_open(meta)


func print_region_info(text: String) -> void:
	rich_text_label.clear()
	rich_text_label.append_text(text)


func print_threat_data(data: Dictionary) -> String:
	var threat_text: String = ""
	if not data:
		return "No data available"
	else:
		for threat in data:
			threat_text += "------Threat------" + "\n"
			threat_text += "[rainbow freq=1.0 sat=0.8 val=0.8 speed=1.0][b]Group: [/b][/rainbow]" + str(data[threat]["group"]) + "\n"
			threat_text += "[b]Attack Name: [/b]" + str(data[threat]["attack_name"]) + "\n"
			threat_text += "[b]Description: [/b]" + str(data[threat]["description"]) + "\n"
			threat_text += "[b]Origin: [/b]" + str(data[threat]["origin"]) + "\n"
			threat_text += "[b]Region: [/b]" + str(data[threat]["region"]) + "\n"
			threat_text += "[b]Country: [/b]" + str(data[threat]["country"]) + "\n"
			threat_text += "[b]Date: [/b]" + str(data[threat]["date"]) + "\n"
			threat_text += "[b]Link: [/b]" + "[color=blue][url]" + str(data[threat]["info_link"]) + "[/url][/color]" + "\n\n"

	return threat_text
