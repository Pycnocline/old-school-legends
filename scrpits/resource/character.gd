class_name Character
extends Resource

@export_group("信息")
@export var name: String
@export var position: Destination

@export_group("数据")
@export var data: Array[PlayerData]
@export var flag: Array[String]
@export var bag: Array[Item]
