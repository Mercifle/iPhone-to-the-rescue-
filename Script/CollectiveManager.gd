extends Node

var CollectiveCoins = 0

func AddingCoinage(Amount: int):
	CollectiveCoins += Amount

func TellingCoins():
	return CollectiveCoins

var DiamondDisaster = 50

func AddingDimage(Amount: int):
	DiamondDisaster += Amount

func TellingDiamonds():
	return DiamondDisaster

var KeyKills = false

func KnockKnock():
	return KeyKills
func FoundTheKey():
	KeyKills = true
