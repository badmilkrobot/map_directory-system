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
	info_box.print_region_info(info_box.print_threat_data(get_region_data("red")))


## Callback when test2 button is pressed
func _on_test2_pressed() -> void:
	info_box.show()
	info_box.print_region_info(info_box.print_threat_data(get_region_data("blue")))


## Callback when test3 button is pressed
func _on_test3_pressed() -> void:
	info_box.show()
	info_box.print_region_info(info_box.print_threat_data(get_region_data("green")))


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
				for data_set in json_data:
					if "uid" in data_set:
						region_data[data_set["uid"]] = data_set
					print("Loaded data for " + data_set["attack_name"])
			file_name = data_directory_access.get_next()

		print(region_data)

		data_directory_access.list_dir_end()
	else:
		print("Error: Could not access data directory")

## Returns a dictionary of region data based on the region_id
## region_id: The region id to search for
func get_region_data(region_id: String) -> Dictionary:
	var region_data_set: Dictionary = {}
	var region_data_id: int = 0
	for data_set in region_data:
		print(data_set)
		if region_data[data_set]["region"] == region_id:
			region_data_set[region_data_id] = region_data[data_set]
			region_data_id += 1
		else:
			print("Error: Could not find region data for " + region_id)

	return region_data_set
