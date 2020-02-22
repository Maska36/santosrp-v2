ESX = nil
isRoll = false
amount = 25000

TriggerEvent('esx:getSO', function(obj) ESX = obj end)

RegisterServerEvent('esx_wheel:getLucky')
AddEventHandler('esx_wheel:getLucky', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not isRoll then
        if xPlayer ~= nil then
            if xPlayer.getMoney() >= amount then
                xPlayer.removeMoney(amount)
                isRoll = true
                local _randomPrice = math.random(1, 100)
                if _randomPrice == 1 then
                    -- Win car
                    local _subRan = math.random(1,1000)
                    if _subRan <= 1 then
                        _priceIndex = 19
                    else
                        _priceIndex = 3
                    end
                elseif _randomPrice > 1 and _randomPrice <= 6 then
                    -- Win skin AK Gold
                    _priceIndex = 12
                    local _subRan = math.random(1,20)
                    if _subRan <= 2 then
                        _priceIndex = 12
                    else
                        _priceIndex = 7
                    end
                elseif _randomPrice > 6 and _randomPrice <= 15 then
                    -- Black money
                    local _sRan = math.random(1, 4)
                    if _sRan == 1 then
                        _priceIndex = 4
                    elseif _sRan == 2 then
                        _priceIndex = 8
                    elseif _sRan == 3 then
                        _priceIndex = 11
                    else
                        _priceIndex = 16
                    end
                elseif _randomPrice > 15 and _randomPrice <= 25 then
                    -- Win 300,000$
                    local _subRan = math.random(1,20)
                    if _subRan <= 2 then
                        _priceIndex = 5
                    else
                        _priceIndex = 20
                    end
                elseif _randomPrice > 25 and _randomPrice <= 40 then
                    -- 1, 9, 13, 17
                    local _sRan = math.random(1, 4)
                    if _sRan == 1 then
                        _priceIndex = 1
                    elseif _sRan == 2 then
                        _priceIndex = 9
                    elseif _sRan == 3 then
                        _priceIndex = 13
                    else
                        _priceIndex = 17
                    end
                elseif _randomPrice > 40 and _randomPrice <= 60 then
                    local _itemList = {}
                    _itemList[1] = 2
                    _itemList[2] = 6
                    _itemList[3] = 10
                    _itemList[4] = 14
                    _itemList[5] = 18
                    _priceIndex = _itemList[math.random(1, 5)]
                elseif _randomPrice > 60 and _randomPrice <= 100 then
                    local _itemList = {}
                    _itemList[1] = 3
                    _itemList[2] = 7
                    _itemList[3] = 15
                    _itemList[4] = 20
                    _priceIndex = _itemList[math.random(1, 4)]
                end
                -- print("Price " .. _priceIndex)
                SetTimeout(4000, function()
                    isRoll = false
                    -- Give Price
                    if _priceIndex == 1 or _priceIndex == 9 or _priceIndex == 13 or _priceIndex == 17 then
                        -- print("win mu~ 1, giap 3")
                        
						if xPlayer.getInventoryItem('boombox').count < 5 then
	                        xPlayer.addInventoryItem("boombox", 1)
	                    end
                    	if xPlayer.getInventoryItem('lockpick').count < 10 then
	                        xPlayer.addInventoryItem("lockpick", 1)
	                    end
                        TriggerClientEvent('esx:showNotification', _source, "~g~Vous avez gagné un lockpick et 2 boombox !")
                        TriggerEvent('SendToDiscord', _source, "ROUE DE LA FORTUNE LOGS", "**"..GetPlayerName(_source).."** à gagné un lockpick et 2 boombox", 16007897, "inv")
                    elseif _priceIndex == 2 or _priceIndex == 6 or _priceIndex == 10 or _priceIndex == 14 or _priceIndex == 18 then
                        -- print("banh mi + nuoc")
                        xPlayer.addInventoryItem("bread", 10)
                        xPlayer.addInventoryItem("water", 25)
                        TriggerClientEvent('esx:showNotification', _source, "~g~Mmmh miam !! Vous avez gagné du pain et de l'eau !")
                        TriggerEvent('SendToDiscord', _source, "ROUE DE LA FORTUNE LOGS", "**"..GetPlayerName(_source).."** à gagné du pain et de l'eau", 16007897, "inv")
                    elseif _priceIndex == 3 or _priceIndex == 7 or _priceIndex == 15 or _priceIndex == 20 then
                        -- print("Win money")
                        TriggerClientEvent('esx:showNotification', _source, "~r~Vous n'avez rien gagné.. Retentez votre chance plus tard !")
                        TriggerEvent('SendToDiscord', _source, "ROUE DE LA FORTUNE LOGS", "**"..GetPlayerName(_source).."** à rien gagné..", 16007897, "inv")
                    elseif _priceIndex == 4 or _priceIndex == 8 or _priceIndex == 11 or _priceIndex == 16 then
                        -- print("Black money x2")
                        local _blackMoney = 0
                        if _priceIndex == 4 then
                            _blackMoney = 10000
                        elseif _priceIndex == 8 then
                            _blackMoney = 15000
                        elseif _priceIndex == 11 then
                            _blackMoney = 20000
                        elseif _priceIndex == 16 then
                            _blackMoney = 25000
                        end
                        xPlayer.addAccountMoney("black_money", _blackMoney * 10)

                        local bmoney = _blackMoney * 10

                        TriggerClientEvent('esx:showNotification', _source, "~r~Vous avez gagné $"..bmoney.." d'argent sale.")
                        TriggerEvent('SendToDiscord', _source, "ROUE DE LA FORTUNE LOGS", "**"..GetPlayerName(_source).."** à gagné $"..bmoney.." d'argent sale", 16007897, "inv")
                    elseif _priceIndex == 5 then
                        -- print("Win 300,000$")
                        xPlayer.addMoney(300000)
                        TriggerClientEvent('esx:showNotification', _source, "~g~Vous avez gagné $300K !!")
                        TriggerEvent('SendToDiscord', _source, "ROUE DE LA FORTUNE LOGS", "**"..GetPlayerName(_source).."** à gagné $300K!", 16007897, "inv")
                    elseif _priceIndex == 12 then
                        -- print("Win pistol")
                        TriggerClientEvent("esx_wheel:winWeap", _source)
                        TriggerClientEvent('esx:showNotification', _source, "~y~Vous avez gagné un pistolet !!!")
                        TriggerEvent('SendToDiscord', _source, "ROUE DE LA FORTUNE LOGS", "**"..GetPlayerName(_source).."** à gagné un pistolet !", 16007897, "inv")
                    elseif _priceIndex == 19 then
                        -- print("Win car lp700r")
                        TriggerClientEvent("esx_wheel:winCar", _source)
                        TriggerClientEvent('esx:showNotification', _source, "~y~Vous avez gagné une McLaren P1 !!!")
                        TriggerEvent('SendToDiscord', _source, "ROUE DE LA FORTUNE LOGS", "**"..GetPlayerName(_source).."** à gagné une McLaren P1 !", 16007897, "inv")
                    end
                    TriggerClientEvent("esx_wheel:rollFinished", -1)
                end)
                TriggerClientEvent("esx_wheel:doRoll", -1, _priceIndex)
            else
                TriggerClientEvent('esx:showNotification', _source, "~r~Vous n'avez pas assez d'argent pour jouer.\nVous avez besoin de $" .. ESX.Math.GroupDigits(amount) .. " !")
            	TriggerClientEvent("esx_wheel:rollFinished", -1)
            end
        end
    end
end)
