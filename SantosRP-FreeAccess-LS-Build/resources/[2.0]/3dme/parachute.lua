ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSO', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local para = {
	["parachute2"] = {
		position = vector3(1-80.7721328735352, -825.642822265625, 326.083953857422),
		nompara = "BASE Jump",
	},
	["parachute5"] = {
		position = vector3(1665.401, -27.96845, 196.9363),
		nompara = "BASE Jump",
	},

	["parachute7"] = {
		position = vector3(-119.712, -976.443, 296.197),
		nompara = "BASE Jump",
	},
	

	["McKenzie - Parachute"] = {
		position = vector3(2141.078369, 4788.543945, 40.7702),
		nompara = "McKenzieParachute",
	},
}

Citizen.CreateThread(function()
	for k,v in pairs(para) do
		local vpara = v.position

		local blip = AddBlipForCoord(vpara)
		SetBlipSprite(blip, 94)
		SetBlipColour(blip, 15)
		SetBlipScale(blip, 0.8)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Saut en parachute")
		EndTextCommandSetBlipName(blip)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local pos = GetEntityCoords(PlayerPedId())

		for k,v in pairs(para)do
			local distance = #(pos - v.position)

			if(distance < 15.0)then
				DrawMarker(1, v.position, - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555, 0, 0,255, 0, 0, 0,0)

				if(distance < 1.0)then
                    ESX.ShowHelpNotification("Appuyez sur ~b~[E]~w~ pour obtenir un ~g~parachute")
                    if IsControlJustPressed(1, 38) then
						GiveWeaponToPed(PlayerPedId(), GetHashKey("GADGET_PARACHUTE"), 150, true, true)
                    end
				end
			end
		end
	end
end)