ESX = nil

TriggerEvent('esx:getSO', function(obj) ESX = obj end)

local DISCORD_WEBHOOK = ""
local CHAT_WEBHOOK = ""
local CHEAT_WEBHOOK = ""
local ADMIN_WEBHOOK = ""
local DEATH_WEBHOOK = ""
local INV_WEBHOOK = ""
local REPORT_WEBHOOK = ""
local DISCORD_NAME = "SantosRP"
local STEAM_KEY = ""
local DISCORD_IMAGE = "https://i.imgur.com/jzqG5c3.png"

AddEventHandler('playerConnecting', function()
	local source = source
	if source then
    	sendToDiscord("Connexion", "**" .. GetPlayerName(source) .. "** à rejoint le serveur.", 65280)
    end
end)

AddEventHandler('playerDropped', function(reason)
	local source = source
	if source then
		local color
		if string.match(reason, "Kicked") then
			color = 16007897
			sendToDiscord("Déconnexion", "**" .. GetPlayerName(source) .. "** à été kick du serveur.\n**Raison:** " .. reason, color)
		elseif string.match(reason, "Banned") then
			color = 16007897
			sendToDiscord("Déconnexion", "**" .. GetPlayerName(source) .. "** à été ban du serveur.\n**Raison:** " .. reason, color)
		else
			color = 16711680
			sendToDiscord("Déconnexion", "**" .. GetPlayerName(source) .. "** à quitté le serveur.\n**Raison:** " .. reason, color)
		end
	end
end)

RegisterServerEvent('SendPlayerDied')
AddEventHandler('SendPlayerDied', function(message)
	local source = source
	if source then
    	sendToDiscord("Death Log", message, 16711680, DEATH_WEBHOOK)
    end
end)

RegisterServerEvent('logsCheat')
AddEventHandler('logsCheat', function(title, message, color)
    sendToCheatDiscord(title, message, color)
end)

function GetIDFromSource(Type, ID)
    local IDs = GetPlayerIdentifiers(ID)
    for k, CurrentID in pairs(IDs) do
        local ID = stringsplit(CurrentID, ':')
        if (ID[1]:lower() == string.lower(Type)) then
            return ID[2]:lower()
        end
    end
    return nil
end

function stringsplit(input, seperator)
	if seperator == nil then
		seperator = '%s'
	end
	
	local t={} ; i=1
	
	for str in string.gmatch(input, '([^'..seperator..']+)') do
		t[i] = str
		i = i + 1
	end
	
	return t
end

function sendToCheatDiscord(name, message, color)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		local playergroup = xPlayer.getGroup()

		local ip = GetPlayerEndpoint(source)

		if playergroup == 'user' then
			local steamhex = GetPlayerIdentifier(source)
			local connect = {
				{
					["color"] = color,
		            ["title"] = "**".. name .."**",
		            ["description"] = message.."\n**IP:** "..ip.."\n**Steam Hex:** "..steamhex.."\n**ID:** "..source,
		            ["footer"] = {
						["text"] = "SantosRP - play.santosrp.fr",
		            },
		        }
		    }
			PerformHttpRequest(CHEAT_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
		end
	end
end

function sendToDiscord(name, message, color, webhook)
	webhook = webhook or DISCORD_WEBHOOK
	local ip = GetPlayerEndpoint(source)
	local steamhex = GetPlayerIdentifier(source)

	local connect = {
		{
			["color"] = color,
            ["title"] = "**".. name .."**",
            ["description"] = message.."\n**IP:** "..ip.."\n**Steam Hex:** "..steamhex.."\n**ID:** "..source,
            ["footer"] = {
				["text"] = "SantosRP - play.santosrp.fr",
            },
        }
    }
	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end

function sendToDiscordStatus(name, message, color, webhook)
	webhook = webhook or DISCORD_WEBHOOK
	local connect = {
		{
			["color"] = color,
            ["title"] = "**".. name .."**",
            ["description"] = message,
            ["footer"] = {
				["text"] = "SantosRP - play.santosrp.fr",
            },
        }
    }
	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent('SendToDiscord')
AddEventHandler('SendToDiscord', function(source, name, message, color, Type)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		local playergroup = xPlayer.getGroup()
		local ip = GetPlayerEndpoint(source)
		local steamhex = GetPlayerIdentifier(source)

		if playergroup then
			if playergroup == 'superadmin' then
				ip = "regarde pas ici fils de pute"
			else
				ip = GetPlayerEndpoint(source)
			end
		else
			ip = GetPlayerEndpoint(source)
		end
		local connect = {
			{
				["color"] = color,
	            ["title"] = "**".. name .."**",
	            ["description"] = message.."\n**IP:** "..ip.."\n**Steam Hex:** "..steamhex.."\n**ID:** "..source,
	            ["footer"] = {
					["text"] = "SantosRP - play.santosrp.fr",
	            },
	        }
	    }
	    if Type == "chat" then
			PerformHttpRequest(CHAT_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
		elseif Type == "cheat" then
			PerformHttpRequest(CHEAT_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
		elseif Type == "logs" or Type == "" or Type == nil then
			PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
		elseif Type == "admin" or Type == "" or Type == nil then
			PerformHttpRequest(ADMIN_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
		elseif Type == "inv" or Type == "" or Type == nil then
			PerformHttpRequest(INV_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
		elseif Type == "report" or Type == "" or Type == nil then
			PerformHttpRequest(REPORT_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
		end
	end
end)

if GetConvar('srvbuild') == "LIVE" then
	sendToDiscordStatus("STATUS LIVE SERVER", "SERVEUR ON :white_check_mark:", 65280, "")
elseif GetConvar('srvbuild') == "TEST" then
	sendToDiscordStatus("STATUS TEST SERVER", "SERVEUR ON :white_check_mark:", 65280, "")
end
