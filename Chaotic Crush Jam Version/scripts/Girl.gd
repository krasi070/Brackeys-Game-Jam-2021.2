extends Node2D

onready var poses := {
	Replies.POSE_DEFAULT: $DefaultPose,
	Replies.POSE_CHAOS: $ChaosPose,
	Replies.POSE_ORDER: $DefaultPose,
	Replies.POSE_LOVE: $LovePose
}


func show_pose(pose: String) -> void:
	_hide_all_poses()
	poses[pose].show()


func _hide_all_poses() -> void:
	for key in poses:
		poses[key].hide()
