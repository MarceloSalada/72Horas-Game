extends Node

var agua: int = 100
var comida: int = 100
var energia: int = 100
var tempo_horas: int = 72
var progresso_rota: int = 0

func aplicar_avanco_rota() -> void:
    agua = max(agua - 8, 0)
    comida = max(comida - 6, 0)
    energia = max(energia - 10, 0)
    tempo_horas = max(tempo_horas - 4, 0)
    progresso_rota = min(progresso_rota + 20, 100)

func venceu() -> bool:
    return progresso_rota >= 100

func perdeu() -> bool:
    return agua <= 0 or comida <= 0 or energia <= 0 or tempo_horas <= 0
