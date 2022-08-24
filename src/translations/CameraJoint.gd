extends Spatial
class_name CameraJoint


# -- Rotation --
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
	
	# -- set the input value from event --
	func set_input_motion(_input: InputEventMouseMotion):
		self._mouseMotion = _input
	
	# -- registering the joint axis or joint aim --
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

# -- Arm --
# This class is helping to setting the arm movement for spring arm and camera by using the wheel or
# event action from project.
class Arm:
	var _step: float
	var _maxLength: int
	var _minLength: int
	var _armNode: SpringArm
	var _armMove: float
	
	func _init(_len: Array, _step: float):
		assert(_len[0] > 1, "ERROR! length minimum must be > 1")
		assert(_len[1] > 2, "ERROR! length maximum must be > 2")
		assert(_step > 0.1, "ERROR! step must be set to > .1")
		
		self._minLength = _len[0]
		self._maxLength = _len[1]
		self._step = _step
	
	# -- set the node spring arm, this will be helpful for 3rd person view --
	func set_node(_node: SpringArm):
		self._armNode = _node
	
	# -- set the input wheel action from event either arm is pulling or pushing --
	func set_input_wheel(_input: InputEventMouseButton):
		if _input.is_pressed():
			if _input.button_index == BUTTON_WHEEL_UP:
				self.pulling()
			elif _input.button_index == BUTTON_WHEEL_DOWN:
				self.pushing()
	
	# -- action arm is pulling --
	func pulling():
		self._armMove = self._step * 1
	
	# -- action arm is pushing --
	func pushing():
		self._armMove = self._step * -1
	
	# -- get length result for spring arm --
	func get_length():
		var _length = self._armNode.spring_length + self._armMove
		return _length if _length >= self._minLength and _length <= self._maxLength else null
		
