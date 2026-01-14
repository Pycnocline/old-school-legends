class_name PlayerState
extends Resource

@export_group("玩家信息")
@export var name: String
@export var position: Destination

@export_group("玩家数据")
@export var data: Array[PlayerData]
@export var flag: Array[String]
@export var bag: Array[Item]
