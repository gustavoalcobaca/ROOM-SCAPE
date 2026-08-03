extends Control

@onready var botao_voltar = $BotaoVoltar
@onready var area_salas = $AreaSala




func _ready():
	area_salas.input_event.connect(_clicou_area)
	
	botao_voltar.pressed.connect(_voltar)

func _voltar():
	botao_voltar.disabled = true

	#anim.play("sair_pc")

	#await anim.animation_finished

	get_tree().change_scene_to_file("res://Cenas/telainicial.tscn")

@warning_ignore("unused_parameter")
func _clicou_area(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		print("Entrando no corredor das salas")
		get_tree().change_scene_to_file("res://Cenas/corredor_salas.tscn")
