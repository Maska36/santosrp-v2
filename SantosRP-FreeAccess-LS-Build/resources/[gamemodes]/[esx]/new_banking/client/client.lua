ESX = nil
inMenu = false
local atbank = false
local bankMenu = true

function playAnim(animDict, animName, duration)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do Citizen.Wait(0) end
	TaskPlayAnim(PlayerPedId(), animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
	RemoveAnimDict(animDict)
end

--===============================================
--==           Base ESX Threading              ==
--===============================================
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSO', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

--===============================================
--==             Core Threading                ==
--===============================================
if bankMenu then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			if not inMenu then
				if nearBank() or nearATM() then
					DisplayHelpText(_U('atm_open'))
					if IsControlJustPressed(1, 38) then
						playAnim('mp_common', 'givetake1_a', 2500)
						Citizen.Wait(1000)
						inMenu = true
						SetNuiFocus(true, true)
						SendNUIMessage({type = 'openGeneral'})
						TriggerServerEvent('bank:balance')
					end

					if inMenu then
						if IsControlJustPressed(1, 322) then
							inMenu = false
							SetNuiFocus(false, false)
							SendNUIMessage({type = 'close'})
						end
					end
				else
					Citizen.Wait(500)
				end
			end
		end
	end)
end


--===============================================
--==             Map Blips	                   ==
--===============================================

--BANK
Citizen.CreateThread(function()
	for k,v in ipairs(Config.Bank) do
		local blip = AddBlipForCoord(v)
		SetBlipSprite (blip, Config.BankBlip)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.8)
		SetBlipColour (blip, 2)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('bank_blip'))
		EndTextCommandSetBlipName(blip)
	end
end)

--===============================================
--==           Deposit Event                   ==
--===============================================
RegisterNetEvent('currentbalance1')
AddEventHandler('currentbalance1', function(balance)
	local playerName = GetPlayerName(PlayerId())

	SendNUIMessage({ type = "balanceHUD", balance = balance, player = playerName })
end)
--===============================================
--==           Deposit Event                   ==
--===============================================
RegisterNUICallback('deposit', function(data)
	TriggerServerEvent('santosbank:deposit', tonumber(data.amount))
	TriggerServerEvent('bank:balance')
end)

--===============================================
--==          Withdraw Event                   ==
--===============================================
RegisterNUICallback('withdrawl', function(data)
	TriggerServerEvent('santosbank:withdraw', tonumber(data.amountw))
	TriggerServerEvent('bank:balance')
end)

--===============================================
--==         Balance Event                     ==
--===============================================
RegisterNUICallback('balance', function()
	TriggerServerEvent('bank:balance')
end)

RegisterNetEvent('balance:back')
AddEventHandler('balance:back', function(balance)
	SendNUIMessage({type = 'balanceReturn', bal = balance})
end)


--===============================================
--==         Transfer Event                    ==
--===============================================
RegisterNUICallback('transfer', function(data)
	TriggerServerEvent('bk:transfer', data.to, data.amountt)
	TriggerServerEvent('bank:balance')
end)

--===============================================
--==         Result   Event                    ==
--===============================================
RegisterNetEvent('bank:result')
AddEventHandler('bank:result', function(type, message)
	SendNUIMessage({type = 'result', m = message, t = type})
end)

--===============================================
--==               NUIFocusoff                 ==
--===============================================
RegisterNUICallback('NUIFocusOff', function()
	inMenu = false
	SetNuiFocus(false, false)
	playAnim('mp_common', 'givetake1_a', 2500)
	Citizen.Wait(2500)
	SendNUIMessage({type = 'closeAll'})
end)


--===============================================
--==            Capture Bank Distance          ==
--===============================================
function nearBank()
	local playerCoords = GetEntityCoords(PlayerPedId())

	for k,v in ipairs(Config.Bank) do
		local distance = #(playerCoords - v)

		if distance <= 3 then
			return true
		end
	end

	return false
end

function nearATM()
	local playerCoords = GetEntityCoords(PlayerPedId())

	for k,v in ipairs(Config.ATM) do
		local distance = #(playerCoords - v)

		if distance <= 2 then
			return true
		end
	end
	
	return false
end


function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end