Config              = {}
Config.MarkerType   = 20
Config.DrawDistance = 50.0
Config.ZoneSize     = {x = 1.5, y = 1.5, z = 1.0}

Config.MarkerColor  = {r = 255, g = 135, b = 0}

Config.ShowBlips   = true 

Config.RequiredCopsKoda  = 0

Config.TimeToFarm    = 3 * 1000
Config.TimeToProcess = 2 * 1000
Config.TimeToSell    = 1  * 1000

Config.Locale = 'en'

Config.Zones = {
	CatchOrange = {
		Pos = vector3(328.64, 6530.87, 28.69),
		name = _U('orange_picking'),
		sprite = 238,
		color = 47
	},

	OrangeJuice = {
		Pos = vector3(406.1, 6450.72, 28.81),
		name = _U('turns_from_juice'),
		sprite = 499,
		color = 47
	},

	SellOrangeJuice = {
		Pos = vector3(104.73, -932.8, 29.82),
		name = _U('sell_juice_orage_blip'),	
		sprite = 500,
		color = 47
	}
}
