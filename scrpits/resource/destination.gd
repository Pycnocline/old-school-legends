class_name Destination
extends Resource

@export_group("目的地信息")
@export var id: String
@export var name: String
@export_multiline var description: String

@export_group("连接关系")
@export var exits: Array[ExitData]
