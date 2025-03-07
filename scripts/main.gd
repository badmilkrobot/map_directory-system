extends Node2D

@onready var test_1: TextureButton = $test1
@onready var test_2: TextureButton = $test2
@onready var test_3: TextureButton = $test3
@onready var info_box: Node = $UILayer/InfoBox

var region_data: Dictionary = {}


func _ready():
	info_box.hide()
	load_data()
	test_1.connect("pressed", _on_test1_pressed)
	test_2.connect("pressed", _on_test2_pressed)
	test_3.connect("pressed", _on_test3_pressed)


## Callback when test1 button is pressed
func _on_test1_pressed() -> void:
	info_box.show()
	info_box.print_region_info("[center][b]Red Region[/b][/center]\nThis is a test of the info box system.")


## Callback when test2 button is pressed
func _on_test2_pressed() -> void:
	info_box.show()
	info_box.print_region_info("[center][b]Blue Region[/b][/center]\nThis is a test of the info box system.")


## Callback when test3 button is pressed
func _on_test3_pressed() -> void:
	info_box.show()
	info_box.print_region_info("[center][b]Green Region[/b][/center]\nThis is a test of the info box system.")


## Loads and parses data from the data folder
## Loads and parses JSON data files from the 'data' directory
func load_data() -> void:
	var data_directory_access = DirAccess.open("res://data")
	if data_directory_access:
		data_directory_access.list_dir_begin()
		var file_name = data_directory_access.get_next()

		while file_name != "":
			var current_file_path = "res://data/" + file_name
			var json_data = JSON.parse_string(FileAccess.get_file_as_string(current_file_path))
			if json_data:
				for region in json_data:
					if "region_name" in region:
						region_data[region["region_name"]] = region
				print("Loaded data from file")
			file_name = data_directory_access.get_next()

		data_directory_access.list_dir_end()
		print(region_data)
	else:
		print("Error: Could not access data directory")
