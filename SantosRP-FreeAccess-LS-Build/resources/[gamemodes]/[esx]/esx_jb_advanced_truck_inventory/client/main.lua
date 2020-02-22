ESX = nil
local PlayerData = {}
local lastVehicle = 0
local lastOpen = false
local vehiclePlate = {}
local arrayWeight = Config.localWeight
local CloseToVehicle = false
local GUI = {}
GUI.Time = 0

function getItemyWeight(item)
  local weight = 0
  local itemWeight = 0

  if item ~= nil then
	   itemWeight = Config.DefaultWeight
	   if arrayWeight[item] ~= nil then
	        itemWeight = arrayWeight[item]
	   end
	end
  return itemWeight
end


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSO', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	TriggerServerEvent("esx_truck_inventory:getOwnedVehicule")
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx_truck_inventory:setOwnedVehicule')
AddEventHandler('esx_truck_inventory:setOwnedVehicule', function(vehicle)
    vehiclePlate = vehicle
end)

function VehicleInFront()
    local pos = GetEntityCoords(PlayerPedId())
    local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 4.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
    local a, b, c, d, result = GetRaycastResult(rayHandle)
    return result
end

function VehicleMaxSpeed(vehicle,weight,maxweight)
  local percent = (weight/maxweight)*100
  local hashk= GetEntityModel(vehicle)
  if percent > 80  then
    SetEntityMaxSpeed(vehFront,GetVehicleModelMaxSpeed(hashk)/1.4)
  elseif percent > 50 then
    SetEntityMaxSpeed(vehFront,GetVehicleModelMaxSpeed(hashk)/1.2)
  else
    SetEntityMaxSpeed(vehFront,GetVehicleModelMaxSpeed(hashk))
  end
end

function openMenuVehicle()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local vehicle = VehicleInFront()
	globalplate  = GetVehicleNumberPlateText(vehicle)
	if globalplate ~= nil or globalplate ~= "" or globalplate ~= " " then
		ESX.TriggerServerCallback('esx_truck:checkvehicle',function(valid)
			local vehFront = VehicleInFront()
			local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(),true))
			local closecar = GetClosestVehicle(x, y, z, 4.0, 0, 71)
			if vehFront > 0 and closecar ~= nil and GetPedInVehicleSeat(closecar, -1) ~= PlayerPedId() then
				lastVehicle = vehFront
				local model = GetDisplayNameFromVehicleModel(GetEntityModel(closecar))
				local locked = GetVehicleDoorLockStatus(closecar)
				local class = GetVehicleClass(vehFront)
				ESX.UI.Menu.CloseAll()
				if locked == 1 or class == 15 or class == 16 or class == 14 then
					SetVehicleDoorOpen(vehFront, 5, false, false)
					ESX.UI.Menu.CloseAll()
					if globalplate ~= nil or globalplate ~= "" or globalplate ~= " " then
						CloseToVehicle = true
						TriggerServerEvent('esx_truck_inventory:AddVehicleList', globalplate)
						TriggerServerEvent("esx_truck_inventory:getInventory", GetVehicleNumberPlateText(vehFront))
					end
				else
					ESX.ShowNotification('~r~Ce coffre est fermé')
				end
			end
			lastOpen = true
			GUI.Time  = GetGameTimer()
		end, globalplate)
	end
end

local count = 0

-- Key controls
Citizen.CreateThread(function()
  while true do

    Wait(0)
    if IsControlPressed(0, 182) and (GetGameTimer() - GUI.Time) > 1000 then
		if count == 0 then
			openMenuVehicle()
			count = count + 1
		else
			Citizen.Wait(500)
			count = 0
		end
    elseif lastOpen and IsControlPressed(0, 177) and (GetGameTimer() - GUI.Time) > 150 then
	  CloseToVehicle = false
      lastOpen = false
      if lastVehicle > 0 then
      	SetVehicleDoorShut(lastVehicle, 5, false)
		local lastvehicleplatetext = GetVehicleNumberPlateText(lastVehicle)
		TriggerServerEvent('esx_truck_inventory:RemoveVehicleList', lastvehicleplatetext)
      	lastVehicle = 0
      end
      GUI.Time  = GetGameTimer()
    end
  end
end)

-- CloseToVehicle
Citizen.CreateThread(function()
	while true do
    	Citizen.Wait(0)
		local pos = GetEntityCoords(PlayerPedId())
		if CloseToVehicle then
			local vehicle = GetClosestVehicle(pos['x'], pos['y'], pos['z'], 4.0, 0, 70)
			if DoesEntityExist(vehicle) then
				CloseToVehicle = true
			else
				TriggerServerEvent('esx_truck_inventory:RemoveVehicleList', globalplate)
				CloseToVehicle = false
				lastOpen = false
				ESX.UI.Menu.CloseAll()
				SetVehicleDoorShut(lastVehicle, 5, false)
			end
		end
  	end
end)

RegisterNetEvent('esx_truck_inventory:getInventoryLoaded')
AddEventHandler('esx_truck_inventory:getInventoryLoaded', function(inventory, weight)
	local elements = {}
	local vehFrontBack = VehicleInFront()
  	TriggerServerEvent("esx_truck_inventory:getOwnedVehicule")

	table.insert(elements, { label = 'Déposer', count = 0, value = 'deposit'})

	if inventory ~= nil and #inventory > 0 then
		for i=1, #inventory, 1 do
			if inventory[i].type == 'item_standard' then
			    table.insert(elements, {
			    	label     = inventory[i].label .. ' x' .. inventory[i].count,
			        count     = inventory[i].count,
			        value     = inventory[i].name,
					type	  = inventory[i].type
			    })			
			elseif inventory[i].type == 'item_weapon' then
				table.insert(elements, {
					label     = inventory[i].label .. ' [' .. inventory[i].count .. ']',
					count     = inventory[i].count,
					value     = inventory[i].name,
					type	  = inventory[i].type
				})	
			elseif inventory[i].type == 'item_account' then
				table.insert(elements, {
					label     = inventory[i].label .. ' [$' .. inventory[i].count .. ']',
					count     = inventory[i].count,
					value     = inventory[i].name,
					type	  = inventory[i].type
				})	
			end
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'inventory_deposit',
	{
		css = 'santos',
	    title    = 'Contenu du coffre',
	    align    = 'bottom-right',
	    elements = elements,
	},
	function(data, menu)
		if data.current.value == 'deposit' then
	  		local elem = {}

			PlayerData = ESX.GetPlayerData()
			for i=1, #PlayerData.accounts, 1 do
				if PlayerData.accounts[i].name == 'black_money' then
					if PlayerData.accounts[i].money > 0 then
				    	table.insert(elem, {
				      		label     = PlayerData.accounts[i].label .. ' [ $'.. math.floor(PlayerData.accounts[i].money+0.5) ..' ]',
				      		count     = PlayerData.accounts[i].money,
				      		value     = PlayerData.accounts[i].name,
				      		name      = PlayerData.accounts[i].label,
				      		limit     = PlayerData.accounts[i].limit,
				      		type		= 'item_account',
				    	})
				   	end
				end
			end
			
			for i=1, #PlayerData.inventory, 1 do
				if PlayerData.inventory[i].count > 0 then
					table.insert(elem, {
				    	label     = PlayerData.inventory[i].label .. ' x' .. PlayerData.inventory[i].count,
				    	count     = PlayerData.inventory[i].count,
				    	value     = PlayerData.inventory[i].name,
				    	name      = PlayerData.inventory[i].label,
				    	limit     = PlayerData.inventory[i].limit,
				    	type		= 'item_standard',
				    })
				end
			end
			
			local playerPed  = PlayerPedId()
			local weaponList = ESX.GetWeaponList()

			for i=1, #weaponList, 1 do
		  		local weaponHash = GetHashKey(weaponList[i].name)

		  		if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
					local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
					table.insert(elem, {label = weaponList[i].label .. ' [' .. ammo .. ']',name = weaponList[i].label, type = 'item_weapon', value = weaponList[i].name, count = ammo})
		  		end
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'inventory_player',
			{
	  			css = 'santos',
			    title    = 'Contenu de l\'inventaire',
			    align    = 'bottom-right',
			    elements = elem,
			},
			function(data3, menu3)
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'inventory_item_count_give',
				{
					title = 'Quantité'
				},
				function(data4, menu4)
            		local quantity = tonumber(data4.value)
            		local Itemweight = tonumber(getItemyWeight(data3.current.value)) * quantity
            		local totalweight = tonumber(weight) + Itemweight
            		vehFront = VehicleInFront()

		            local typeVeh = GetVehicleClass(vehFront)

		            if totalweight > Config.VehicleLimit[typeVeh] then
		            	max = true
		            else
		            	max = false
		            end

		            ownedV = 0

		            while vehiclePlate == '' do
		            	Wait(1000)
		            end

		            for i=1, #vehiclePlate do
		            	if vehiclePlate[i].plate == GetVehicleNumberPlateText(vehFront) then
		                	ownedV = 1
		                	break
		              	else
		                	ownedV = 0
		              	end
		            end

		            if quantity > 0 and quantity <= tonumber(data3.current.count) and vehFront > 0  then
		            	local MaxVh =(tonumber(Config.VehicleLimit[typeVeh])/1000)
		            	local Kgweight =  totalweight/1000
		            	if not max then
		              		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(),true))
		  					local closecar = GetClosestVehicle(x, y, z, 4.0, 0, 71)
		  					TriggerServerEvent('esx_truck_inventory:addInventoryItem', GetVehicleClass(closecar), GetDisplayNameFromVehicleModel(GetEntityModel(closecar)), GetVehicleNumberPlateText(vehFront), data3.current.value, quantity, data3.current.name, data3.current.type, ownedV)
		                	ESX.ShowNotification('Poids du coffre : ~g~'.. Kgweight .. ' Kg / '..MaxVh..'kg')
							Citizen.Wait(100)
							TriggerServerEvent("esx_truck_inventory:getInventory", GetVehicleNumberPlateText(vehFront))
		              	else
		                	ESX.ShowNotification('Vous avez atteint la limite de ~r~ '..MaxVh..'kg')
		              	end
					else
						ESX.ShowNotification('~r~Quantité invalide')
					end
				    ESX.UI.Menu.CloseAll()
				end,
				function(data4, menu4)
					SetVehicleDoorShut(vehFrontBack, 5, false)
					ESX.UI.Menu.CloseAll()
					local lastvehicleplatetext = GetVehicleNumberPlateText(vehFrontBack)
					TriggerServerEvent('esx_truck_inventory:RemoveVehicleList', lastvehicleplatetext)
				end)
			end,
			function(data, menu)
				menu.close()
			end)
		elseif data.current.type == 'cancel' then
			menu.close()
	  	else
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'inventory_item_count_give',
			{
				title = 'Quantité'
			},
			function(data2, menu2)
				local quantity = tonumber(data2.value)
				PlayerData = ESX.GetPlayerData()
			    vehFront = VehicleInFront()

			    if quantity ~= nil and quantity > 0 then
	          		local Itemweight = tonumber(getItemyWeight(data.current.value)) * quantity
	          		local poid = weight - Itemweight
				
	          		for i=1, #PlayerData.inventory, 1 do
	            		if PlayerData.inventory[i].name == data.current.value then
	              			if tonumber(PlayerData.inventory[i].limit) < tonumber(PlayerData.inventory[i].count) + quantity and PlayerData.inventory[i].limit ~= -1 then
	                			max = true
	              			else
	                			max = false
	              			end
	            		end
	          		end

					if quantity <= tonumber(data.current.count) and vehFront > 0 then
	            		if not max then
	            			if data.current.type == "item_weapon" then
	            				if quantity ~= data.current.count then
	            					ESX.ShowNotification('~r~Vous devez mettre le maximum de munitions pour retirer l\'arme. :)')
	            					ESX.UI.Menu.CloseAll()
	            					return
	            				end
	            			end
	               			TriggerServerEvent('esx_truck_inventory:removeInventoryItem', GetVehicleNumberPlateText(vehFront), data.current.value, data.current.type, quantity)
	               			local typeVeh = GetVehicleClass(vehFront)
	               			local MaxVh =(tonumber(Config.VehicleLimit[typeVeh])/1000)
	               			local Itemweight =tonumber(getItemyWeight(data.current.value)) * quantity
	               			local totalweight = tonumber(weight) - Itemweight
	               			local Kgweight =  totalweight / 1000
	               			ESX.ShowNotification('Poids du coffre : ~g~'.. Kgweight .. ' Kg / '..MaxVh..' Kg')
	            		else
	             			ESX.ShowNotification('~r~Tu en porte trop')
	           			end
				    else
				    	ESX.ShowNotification('~r~Quantité invalide')
				    end
				    ESX.UI.Menu.CloseAll()

		        	local vehFront = VehicleInFront()
		          	if vehFront > 0 then
		          		ESX.SetTimeout(1500, function()
		              		TriggerServerEvent("esx_truck_inventory:getInventory", GetVehicleNumberPlateText(vehFront))
		          		end)
		            else
		            	SetVehicleDoorShut(vehFrontBack, 5, false)
		            end
		        end
			end,
			function(data2, menu2)
                ESX.UI.Menu.CloseAll()
                local lastvehicleplatetext = GetVehicleNumberPlateText(vehFrontBack)
                TriggerServerEvent('esx_truck_inventory:RemoveVehicleList', lastvehicleplatetext)
            end)
        end
    end,
	function(data, menu)
		menu.close()
	end)
end)


function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end
