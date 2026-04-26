extends Control

var GameState = preload("res://scripts/game_state.gd").new()

@onready var mapa_fundo: TextureRect = $MapaFundo
@onready var ponto_seguro: TextureRect = $PontoSeguro
@onready var avatar: TextureRect = $HUD/Avatar
@onready var painel_recursos: Control = $HUD/PainelRecursos
@onready var painel_arte: TextureRect = $HUD/PainelRecursos/PainelArte
@onready var botao_fundo: TextureRect = $HUD/BotaoFundo
@onready var botao_rota: Button = $HUD/BotaoPlanejarRota
@onready var status_label: Label = $HUD/StatusLabel

@onready var agua_linha: HBoxContainer = $HUD/PainelRecursos/AguaLinha
@onready var comida_linha: HBoxContainer = $HUD/PainelRecursos/ComidaLinha
@onready var energia_linha: HBoxContainer = $HUD/PainelRecursos/EnergiaLinha
@onready var tempo_linha: HBoxContainer = $HUD/PainelRecursos/TempoLinha

@onready var icone_agua: TextureRect = $HUD/PainelRecursos/AguaLinha/IconeAgua
@onready var icone_comida: TextureRect = $HUD/PainelRecursos/ComidaLinha/IconeComida
@onready var icone_energia: TextureRect = $HUD/PainelRecursos/EnergiaLinha/IconeEnergia
@onready var icone_tempo: TextureRect = $HUD/PainelRecursos/TempoLinha/IconeTempo

@onready var agua_label: Label = $HUD/PainelRecursos/AguaLinha/ValorAgua
@onready var comida_label: Label = $HUD/PainelRecursos/ComidaLinha/ValorComida
@onready var energia_label: Label = $HUD/PainelRecursos/EnergiaLinha/ValorEnergia
@onready var tempo_label: Label = $HUD/PainelRecursos/TempoLinha/ValorTempo

func _ready() -> void:
	botao_rota.pressed.connect(_on_botao_planejar_rota_pressed)
	get_viewport().size_changed.connect(aplicar_layout)
	atualizar_hud()
	call_deferred("aplicar_layout")

func aplicar_layout() -> void:
	var tela := get_viewport_rect().size
	mapa_fundo.position = Vector2.ZERO
	mapa_fundo.size = tela

	var paisagem := tela.x > tela.y
	if paisagem:
		_aplicar_layout_paisagem(tela)
	else:
		_aplicar_layout_retrato(tela)

func _aplicar_layout_paisagem(tela: Vector2) -> void:
	avatar.position = Vector2(24, 24)
	avatar.size = Vector2(72, 72)

	painel_recursos.position = Vector2(24, 110)
	painel_recursos.size = Vector2(210, 300)
	painel_arte.position = Vector2.ZERO
	painel_arte.size = painel_recursos.size

	_configurar_linha(agua_linha, icone_agua, agua_label, 22, 56, 24)
	_configurar_linha(comida_linha, icone_comida, comida_label, 88, 56, 24)
	_configurar_linha(energia_linha, icone_energia, energia_label, 154, 56, 24)
	_configurar_linha(tempo_linha, icone_tempo, tempo_label, 220, 56, 24)

	ponto_seguro.position = Vector2(tela.x * 0.50, tela.y * 0.18)
	ponto_seguro.size = Vector2(76, 76)

	var botao_tamanho := Vector2(300, 76)
	var botao_pos := Vector2((tela.x - botao_tamanho.x) / 2.0, tela.y - botao_tamanho.y - 26.0)
	_configurar_botao(botao_pos, botao_tamanho, 24)

	status_label.position = Vector2(250, tela.y - 122)
	status_label.size = Vector2(max(tela.x - 500, 250), 58)
	status_label.add_theme_font_size_override("font_size", 20)

func _aplicar_layout_retrato(tela: Vector2) -> void:
	avatar.position = Vector2(34, 36)
	avatar.size = Vector2(132, 132)

	painel_recursos.position = Vector2(34, 220)
	painel_recursos.size = Vector2(420, 620)
	painel_arte.position = Vector2.ZERO
	painel_arte.size = painel_recursos.size

	_configurar_linha(agua_linha, icone_agua, agua_label, 60, 86, 34)
	_configurar_linha(comida_linha, icone_comida, comida_label, 190, 86, 34)
	_configurar_linha(energia_linha, icone_energia, energia_label, 320, 86, 34)
	_configurar_linha(tempo_linha, icone_tempo, tempo_label, 450, 86, 34)

	ponto_seguro.position = Vector2(tela.x * 0.70, tela.y * 0.17)
	ponto_seguro.size = Vector2(140, 140)

	var botao_tamanho := Vector2(min(tela.x - 140.0, 700.0), 150.0)
	var botao_pos := Vector2((tela.x - botao_tamanho.x) / 2.0, tela.y - botao_tamanho.y - 70.0)
	_configurar_botao(botao_pos, botao_tamanho, 32)

	status_label.position = Vector2(70, tela.y - 310)
	status_label.size = Vector2(tela.x - 140, 110)
	status_label.add_theme_font_size_override("font_size", 28)

func _configurar_linha(linha: HBoxContainer, icone: TextureRect, label: Label, y: float, altura: float, fonte: int) -> void:
	linha.position = Vector2(34, y)
	linha.size = Vector2(max(painel_recursos.size.x - 68, 120), altura)
	icone.custom_minimum_size = Vector2(altura, altura)
	label.custom_minimum_size = Vector2(max(painel_recursos.size.x - altura - 100, 80), altura)
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", fonte)

func _configurar_botao(posicao: Vector2, tamanho: Vector2, fonte: int) -> void:
	botao_fundo.position = posicao
	botao_fundo.size = tamanho
	botao_rota.position = posicao
	botao_rota.size = tamanho
	botao_rota.add_theme_font_size_override("font_size", fonte)
	botao_rota.text = "PLANEJAR ROTA"

func _on_botao_planejar_rota_pressed() -> void:
	GameState.aplicar_avanco_rota()
	atualizar_hud()

	if GameState.venceu():
		status_label.text = "Você chegou ao ponto seguro. Missão cumprida."
		botao_rota.disabled = true
	elif GameState.perdeu():
		status_label.text = "Recursos críticos. Missão falhou."
		botao_rota.disabled = true
	else:
		status_label.text = "Rota avançada: %d%%" % GameState.progresso_rota

func atualizar_hud() -> void:
	agua_label.text = str(GameState.agua) + "%"
	comida_label.text = str(GameState.comida) + "%"
	energia_label.text = str(GameState.energia) + "%"
	tempo_label.text = str(GameState.tempo_horas) + "h"
