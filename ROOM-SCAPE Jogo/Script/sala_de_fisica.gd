extends Control

@onready var botao_voltar = $BotaoVoltar

func _ready():
	botao_voltar.pressed.connect(_voltar)
	
func _voltar():
	botao_voltar.disabled = true

	#anim.play("sair_pc")

	#await anim.animation_finished

	get_tree().change_scene_to_file("res://Cenas/corredor_salas.tscn")
