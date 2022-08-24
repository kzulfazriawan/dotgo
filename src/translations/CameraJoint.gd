extends Spatial
class_name CameraJoint


# Resource for Playable actors
# --
# This class is for manage and calculate the math rotation and translation degress from mouse motion
# set this class into the root joint from your playable actors, it's only work for 3rd person view &
# 1st person view.
class Rotation:
	var _sensitivity: float
	var _mouseMotion: InputEventMouseMotion
	var _jointAxis: Spatial
	
	func _init(_value: int):
		assert(_value > 0, "ERROR! value must be set on sensitivity and it must be > 0")
		self._sensitivity = float(_value) / 1000
	
	func set_input_motion(_input: InputEventMouseMotion):
		self._mouseMotion = _input
	
	func set_joint_axis(_joint: Spatial):
		self._jointAxis = _joint
	
	# -- use this method for the rotate_x on horizontal joint from your node --
	func get_rotate_x():
		return deg2rad(-self._mouseMotion.relative.y * self._sensitivity)
	
	# -- use this method for the rotate_y on vertical joint from your node --
	func get_rotate_y():
		return deg2rad(self._mouseMotion.relative.x * self._sensitivity * -1)
	
	# -- this method will return the Vector3 from rotation_degress from your main joint and reset --
	func get_translated_rotation():
		var _tmp = self._jointAxis.rotation_degrees
		_tmp.x = clamp(_tmp.x, -75, 75)
		return _tmp
