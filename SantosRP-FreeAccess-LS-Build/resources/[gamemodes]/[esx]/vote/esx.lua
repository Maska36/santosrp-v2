-- Ceci est un exemple basique utilisant ESX.
-- C'est seulement une demo, à vous de modifier à votre convenance.

ESX = nil

TriggerEvent('esx:getSO', function(obj) ESX = obj end)

function getIdentity(source)
    local identifier = GetPlayerIdentifiers(source)[1]
    local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
    if result[1] ~= nil then
        local identity = result[1]

        return {
            identifier = identity['identifier'],
            name = identity['name'],
            firstname = identity['firstname'],
            lastname = identity['lastname'],
            dateofbirth = identity['dateofbirth'],
            sex = identity['sex'],
            height = identity['height'],
            job = identity['job'],
            group = identity['group']
        }
    else
        return nil
    end
end

local function getPlayerByName(playername)
    local _source = source
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        local identityxPlayer = getIdentity(_source)
        local namexPlayer = identityxPlayer.firstname..' '..identityxPlayer.lastname

        if xPlayer ~= nil and xPlayer.getName() == playername then
            return xPlayer
        elseif xPlayer ~= nil and namexPlayer == playername then
            return xPlayer
        end
    end
    return nil
end

AddEventHandler('onPlayerVote', function (playername, ip, date)
    local player = getPlayerByName(playername)
    if player then
        player.addMoney(100)
        print(playername..' à voté pour le serveur ! '..ip)
    else
        print("Joueur introuvable !")
    end
end)
