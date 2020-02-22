local Melee = { -1569615261, 1737195953, 1317494643, -1786099057, 1141786504, -2067956739, -868994466 }
local Bullet = { 453432689, 1593441988, 584646201, -1716589765, 324215364, 736523883, -270015777, -1074790547, -2084633992, -1357824103, -1660422300, 2144741730, 487013001, 2017895192, -494615257, -1654528753, 100416529, 205991906, 1119849093 }
local Knife = { -1716189206, 1223143800, -1955384325, -1833087301, 910830060, }
local Car = { 133987706, -1553120962 }
local Animal = { -100946242, 148160082 }
local FallDamage = { -842959696 }
local Explosion = { -1568386805, 1305664598, -1312131151, 375527679, 324506233, 1752584910, -1813897027, 741814745, -37975472, 539292904, 341774354, -1090665087 }
local Gas = { -1600701090 }
local Burn = { 615608432, 883325847, -544306709 }
local Drown = { -10959621, 1936677264 }
local alreadyDead = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)
        if IsEntityDead(PlayerPedId()) and not alreadyDead then
            local playerPed = PlayerPedId()
            local playerName = GetPlayerName(PlayerId())

            killer = GetPedKiller(playerPed)
            killername = false

            for _, player in ipairs(GetActivePlayers()) do
                if killer == GetPlayerPed(player) then
                    killername = GetPlayerName(player)
                end
            end

            local death = GetPedCauseOfDeath(playerPed)

            if checkArray (Melee, death) then
                TriggerServerEvent('SendPlayerDied', "**"..killername .. "** à mis un coup avec une arme cac à **" .. playerName.."**")
            elseif checkArray(Bullet, death) then
                TriggerServerEvent('SendPlayerDied', "**"..killername .. "** à tiré sur **" .. playerName.."**")
            elseif checkArray(Knife, death) then
                TriggerServerEvent('SendPlayerDied', "**"..killername .. "** à poignardé **" .. playerName.."**")
            elseif checkArray(Car, death) then
                TriggerServerEvent('SendPlayerDied', "**"..killername .. "** à frappé **" .. playerName.."**")
            elseif checkArray(Animal, death) then
                TriggerServerEvent('SendPlayerDied', "**"..playerName .. "** est mort par un animal")
            elseif checkArray(FallDamage, death) then
                TriggerServerEvent('SendPlayerDied', "**"..playerName .. "** est mort de dégâts de chute")
            elseif checkArray(Explosion, death) then
                TriggerServerEvent('SendPlayerDied', "**"..playerName .. "** est mort d'une explosion")
            elseif checkArray(Gas, death) then
                TriggerServerEvent('SendPlayerDied', "**"..playerName .. "** est mort de gaz")
            elseif checkArray(Burn, death) then
                TriggerServerEvent('SendPlayerDied', "**"..playerName .. "** à été brûlé à mort")
            elseif checkArray(Drown, death) then
                TriggerServerEvent('SendPlayerDied', "**"..playerName .. "** s'est noyé")
            else
                TriggerServerEvent('SendPlayerDied', "**"..playerName .. "** à été tué par une force inconnue")
            end

            alreadyDead = true
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        
        if not IsEntityDead(playerPed) then
            alreadyDead = false
        end
    end
end)

function checkArray(array, val)
    for name, value in ipairs(array) do
        if value == val then
            return true
        end
    end
    return false
end