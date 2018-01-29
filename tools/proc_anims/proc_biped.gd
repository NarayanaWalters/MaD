extends Node2D

export var foot_size = 10
export var toe_size = 6
export var stride_length = 70
export var chassis_width = 60
export var chassis_height = 20
export var leg_width = 3
export var hinge_back_dis = 10
export var osc_speed = 10
export var osc_angle = 10
export var foot_move_speed = 10
onready var chassis = get_node("Chassis")
onready var foot1 = chassis.get_node("Foot1")
onready var foot2 = chassis.get_node("Foot2")


func _ready():
	chassis.stride_length = stride_length
	chassis.osc_speed = osc_speed
	chassis.osc_angle = osc_angle
	chassis.foot_move_speed = foot_move_speed
	foot1.foot_size = foot_size
	foot1.toe_size = toe_size
	foot2.foot_size = foot_size
	foot2.toe_size = toe_size
	chassis.chassis_width = chassis_width
	chassis.chassis_height = chassis_height
	chassis.hinge_back_dis = hinge_back_dis
	chassis.leg_width = leg_width
