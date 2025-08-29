extends OverlaidMenu


func _ready():
	%MainMenu.pressed.connect(_on_main_menu_pressed)
	%Restart.pressed.connect(_on_restart_pressed)

	if is_instance_valid(SceneManager.main):
		%ScoreLabel.text = str(SceneManager.main.score)


func _on_main_menu_pressed():
	SceneManager.load_main_menu()
	close()


func _on_restart_pressed():
	SceneManager.load_game_scene()
	close()
