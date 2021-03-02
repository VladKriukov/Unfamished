extends GridContainer

export var items: = []

onready var spawner = $"../../../../GameItems"

func _ready():
	#_buy(5, 1)
	pass

func _buy(item_index, price):
	var current_item
	var item_scene
	var item_spawn
	#print(item_index)
	#print(Game.money_balance)
	if price <= Game.money_balance:
		match item_index:
			0:
				current_item = preload("res://UI/Items/Apple.tscn")
				item_scene = preload("res://Scenes/Apple.tscn")
			1:
				current_item = preload("res://UI/Items/Baguette.tscn")
				item_scene = preload("res://Scenes/Baguette.tscn")
			2:
				current_item = preload("res://UI/Items/Banana.tscn")
				item_scene = preload("res://Scenes/Banana.tscn")
			3:
				current_item = preload("res://UI/Items/CounterTop.tscn")
				item_scene = preload("res://Scenes/CounterTop.tscn")
			4:
				current_item = preload("res://UI/Items/CounterTopCorner.tscn")
				item_scene = preload("res://Scenes/CounterTopCorner.tscn")
			5:
				current_item = preload("res://UI/Items/Cabinet.tscn")
				item_scene = preload("res://Scenes/Cabinet.tscn")
			6:
				current_item = preload("res://UI/Items/Pan.tscn")
				item_scene = preload("res://Scenes/Pan.tscn")
			7:
				current_item = preload("res://UI/Items/Plate.tscn")
				item_scene = preload("res://Scenes/Plate.tscn")
			8:
				current_item = preload("res://UI/Items/Chair.tscn")
				item_scene = preload("res://Scenes/Chair.tscn")
			9:
				current_item = preload("res://UI/Items/CoffeeTable.tscn")
				item_scene = preload("res://Scenes/CoffeeTable.tscn")
			10:
				current_item = preload("res://UI/Items/Couch.tscn")
				item_scene = preload("res://Scenes/Couch.tscn")
			11:
				current_item = preload("res://UI/Items/Table.tscn")
				item_scene = preload("res://Scenes/Table1.tscn")
			12:
				current_item = preload("res://UI/Items/TableFancy.tscn")
				item_scene = preload("res://Scenes/Table2.tscn")
			13:
				current_item = preload("res://UI/Items/Wardrobe.tscn")
				item_scene = preload("res://Scenes/Wardrobe.tscn")
			14:
				current_item = preload("res://UI/Items/Crib.tscn")
				item_scene = preload("res://Scenes/Crib.tscn")
			15:
				current_item = preload("res://UI/Items/BabyDistractionToy.tscn")
				item_scene = preload("res://Scenes/BabyDistractionToy.tscn")
			16:
				current_item = preload("res://UI/Items/DrawingTable.tscn")
				item_scene = preload("res://Scenes/DrawingDeskFull.tscn")
			17:
				current_item = preload("res://UI/Items/Monitor.tscn")
				item_scene = preload("res://Scenes/Monitor.tscn")
			18:
				current_item = preload("res://UI/Items/Tablet.tscn")
				item_scene = preload("res://Scenes/Tablet.tscn")
			19:
				current_item = preload("res://UI/Items/TV.tscn")
				item_scene = preload("res://Scenes/WallTV.tscn")
			20:
				current_item = preload("res://UI/Items/FancyMonitor.tscn")
				item_scene = preload("res://Scenes/MonitorFancy.tscn")
		
		#spawns button in inventory
		self.add_child(current_item.instance(1))
		print(current_item._bundled.node_paths[3])
		
		#pools actual item into the game
		item_spawn = spawner.get_child(item_index)
		item_spawn.add_child(item_scene.instance(1))
		
		Game._update_money_amount(-price)
