extends Control

@onready var clique = $Clique
@onready var botao_voltar = $BotaoVoltar


func _ready():
	clique.visible = true
	clique.text = ">> Escolha uma sala para iniciar."
	botao_voltar.pressed.connect(_voltar)

func _voltar():
	botao_voltar.disabled = true

	#anim.play("sair_pc")

	#await anim.animation_finished

	get_tree().change_scene_to_file("res://Cenas/corredor.tscn")

func _on_biologia_pressed() -> void:
	print("Biologia")
	# Quando criar a cena:
	get_tree().change_scene_to_file("res://Cenas/sala_de_hibernação.tscn")


func _on_quimica_pressed() -> void:
	print("Química")
	get_tree().change_scene_to_file("res://Cenas/sala_de_quimica.tscn")


func _on_fisica_pressed() -> void:
	print("Física")
	get_tree().change_scene_to_file("res://Cenas/sala_de_fisica.tscn")
