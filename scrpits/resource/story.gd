class_name Story
extends Resource

@export_category("故事信息")
@export var type:String
@export var required_flag:Array[String]
@export var not_flag:Array[String]
@export var priority: int

@export_category("故事内容")
@export var story:Script
