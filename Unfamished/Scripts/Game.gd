extends Spatial

export var money_balance: float

onready var money_text = $"../Main/GamePlay/Money/Amount"

onready var inventory = $"../Main/Shop/Inventory/ScrollContainer/InventoryContents"

onready var shop_button

var happiness: float

var current_item
var current_transform

func _ready():
	money_balance = 1000
	_update_money_amount(0)

func _update_money_amount(amount):
	money_balance += amount
	print(money_balance)
	if money_text:
		money_text.set_text("$" + str(money_balance))

func _input(event):
	if current_item != null and Input.get_action_strength("right_click"):
		for item in inventory.get_children():
			item._placement_cancelled()
