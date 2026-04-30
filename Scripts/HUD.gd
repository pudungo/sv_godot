extends CanvasLayer

@onready var coin_label = $CoinLabel


func _ready():
 CollectibleManager.collectibles_updated.connect(update_ui)
 update_ui()

func update_ui():
 coin_label.text = "Coins: " + str(  # text displayed in HUD scene
 CollectibleManager.get_amount(CollectibleManager.CollectibleType.COIN) )
