extends Control

# ==================================================
# REFERÊNCIAS AOS NÓS
# ==================================================

@onready var terminal = $Boot/Terminal
@onready var logo = $Boot/Logo
@onready var clique = $Boot/Clique
@onready var botao_voltar = $BotaoVoltar
@onready var anim = $AnimationPlayer
@onready var nome_input = $Boot/NomeOperador
@onready var painel_materia = $Desktop/PainelMateria
@onready var nome_materia = $Desktop/PainelMateria/NomeMateria
@onready var barra_materia = $Desktop/PainelMateria/BarraMateria
@onready var texto_materia = $Desktop/PainelMateria/TextoMateria
@onready var assuntos = $Desktop/PainelMateria/Assuntos

# ==================================================
# VARIÁVEIS
# ==================================================

var boot_finalizado := false

# ==================================================
# INICIALIZAÇÃO
# ==================================================

func _ready():

	terminal.bbcode_enabled = true

	botao_voltar.pressed.connect(_voltar)

	atualizar_desktop()
	
	$Desktop/PainelMateria.visible = false

	if DadosOperador.cadastro_concluido:
		$Boot.visible = false
		$Desktop.visible = true
		return

	# Primeiro acesso
	$Desktop.visible = false
	$Boot/EscolhaSerie.visible = false

	nome_input.visible = false
	logo.visible = true
	terminal.visible = false

	clique.visible = true
	clique.text = ">> Pressione qualquer botão para iniciar"

# ==================================================
# ENTRADAS DO USUÁRIO
# ==================================================

func _input(event):

	# Clique do mouse
	if event is InputEventMouseButton and event.pressed:

		# Inicia o boot
		if !terminal.visible:
			clique.visible = false
			logo.visible = false
			terminal.visible = true

			await boot()

		# Boot finalizado
		elif boot_finalizado:
			$Boot.visible = false
			$Desktop.visible = true

	# Enter para entrar no Desktop
	elif event.is_action_pressed("ui_accept") and boot_finalizado:
		$Boot.visible = false
		$Desktop.visible = true


# ==================================================
# BOTÃO VOLTAR
# ==================================================

func _voltar():

	botao_voltar.disabled = true

	anim.play("sair_pc")
	await anim.animation_finished

	get_tree().change_scene_to_file("res://Cenas/telainicial.tscn")


# ==================================================
# FUNÇÕES DE ESCRITA NO TERMINAL
# ==================================================

func escrever_linha(texto:String, tempo:float = 0.5):

	terminal.append_text(texto + "\n")

	# Atualiza o RichTextLabel antes de mover a barra
	await get_tree().process_frame

	terminal.scroll_to_line(terminal.get_line_count() - 1)

	await get_tree().create_timer(tempo).timeout


func ok(tempo:float = 0.3):
	await escrever_linha("[color=#00FF66]OK[/color]", tempo)


func erro(tempo:float = 1.5):
	await escrever_linha("[color=#FF3B30]ERRO[/color]", tempo)


func falha(tempo:float = 1.5):
	await escrever_linha("[color=#FFA500]FALHA[/color]", tempo)


func aviso(texto:String, tempo:float = 1.0):
	await escrever_linha("[color=#FFD700]" + texto + "[/color]", tempo)


func info(texto:String, tempo:float = 1.0):
	await escrever_linha("[color=#00FF66]" + texto + "[/color]", tempo)


func sistema(texto:String, tempo:float = 1.0):
	await escrever_linha("[color=#00FF66]" + texto + "[/color]", tempo)


func comando(texto:String, tempo:float = 0.9):
	await escrever_linha("[color=#D0D0D0]" + texto + "[/color]", tempo)


# ==================================================
# REGISTRO DO OPERADOR
# ==================================================

func _on_nome_operador_text_submitted(texto:String):

	texto = texto.strip_edges()

	# Não permite nome vazio
	if texto.is_empty():

		nome_input.visible = false

		await erro()
		await comando("> Nome do operador inválido.")
		await aviso("> Digite um nome para continuar.")

		await escrever_linha("")
		await escrever_linha("")

		nome_input.clear()
		nome_input.visible = true
		nome_input.grab_focus()

		return

	# Salva o nome do operador
	DadosOperador.nome = texto

	nome_input.visible = false

	await comando("> Registrando operador...")
	await ok(0.5)

	await comando("> Operador registrado com sucesso.")
	await info("> Bem-vindo, " + DadosOperador.nome + ".")

	await comando(">Selecione sua série.")

	await escrever_linha("")
	await escrever_linha("")

	clique.visible = false

	$Boot/EscolhaSerie.visible = true


# ==================================================
# BOOT DO COMPUTADOR
# ==================================================

func boot():

	terminal.clear()

	await sistema("ECOS v2.4", 0.6)

	await escrever_linha("")

	await comando("> Inicializando sistema...")
	await ok(0.4)

	await comando("> Carregando módulo Física...")
	await ok()

	await comando("> Carregando módulo Química...")
	await ok()

	await comando("> Carregando módulo Biologia...")
	await ok()

	await comando("> Verificando arquivos...")
	await ok()

	await comando("> Arquivo corrompido encontrado...", 1.0)
	await erro()

	await comando("> Tentando restaurar...", 1.0)
	await falha()

	await comando("> Aguardando operador...")

	await escrever_linha("")
	await escrever_linha("")

	nome_input.visible = true
	nome_input.clear()
	nome_input.grab_focus()

	clique.text = ">> Aguardando entrada do usuário... <<"
	clique.visible = true


# ==================================================
# ESCOLHA DA SÉRIE
# ==================================================

func _on_1ano_pressed():

	DadosOperador.perfil = "1º Ano"
	DadosOperador.conteudo = "1º Ano"

	_finalizar_cadastro()
	atualizar_desktop()


func _on_2ano_pressed():

	DadosOperador.perfil = "2º Ano"
	DadosOperador.conteudo = "2º Ano"

	_finalizar_cadastro()
	atualizar_desktop()


func _on_3ano_pressed():

	DadosOperador.perfil = "3º Ano"
	DadosOperador.conteudo = "3º Ano"

	_finalizar_cadastro()
	atualizar_desktop()

# ==================================================
# FINALIZA O CADASTRO
# ==================================================

func _finalizar_cadastro():

	$Boot/EscolhaSerie.visible = false

	await comando("> Registrando série...")
	await ok()

	await comando("> Série selecionada: " + DadosOperador.perfil)

	await comando("> Operador autenticado.")
	await ok()

	clique.text = ">> Clique para continuar <<"
	clique.visible = true

	boot_finalizado = true
	DadosOperador.cadastro_concluido = true
	
# ==================================================
# ATULIZAR DESKTOP 
# ==================================================

func atualizar_desktop():

	$Desktop/Menu/Operador.text = "Operador: " + DadosOperador.nome
	$Desktop/Menu/Perfil.text = "Perfil: " + DadosOperador.perfil

	$Desktop/Menu/Estrelas.text = "★ Estrelas: " + str(DadosOperador.estrelas)
	$Desktop/Menu/Moedas.text = "💰 Moedas: " + str(DadosOperador.moedas)

	$Desktop/Menu/Conteudo.clear()

	$Desktop/Menu/Conteudo.add_item("1º Ano")
	$Desktop/Menu/Conteudo.add_item("2º Ano")
	$Desktop/Menu/Conteudo.add_item("3º Ano")


	$Desktop/Menu/ProgressoSerie.max_value = 100
	$Desktop/Menu/ProgressoSerie.value = DadosOperador.progresso_serie

	$Desktop/PainelMateria.visible = false
	
	match DadosOperador.conteudo:
		"1º Ano":
			$Desktop/Menu/Conteudo.select(0)
		"2º Ano":
			$Desktop/Menu/Conteudo.select(1)
		"3º Ano":
			$Desktop/Menu/Conteudo.select(2)
			
# ==================================================
# ABRIR PAINEL DA MATÉRIA
# ==================================================

@warning_ignore("unused_parameter")
func abrir_painel(nome:String, materia:Dictionary):

	$Desktop/Menu.visible = false
	painel_materia.visible = true

	nome_materia.text = nome

	var dados = materia[DadosOperador.conteudo]
	
	barra_materia.max_value = 100
	barra_materia.value = dados["progresso"]
	texto_materia.text = "Progresso da Matéria"
	
	assuntos.clear()

	assuntos.append_text("[b]Assuntos concluídos[/b]\n\n")

	for assunto in dados["concluidos"]:
		assuntos.append_text("🟢 " + assunto + "\n")

	assuntos.append_text("\n[b]Próximo[/b]\n\n")
	assuntos.append_text("🟡 " + dados["proximo"] + "\n")

	assuntos.append_text("\n[b]Pendentes[/b]\n\n")

	for assunto in dados["pendentes"]:
		assuntos.append_text("⚫ " + assunto + "\n")

# ==================================================
# BOTÃO DE CONTEÚDO/SÉRIE
# ==================================================

func _on_conteudo_item_selected(index:int):

	match index:
		0:
			DadosOperador.conteudo = "1º Ano"
		1:
			DadosOperador.conteudo = "2º Ano"
		2:
			DadosOperador.conteudo = "3º Ano"
	
# ==================================================
# BOTÕES DAS MATÉRIAS
# ==================================================

func _on_fisica_pressed():
	abrir_painel("FÍSICA", BancoMaterias.fisica)
	print(BancoMaterias.fisica)

func _on_quimica_pressed():
	abrir_painel("QUÍMICA", BancoMaterias.quimica)

func _on_biologia_pressed():
	abrir_painel("BIOLOGIA", BancoMaterias.biologia)


	
# ==================================================
# BOTÕES DE VOLTAR DO SISTEMA DE MENU/PAINELMATERIA
# ==================================================

func _on_botao_voltar_pressed() -> void:

	painel_materia.visible = false
	$Desktop/Menu.visible = true
	
