-- Local
local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local carInstance = {}



-- Fin Local

-- Init ESX
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSO', function(obj)
		ESX = obj
		end)
	end
end)

--Fonction Menu

function OpenMenuGarage(garage, KindOfVehicle, garage_name, vehicle_type)
	ESX.UI.Menu.CloseAll()

	local elements = {
		{label = "Reprendre mon vehicule ("..Config.Price.."$)", value = 'return_vehicle'},
	}


	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'garage_menu',
		{
			css = 'santos',
			title    = 'Garage',
			align    = 'top-left',
			elements = elements,
		},
		function(data, menu)

			menu.close()
			if(data.current.value == 'return_vehicle') then
				ReturnVehicleMenu(garage, KindOfVehicle, garage_name, vehicle_type)
			end
		end,
		function(data, menu)
			menu.close()
		end
	)
end
-- Afficher les listes des vehicules
function ListVehiclesMenu(garage, KindOfVehicle, garage_name, vehicle_type)
	local elements, vehiclePropsList = {}, {}
	ESX.TriggerServerCallback('eden_garage:getVehicles', function(vehicles)
		if not table.empty(vehicles) then
			for _,v in pairs(vehicles) do
				local vehicleProps = json.decode(v.vehicle)
				vehiclePropsList[vehicleProps.plate] = vehicleProps
				local vehicleHash = vehicleProps.model
				local vehicleName, vehicleLabel
								
				if v.vehiclename == 'voiture' then
					vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(vehicleHash))
				else
					vehicleName = v.vehiclename
				end

				if v.fourrieremecano then
					vehicleLabel = vehicleName..' - Fourrière externe'
				elseif v.stored then
					vehicleLabel = vehicleName..' - Rangé'
				else
					vehicleLabel = vehicleName..' - Sortie'
				end
				table.insert(elements, {
					label = vehicleLabel,
					vehicleName = vehicleName,
					stored = v.stored,
					plate = vehicleProps.plate,
					fourrieremecano = v.fourrieremecano,
					garage_name = v.garage_name
				})
				
			end
		else
			table.insert(elements, {label = "Pas de voitures dans le garage"})
		end
		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'spawn_vehicle',
		{
			css = 'santos',
			title    = 'Garage',
			align    = 'top-left',
			elements = elements,
		},
		function(data, menu)
			local CarProps = vehiclePropsList[data.current.plate]
			if data.current.label ~= "Pas de voitures dans le garage" then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_menu', {
					css = 'santos',
					title    =  data.current.vehicleName,
					align    = 'top-left',
					elements = {
						{label ="Sortir la voiture" , value = 'get_vehicle_out'},
						{label ="Renommer la voiture" , value = 'rename_vehicle'}
				}}, function(data2, menu2)
						if data2.current.value == "get_vehicle_out" then
							local doesVehicleExist = false
							for k,v in pairs (carInstance) do
								if ESX.Math.Trim(v.plate) == ESX.Math.Trim(data.current.plate) then
									if DoesEntityExist(v.vehicleentity) then
										doesVehicleExist = true
									else
										table.remove(carInstance, k)
										doesVehicleExist = false
									end
								end
							end
	                        if (doesVehicleExist) then
								ESX.ShowNotification('~r~Vous ne pouvez pas sortir ce véhicule, il est déja sortit. Allez, vas le chercher!')
	                        elseif (data.current.fourrieremecano) then
	                            ESX.ShowNotification('Votre véhicule est dans la fourrière du mecano')
	                        elseif garage_name ~= data.current.garage_name then
								local elem = {}
								table.insert(elem, {label ="oui $"..tostring(Config.SwitchGaragePrice) , value = 'transfer_yes'})
								table.insert(elem, {label ="non" , value = 'transfer_no'})
								ESX.UI.Menu.Open(
									'default', GetCurrentResourceName(), 'transfer_menu',
									{
										css = 'santos',
										title    =  "Voulez vous transférer: "..data.current.vehicleName.." a votre garage?",
										align    = 'top-left',
										elements = elem,
									},
									function(data3, menu3)
										if data3.current.value == "transfer_yes" then 
											ESX.TriggerServerCallback('eden_garage:checkMoney', function(hasEnoughMoney)
												if hasEnoughMoney then
													TriggerServerEvent("esx_eden_garage:MoveGarage",data.current.plate, garage_name)
													SpawnVehicle(CarProps, garage, KindOfVehicle)
													ESX.UI.Menu.CloseAll()
												else
													ESX.ShowNotification("~r~Vous n'avez pas assez d'argent")
												end
											end, Config.SwitchGaragePrice)
										else
											menu2.close()
											menu3.close()
										end
									end,
									function(data3, menu3)
										menu3.close()
									end
								)
							elseif (data.current.stored) then
	                            SpawnVehicle(CarProps, garage, KindOfVehicle)
								ESX.UI.Menu.CloseAll()
	                        else
	                            ESX.ShowNotification('~g~Votre véhicule est déjà sortit.')
	                        end
						elseif data2.current.value == "rename_vehicle" then
							ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rename_vehicle', {
								title = 'Nom du véhicule souhaité'
							}, function(data3, menu3)
								if string.len(data3.value) >= 1 then
									TriggerServerEvent('eden_garage:renamevehicle', data.current.plate, data3.value)
									ESX.UI.Menu.CloseAll()
									ListVehiclesMenu(garage, KindOfVehicle, garage_name, vehicle_type)
								else
									ESX.ShowNotification("~r~Le nom du véhicule ne peut pas être vide")
									menu3.close()
								end

							end, function(data3, menu3)
								menu3.close()
							end)
						end
					end,
					function(data2, menu2)
						menu2.close()
					end
				)
			end
		end,
		function(data, menu)
			menu.close()
		end
	)
	end, KindOfVehicle, garage_name, vehicle_type)
end
-- Fin Afficher les listes des vehicules

-- Afficher les listes des vehicules de fourriere
function ListVehiclesFourriereMenu(garage)
	local elements, vehiclePropsList = {}, {}

	ESX.TriggerServerCallback('eden_garage:getVehiclesMecano', function(vehicles)

		for k,v in ipairs(vehicles) do
			local vehicleProps = json.decode(v.vehicle)
			vehiclePropsList[vehicleProps.plate] = vehicleProps
			local vehicleHash = vehicleProps.model
			local vehicleName = GetDisplayNameFromVehicleModel(vehicleHash)

			table.insert(elements, {
				label = ('%s | %s %s'):format(vehicleName, v.firstname, v.lastname),
				plate = vehicleProps.plate
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_vehicle_mecano', {
			css = 'santos',
			title    = 'Garage',
			align    = 'top-left',
			elements = elements,
		}, function(data, menu)
			local vehicleProps = vehiclePropsList[data.current.plate]
			menu.close()
			SpawnVehicleMecano(vehicleProps, garage)
			TriggerServerEvent('eden_garage:ChangeStateFromFourriereMecano', vehicleProps, false)
		end, function(data, menu)
			menu.close()
		end)

	end)
end
-- Fin Afficher les listes des vehicules de fourriere


-- Fonction qui permet de rentrer un vehicule
function StockVehicleMenu(KindOfVehicle, garage_name, vehicle_type)
	local playerPed  = PlayerPedId()
	if IsPedInAnyVehicle(playerPed,  false) then
		local vehicle =GetVehiclePedIsIn(playerPed,false)
		if GetPedInVehicleSeat(vehicle, -1) == playerPed then
			local GotTrailer, TrailerHandle = GetVehicleTrailerVehicle(vehicle)
			if GotTrailer then
				local trailerProps  = ESX.Game.GetVehicleProperties(TrailerHandle)
				ESX.TriggerServerCallback('eden_garage:stockv',function(valid)
					if(valid) then
						for k,v in pairs (carInstance) do
							if ESX.Math.Trim(v.plate) == ESX.Math.Trim(trailerProps.plate) then
								table.remove(carInstance, k)
							end
						end
						DeleteEntity(TrailerHandle)
						TriggerServerEvent('eden_garage:modifystate', trailerProps.plate, true)
						TriggerServerEvent("esx_eden_garage:MoveGarage", trailerProps.plate, garage_name)
						ESX.ShowNotification('~g~Votre remorque est rentrée dans le garage')
					else
						ESX.ShowNotification('~r~Vous ne pouvez pas stocker ce véhicule')
					end
				end,trailerProps, KindOfVehicle, garage_name, vehicle_type)
			else
				local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
				ESX.TriggerServerCallback('eden_garage:stockv',function(valid)
					if(valid) then
						for k,v in pairs (carInstance) do
							if ESX.Math.Trim(v.plate) == ESX.Math.Trim(vehicleProps.plate) then
								table.remove(carInstance, k)
							end
						end
						SetEntityAsMissionEntity(vehicle, true, true)
						Citizen.Wait(100)
						DeleteVehicle(vehicle)
						TriggerServerEvent('eden_garage:modifystate', vehicleProps.plate, true)
						TriggerServerEvent("esx_eden_garage:MoveGarage", vehicleProps.plate, garage_name)
						ESX.ShowNotification('~g~Votre véhicule est rentré dans le garage')
					else
						ESX.ShowNotification('~r~Vous ne pouvez pas stocker ce véhicule')
					end
				end,vehicleProps, KindOfVehicle, garage_name, vehicle_type)
			end
		end
	end
end
-- Fin fonction qui permet de rentrer un vehicule 

-- Fonction qui permet de rentrer un vehicule dans fourriere
function StockVehicleFourriereMenu()
	local playerPed  = PlayerPedId()
	if IsPedInAnyVehicle(playerPed,  false) then
		local vehicle =GetVehiclePedIsIn(playerPed,false)
		if GetPedInVehicleSeat(vehicle, -1) == playerPed then
			local GotTrailer, TrailerHandle = GetVehicleTrailerVehicle(vehicle)
			if GotTrailer then
				local trailerProps  = ESX.Game.GetVehicleProperties(TrailerHandle)
				ESX.TriggerServerCallback('eden_garage:stockvmecano',function(valid)
					if(valid) then
						DeleteVehicle(TrailerHandle)
						TriggerServerEvent('eden_garage:ChangeStateFromFourriereMecano', trailerProps, true)
						ESX.ShowNotification('~g~La remorque est rentrée dans la fourrière')
					else
						ESX.ShowNotification('~r~Vous ne pouvez pas stocker cette remorque dans la fourrière')
					end
				end,trailerProps)
			else
				local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
				ESX.TriggerServerCallback('eden_garage:stockvmecano',function(valid)
					if(valid) then
						DeleteVehicle(vehicle)
						TriggerServerEvent('eden_garage:ChangeStateFromFourriereMecano', vehicleProps, true)
						ESX.ShowNotification('~g~Le véhicule est rentré dans la fourrière')
					else
						ESX.ShowNotification('~r~Vous ne pouvez pas stocker ce véhicule dans la fourrière')
					end
				end,vehicleProps)
			end
		end
	end
end
-- Fin fonction qui permet de rentrer un vehicule dans fourriere
--Fin fonction Menu


--Fonction pour spawn vehicule
function SpawnVehicle(vehicle, garage, KindOfVehicle)
	ESX.Game.SpawnVehicle(vehicle.model, {
		x = garage.SpawnPoint.Pos.x,
		y = garage.SpawnPoint.Pos.y,
		z = garage.SpawnPoint.Pos.z + 1											
		},garage.SpawnPoint.Heading, function(callback_vehicle)
			ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
			TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
			local carplate = GetVehicleNumberPlateText(callback_vehicle)
			table.insert(carInstance, {vehicleentity = callback_vehicle, plate = carplate})
			if KindOfVehicle == 'brewer' or KindOfVehicle == 'biker' or KindOfVehicle == 'joaillerie' or KindOfVehicle == 'fermier' or KindOfVehicle == 'fisherman' or KindOfVehicle == 'fuel' or KindOfVehicle == 'johnson' or KindOfVehicle == 'miner' or KindOfVehicle == 'reporter' or KindOfVehicle == 'vignerons' or KindOfVehicle == 'tabac' then
				TriggerEvent('esx_jobs1:addplate', carplate)
				TriggerEvent('esx_jobs2:addplate', carplate)
			end	
		end)
	TriggerServerEvent('eden_garage:modifystate', vehicle.plate, false)
end
--Fin fonction pour spawn vehicule

--Fonction pour spawn vehicule fourriere mecano
function SpawnVehicleMecano(vehicle, garage)
	ESX.Game.SpawnVehicle(vehicle.model, {
		x = garage.SpawnPoint.Pos.x,
		y = garage.SpawnPoint.Pos.y,
		z = garage.SpawnPoint.Pos.z + 1											
		},garage.SpawnPoint.Heading, function(callback_vehicle)
			ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
			TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
		end)
	TriggerServerEvent('eden_garage:ChangeStateFromFourriereMecano', vehicle, false)
end
--Fin fonction pour spawn vehicule fourriere mecano

function ReturnVehicleMenu(garage, KindOfVehicle, garage_name, vehicle_type)

	ESX.TriggerServerCallback('eden_garage:getOutVehicles', function(vehicles)
		local elements, vehiclePropsList = {}, {}
		if not table.empty(vehicles) then
			for _,v in pairs(vehicles) do
				local vehicleProps = json.decode(v.vehicle)
				vehiclePropsList[vehicleProps.plate] = vehicleProps
				local vehicleHash = vehicleProps.model
				local vehicleName, vehicleLabel

				if v.vehiclename == 'voiture' then
					vehicleName = GetDisplayNameFromVehicleModel(vehicleHash)
				else
					vehicleName = v.vehiclename
				end

				if v.fourrieremecano then
					vehicleLabel = vehicleName..': Fourrière externe'
					table.insert(elements, {label = vehicleLabel, action = 'fourrieremecano'})
				else
					vehicleLabel = vehicleName..': Sortie'
					table.insert(elements, {
						label = vehicleLabel,
						plate = vehicleProps.plate,
						action = 'store'
					})
				end
			end
		else
			table.insert(elements, {label = "Pas de véhicule a sortir", action = 'nothing'})
		end

			ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'return_vehicle',
			{
				css = 'santos',
				title    = 'Garage',
				align    = 'top-left',
				elements = elements,
			},
			function(data, menu)
				local vehicleProps = vehiclePropsList[data.current.plate]
				if data.current.label ~= "Pas de véhicule a sortir" then 
					if data.current.action == 'fourrieremecano' then
						ESX.ShowNotification("~y~Va voir la police ou le mecano pour savoir comment récupérer ton véhicule.")
					elseif data.current.action ~= nil then
						local doesVehicleExist = false
						for k,v in pairs (carInstance) do
							if ESX.Math.Trim(v.plate) == ESX.Math.Trim(data.current.plate) then
								if DoesEntityExist(v.vehicleentity) then
									doesVehicleExist = true
								else
									table.remove(carInstance, k)
									doesVehicleExist = false
								end
							end
						end
						if not doesVehicleExist then
							ESX.TriggerServerCallback('eden_garage:checkMoney', function(hasEnoughMoney)
								if hasEnoughMoney then
									menu.close()
									SpawnVehicle(vehicleProps, garage, KindOfVehicle)
								else
									ESX.ShowNotification('~r~Vous n\'avez pas assez d\'argent')						
								end
							end, Config.Price)
						else
							ESX.ShowNotification("~r~Vous ne pouvez pas sortir ce véhicule car il est déja sortit. Allez, vas le chercher !")
						end				
					end
				end
			end,
			function(data, menu)
				menu.close()
			end)
	end, KindOfVehicle, garage_name, vehicle_type)
end

function exitmarker()
	ESX.UI.Menu.CloseAll()
end

RegisterNetEvent("ft_libs:OnClientReady")
AddEventHandler('ft_libs:OnClientReady', function()
	for k,v in pairs (Config.Garages) do
		exports.ft_libs:AddArea("esx_eden_garage_area_"..k.."_garage", {
			marker = {
				weight = 1.0,
				height = 1.8,
				red = v.Marker.r,
				green = v.Marker.g,
				blue = v.Marker.b,
				type = 36,
			},
			trigger = {
				weight = 1.4,
				active = {
					callback = function()
						exports.ft_libs:HelpPromt(v.HelpPrompt)
						if IsControlJustReleased(0, 38) and IsInputDisabled(0) and GetLastInputMethod(2) and not IsPedInAnyVehicle(PlayerPedId()) then
							OpenMenuGarage(v, "personal", k, "car")
						end
					end,
				},
				exit = {
					callback = exitmarker
				},
			},
			blip = {
				text = v.Name,
				colorId = Config.Blip.color,
				imageId = Config.Blip.sprite,
			},
			locations = {
				v.Pos				
			},
		})
		exports.ft_libs:AddArea("esx_eden_garage_area_"..k.."_spawnpoint", {
			marker = {
				weight = 1.0,
				height = 1.8,
				red = v.SpawnPoint.Marker.r,
				green = v.SpawnPoint.Marker.g,
				blue = v.SpawnPoint.Marker.b,
				type = 36,
			},
			trigger = {
				weight = 1.4,
				active = {
					callback = function()
						exports.ft_libs:HelpPromt(v.SpawnPoint.HelpPrompt)
						if IsControlJustReleased(0, 38) and IsInputDisabled(0) and GetLastInputMethod(2) and not IsPedInAnyVehicle(PlayerPedId()) then
							ListVehiclesMenu(v, "personal", k, "car")
						end
					end,
				},
				exit = {
					callback = exitmarker
				},
			},
			locations = {
				{
					x = v.SpawnPoint.Pos.x,
					y = v.SpawnPoint.Pos.y,
					z = v.SpawnPoint.Pos.z,
				},
			},
		})
		exports.ft_libs:AddArea("esx_eden_garage_area_"..k.."_deletepoint", {
			marker = {
				weight = 1.0,
				height = 1.8,
				red = v.DeletePoint.Marker.r,
				green = v.DeletePoint.Marker.g,
				blue = v.DeletePoint.Marker.b,
				type = 36,
			},
			trigger = {
				weight = 2.3,
				active = {
					callback = function()
						exports.ft_libs:HelpPromt(v.DeletePoint.HelpPrompt)
						if IsControlJustReleased(0, 38) and IsInputDisabled(0) and GetLastInputMethod(2) then
							StockVehicleMenu("personal", k, "car")
						end
					end,
				},
				exit = {
					callback = exitmarker
				},
			},
			locations = {
				{
					x = v.DeletePoint.Pos.x,
					y = v.DeletePoint.Pos.y,
					z = v.DeletePoint.Pos.z,
				},
			},
		})
	end
	
	for k,v in pairs (Config.GaragesMecano) do
		exports.ft_libs:AddArea("esx_eden_garage_area_"..k.."_mecanospawnpoint", {
			enable = false,
			marker = {
				weight = v.SpawnPoint.Marker.w,
				height = v.SpawnPoint.Marker.h,
				red = v.SpawnPoint.Marker.r,
				green = v.SpawnPoint.Marker.g,
				blue = v.SpawnPoint.Marker.b,
				type = 27,
			},
			trigger = {
				weight = v.SpawnPoint.Marker.w,
				active = {
					callback = function()
						exports.ft_libs:HelpPromt(v.SpawnPoint.HelpPrompt)
						if IsControlJustReleased(0, 38) and IsInputDisabled(0) and GetLastInputMethod(2) and not IsPedInAnyVehicle(PlayerPedId()) then
							ListVehiclesFourriereMenu(v)
						end
					end,
				},
				exit = {
					callback = exitmarker
				},
			},
			blip = {
				text = v.Name,
				colorId = Config.MecanoBlip.color,
				imageId = Config.MecanoBlip.sprite,
			},
			locations = {
				{
					x = v.SpawnPoint.Pos.x,
					y = v.SpawnPoint.Pos.y,
					z = v.SpawnPoint.Pos.z,
				},
			},
		})
		exports.ft_libs:AddArea("esx_eden_garage_area_"..k.."_mecanodeletepoint", {
			enable = false,
			marker = {
				weight = v.DeletePoint.Marker.w,
				height = v.DeletePoint.Marker.h,
				red = v.DeletePoint.Marker.r,
				green = v.DeletePoint.Marker.g,
				blue = v.DeletePoint.Marker.b,
				type = 27,
			},
			trigger = {
				weight = v.DeletePoint.Marker.w,
				active = {
					callback = function()
						exports.ft_libs:HelpPromt(v.DeletePoint.HelpPrompt)
						if IsControlJustReleased(0, 38) and IsInputDisabled(0) and GetLastInputMethod(2) then
							StockVehicleFourriereMenu()
						end
					end,
				},
				exit = {
					callback = exitmarker
				},
			},
			locations = {
				{
					x = v.DeletePoint.Pos.x,
					y = v.DeletePoint.Pos.y,
					z = v.DeletePoint.Pos.z,
				},
			},
		})
	end
end)

-- Fin controle touche
function dump(o, nb)
  if nb == nil then
    nb = 0
  end
   if type(o) == 'table' then
      local s = ''
      for i = 1, nb + 1, 1 do
        s = s .. "    "
      end
      s = '{\n'
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
          for i = 1, nb, 1 do
            s = s .. "    "
          end
         s = s .. '['..k..'] = ' .. dump(v, nb + 1) .. ',\n'
      end
      for i = 1, nb, 1 do
        s = s .. "    "
      end
      return s .. '}'
   else
      return tostring(o)
   end
end

function table.empty (self)
    for _, _ in pairs(self) do
        return false
    end
    return true
end

--- garage societe

RegisterNetEvent('esx_eden_garage:ListVehiclesMenu')
AddEventHandler('esx_eden_garage:ListVehiclesMenu', function(garage, society, societygarage)
	if not IsPedInAnyVehicle(PlayerPedId()) then
		ListVehiclesMenu(garage, society, societygarage, "car")
	end
end)

RegisterNetEvent('esx_eden_garage:OpenMenuGarage')
AddEventHandler('esx_eden_garage:OpenMenuGarage', function(garage, society, societygarage)
	if not IsPedInAnyVehicle(PlayerPedId()) then
		OpenMenuGarage(garage, society, societygarage, "car")
	end
end)

RegisterNetEvent('esx_eden_garage:StockVehicleMenu')
AddEventHandler('esx_eden_garage:StockVehicleMenu', function(society, societygarage)
	StockVehicleMenu(society, societygarage, "car")
end)
