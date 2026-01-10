class_name Destination
extends Resource

@export_group("目的地信息")
@export var id: String
@export var name: String
@export_multiline var description: String

@export_group("内容物信息")
@export var item: Array[Item]
