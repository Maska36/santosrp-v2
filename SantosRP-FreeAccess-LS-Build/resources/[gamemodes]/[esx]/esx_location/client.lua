
ESX = nil
local PlayerData = {}
local menuOpen = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSO', function(obj) ESX = obj end)
		Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

Citizen.CreateThread(function()

	for _,k in pairs(locations) do
		createBlip(k.coordsIn.x, k.coordsIn.y, k.coordsIn.z, 171, 1, "Location de Véhicule", 77)
	end


	while true do 
		Citizen.Wait(1)

		for _,k in pairs(locations) do
			local pedCoords = GetEntityCoords(PlayerPedId())

			if(GetDistanceBetweenCoords(pedCoords, k.coordsIn.x, k.coordsIn.y, k.coordsIn.z, true) < 100)then
				DrawMarker(25,k.coordsIn.x,k.coordsIn.y, k.coordsIn.z-1.7,0,0,0,0,0,0,3.501,3.5001,0.5001,58,132,201,255,0,0,0,0)
			end
			if(GetDistanceBetweenCoords(pedCoords, k.coordsIn.x, k.coordsIn.y, k.coordsIn.z, true) < 1.5)then
				showInfo("Appuyez sur ~INPUT_CONTEXT~ pour louer un véhicule")
				if(IsControlJustPressed(1, 38)) then
					showMenu(k)
					menuOpen = true
				end
			end
		end
	end
end)

function showMenu(k)
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'vehicle_menu',
		{
			css = 'location',
			title = 'Location de Véhicule',
			elements = {
				{label = 'Panto <span style="color:green;">$150', value = 'panto', price = "150"}
			}
		},function(data, menu)
			ESX.Game.SpawnVehicle(data.current.value, k.coordsOut[1], k.coordsOut[2], function(vehicle)
				TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
				pllate = math.random(70, 999)
                SetVehicleNumberPlateText(vehicle, 'LOC-'..pllate) -- Modification de la plaque d'immatriculation en LOCATION
			end)
			TriggerServerEvent('esx_location:buy', tonumber(data.current.price))
			menu.close()
		end,
		function(data, menu)
			menu.close()
		end
	)
end

function showInfo(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, false, 1, 0)
end

function createBlip(x,y,z,id, onlyShortRange, name,color)
	local blip = AddBlipForCoord(x,y,z)
	SetBlipSprite(blip, id)
	SetBlipScale(blip, 0.8)
    SetBlipColour(blip, color)
	SetBlipAsShortRange(blip, onlyShortRange)
	BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
    return blip
end
