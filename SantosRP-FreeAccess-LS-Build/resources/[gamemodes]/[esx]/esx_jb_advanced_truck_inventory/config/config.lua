--Truck
Config	=	{}

 -- Limit, unit can be whatever you want. Originally grams (as average people can hold 25kg)
Config.Limit = 5

-- Default weight for an item:
	-- weight == 0 : The item do not affect character inventory weight
	-- weight > 0 : The item cost place on inventory
	-- weight < 0 : The item add place on inventory. Smart people will love it.
Config.DefaultWeight = 1



-- If true, ignore rest of file
Config.WeightSqlBased = false

-- I Prefer to edit weight on the config.lua and I have switched Config.WeightSqlBased to false:

Config.localWeight = {
    bread = 1,
    water = 1,
	WEAPON_COMBATPISTOL = 100, -- poid pour une munnition
	black_money = 1, -- poids pour un argent
}

Config.VehicleLimit = {
    [0]=120, -- Compacts
    [1]=140, -- Sedans
    [2]=300, -- SUVs
    [3]=170, -- Coupes
    [4]=120, -- Muscle
    [5]=175, -- Sports Classics
    [6]=200, -- Sports
    [7]=150, -- Super
    [8]=100, -- Motorcycles
    [9]=260, -- Off-road
    [10]=900, -- Industrial
    [11]=800, -- Utility
    [12]=1000, -- Vans
    [13]=15, -- Cycles
    [14]=800, -- Boats
    [15]=5000, -- Helicopters
    [16]=10000, -- Planes
    [17]=1000, -- Service
    [18]=1500, -- Emergency
    [19]=4000, -- Military
    [20]=3000, -- Commercial
    [21]=0, --Trains
}