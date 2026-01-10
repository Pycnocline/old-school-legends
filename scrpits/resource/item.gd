class_name Item
extends Resource

@export_category("物品基本信息")
@export var id: String
@export var name: String
@export var description: String
@export var price: int

@export_category("类型和标签")
@export_enum("消耗品", "素材", "道具", "重要物品", "装备") var type
@export var flag: Array[String]

@export_category("功能和方法")
@export var action: Dictionary[String, Action]
