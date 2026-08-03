extends Control

@onready var botao_computador = $BotaoComputador
@onready var botao_porta = $Button_porta_sala
@onready var anim = $AnimationPlayer
@onready var clique = $Clique


func _ready():
	print("Cena carregada")
	botao_computador.pressed.connect(_entrar_no_pc)
	botao_porta.pressed.connect(_porta_sala)
	
	clique.visible = false

func _porta_sala():

	if !DadosOperador.cadastro_concluido:
		clique.text = ">> Faça o cadastro no computador antes de sair."
		clique.visible = true

		await get_tree().create_timer(2.0).timeout

		clique.visible = false
		return

	botao_porta.disabled = true
	get_tree().change_scene_to_file("res://Cenas/corredor.tscn")

func _entrar_no_pc():
	print("Botão clicado")
	botao_computador.disabled = true
	anim.play("entrar_pc")

	await anim.animation_finished

	print("Mudando de cena")
	get_tree().change_scene_to_file("res://Cenas/computador.tscn")
