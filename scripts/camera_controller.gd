class_name CameraController

extends Camera2D
## Controls the camera's movement, zoom levels, and boundary limits.
##
## The class handles three types of camera controls:[br]
## - Zooming: Using camera_in and camera_out input actions[br]
## - Keyboard panning: Using camera_left/right/up/down input actions[br]
## - Mouse dragging: Using camera_pan input action[br]
##
## Requires markers to define the camera boundaries and input actions to be set up.


@export var zoom_speed: float = 10.00  ## Controls how quickly the camera zooms in and out.
@export var view_top: Marker2D  ## Marker defining the top boundary of camera movement.
@export var view_bottom: Marker2D  ## Marker defining the bottom boundary of camera movement.
@export var view_left: Marker2D  ## Marker defining the left boundary of camera movement.
@export var view_right: Marker2D  ## Marker defining the right boundary of camera movement.
@export var zoom_max: Vector2  ## Maximum zoom level (closest).
@export var zoom_min: Vector2  ## Minimum zoom level (furthest).

var zoom_target: Vector2  ## Target zoom level the camera interpolates toward.
var drag_mouse_start: Vector2 = Vector2.ZERO  ## Starting mouse position when dragging begins.
var drag_camera_start: Vector2 = Vector2.ZERO  ## Starting camera position when dragging begins.
var is_dragging: bool = false  ## Whether the camera is currently being dragged.


## Initializes the camera with appropriate zoom and boundary settings.
func _ready() -> void:
    zoom_target = zoom
    limit_top = int(view_top.position.y)
    limit_bottom = int(view_bottom.position.y)
    limit_left = int(view_left.position.x)
    limit_right = int(view_right.position.x)


## Process camera control inputs every frame
func _process(delta: float) -> void:
    zoom_camera(delta)
    pan_camera(delta)
    drag_camera()


## Handles camera zooming toward/away from mouse cursor position.
## Uses camera_in and camera_out input actions to control zoom level
## and interpolates smoothly between current zoom and target zoom.
## The camera zooms toward the mouse cursor position and respects map boundaries.
func zoom_camera(delta: float) -> void:
    var old_zoom = zoom
    var viewport_size = get_viewport_rect().size
    
    # Calculate the absolute minimum zoom based on world boundaries
    var world_width = abs(view_right.position.x - view_left.position.x)
    var world_height = abs(view_bottom.position.y - view_top.position.y)
    
    # Calculate zoom factors needed to fit the world in the viewport
    var zoom_x_min = viewport_size.x / world_width
    var zoom_y_min = viewport_size.y / world_height
    
    # Use the smaller value to ensure entire world fits in view
    var absolute_min_zoom = min(zoom_x_min, zoom_y_min)
    
    # Create a Vector2 for the absolute minimum zoom
    var absolute_min_zoom_vec = Vector2(absolute_min_zoom, absolute_min_zoom)
    
    # Use the larger of user-defined min zoom and calculated absolute min zoom
    var effective_min_zoom = Vector2(
        max(zoom_min.x, absolute_min_zoom_vec.x),
        max(zoom_min.y, absolute_min_zoom_vec.y)
    )

    if Input.is_action_just_pressed("camera_in") and zoom_target < zoom_max:
        zoom_target *= 1.1

    if Input.is_action_just_pressed("camera_out"):
        var potential_zoom = zoom_target * 0.9
        # Only zoom out if we're still within bounds
        if potential_zoom > effective_min_zoom:
            zoom_target = potential_zoom

    zoom = zoom.slerp(zoom_target, zoom_speed * delta)

    # Adjust position to zoom towards mouse cursor
    if zoom != old_zoom:
        var mouse_world_pos = get_global_mouse_position()
        position = position + (mouse_world_pos - position) * (1 - old_zoom.x / zoom.x)


## Handles keyboard-based camera panning. 
## Uses the input actions camera_left, camera_right, camera_up, and camera_down
## to move the camera in the respective directions. Movement speed is adjusted
## based on the current zoom level for consistent perceived speed.
func pan_camera(delta: float) -> void:
    var move_amount: Vector2 = Vector2.ZERO
    move_amount.x = Input.get_axis("camera_left", "camera_right")
    move_amount.y = Input.get_axis("camera_up", "camera_down")
    move_amount = move_amount.normalized()
    position += move_amount * delta * 1000 * (1/zoom.x)


## Handles mouse-based camera dragging. 
## Uses the camera_pan input action (typically mouse button)
## to drag the camera around. The camera follows the mouse
## movement in a direct and intuitive way.
func drag_camera() -> void:
    if !is_dragging and Input.is_action_just_pressed("camera_pan"):
        drag_mouse_start = get_viewport().get_mouse_position()
        drag_camera_start = position
        is_dragging = true

    if is_dragging and Input.is_action_just_released("camera_pan"):
        is_dragging = false

    if is_dragging:
        var drag_vector := get_viewport().get_mouse_position() - drag_mouse_start
        position = drag_camera_start - drag_vector * (1/zoom.x)