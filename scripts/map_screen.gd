extends Control

var GameState = preload("res://scripts/game_state.gd").new()

@onready var agua_label: Label = $HUD/PainelRecursos/AguaLinha/ValorAgua
@onready var comida_label: Label = $HUD/PainelRecursos/ComidaLinha/ValorComida
@onready var energia_label: Label = $HUD/PainelRecursos/EnergiaLinha/ValorEnergia
@onready var tempo_label: Label = $HUD/PainelRecursos/TempoLinha/ValorTempo
@onready var status_label: Label = $HUD/StatusLabel
@onready var botao_rota: Button = $HUD/BotaoPlanejarRota

func _ready() -> void:
    botao_rota.pressed.connect(_on_botao_planejar_rota_pressed)
    atualizar_hud()

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
