ESX = nil

TriggerEvent('esx:getSO', function(obj) ESX = obj end)

local Text = {}
local BanList, BanListLoad, BanListHistory, BanListHistoryLoad = {}, false, {}, false

local ForbiddenEvents = {
  "esx_handcuffs:unlocking",
  "HCheat:TempDisableDetection",
  "esx_weashopjob:addLicense",
  "PayForRepairNow",
  "Esx-MenuPessoal:Boss_recruterplayer",
  "OG_cuffs:cuffCheckNearest",
  "esx_jailer:unjailTime",
  "esx_vehicletrunk:giveDirty",
  "esx:enterpolicecar",
  "Ag",
  "esx_tankerjob:pay",
  "esx_moneywash:withdraw",
  "paramedic:revive",
  "esx-qalle-jail:Wiezienie",
  "esx_moneywash:deposit",
  "8321hiue89js",
  "dropOff",
  "bank:transfer",
  "esx_taxijob:success",
  "c65a46c5-5485-4404-bacf-06a106900258",
  "esx_jailer:sendToJailCatfrajerze",
  "esx_jailler:sendToJail",
  "mission:completed",
  "UnJP",
  "police:cuffGranted",
  "Tem2LPs5Para5dCyjuHm87y2catFkMpV",
  "esx_airlines:addLicense",
  "esx_jailer:sendToJailjebacdisafrajerze",
  "esx:recruterplayer",
  "esx_jailer:jailhype",
  "99kr-burglary:addMoney",
  "blarglebus:finishRoute",
  "paycheck:bonus",
  "js:removejailtime",
  "esx_jailer:sendToJial",
  "AdminMenu:giveDirtyMoney",
  "CheckHandcuff",
  "whoapd:revive",
  "luki_jailer:sendToJail",
  "ljail:jailplayer",
  "esx_pilot:success",
  "truckerJob:success",
  "esx_status:set",
  "alert:sv",
  "esx_society:openBossMenu",
  "esx_truckersjob:payy",
  "esx-qalle-jail:openJailMenu",
  "mellotrainer:s_adminKill",
  "esx:getSharedObject",
  "paycheck:salary",
  "adminmenu:cashoutall",
  "EasyAdmin:kickPlayer",
  "esx-qalle-jail:jailPlayerNew",
  "esx_handcuffs:cuffing",
  "delivery:success",
  "f0ba1292-b68d-4d95-8823-6230cdf282b6",
  "cuffGranted",
  "esx_jail:unjailQuest",
  "ambulancier:selfRespawn",
  "cuffServer",
  "JailUpdate",
  "esx_jailers:sendToJail",
  "ems:revive",
  "esx_jailer:wysylandoo",
  "hazerp:wyslijdopaki",
  "gambling:spend",
  "265df2d8-421b-4727-b01d-b92fd6503f5e",
  "esx_jailer:sendToJailariesfrajerze",
  "esx-jail:jailPlayer",
  "adminmenu:setsalary",
  "adminmenu:allowall",
  "AdminMenu:giveCash",
  "AdminMenu:giveBank",
  "dqd36JWLRC72k8FDttZ5adUKwvwq9n9m",
  "antilynx8:anticheat",
  "antilynxr4:detect",
  "ynx8:anticheat",
  "antilynx8r4a:anticheat",
  "lynx8:anticheat",
  "bank:deposit",
  "Banca:deposit",
  "Banca:withdraw",
  "BsCuff:Cuff696999",
  "DiscordBot:playerDied",
  "esx_ambulancejob:revive",
  "esx_billing:sendBill",
  "esx_blanchisseur:startWhitening",
  "esx_carthief:alertcops",
  "esx_carthief:pay",
  "esx_jail:sendToJail",
  "esx_jailer:sendToJail",
  "esx_jobs:caution",
  "dmv:success",
  "esx_dmvschool:addLicense",
  "eden_garage:payhealth",
  "esx_mecanojob:onNPCJobCompleted",
  "esx_mechanicjob:startHarvest",
  "esx_mechanicjob:startCraft",
  "esx_pizza:pay",
  "esx_banksecurity:pay",
  "esx_policejob:handcuff",
  "esx-qalle-jail:jailPlayer",
  "esx-qalle-hunting:reward",
  "esx-qalle-hunting:sell",
  "esx_ranger:pay",
  "esx_slotmachine:sv:2",
  "esx_skin:responseSaveSkin",
  "esx_vehicleshop:setVehicleOwned",
  "hentailover:xdlol",
  "js:jailuser",
  "LegacyFuel:PayFuel",
  "lscustoms:payGarage",
  "mellotrainer:adminTempBan",
  "mellotrainer:adminKick",
  "NB:destituerplayer",
  "NB:recruterplayer",
  "NB:promouvoirplayer",
  "unCuffServer",
  "uncuffGranted",
  "esx_society:setJob",
  "esx_truckerjob:pay",
  "esx_society:getOnlinePlayers",
  "esx:removeInventoryItem",
  "esx_drugs:startHarvestWeed",
  "esx_drugs:startTransformWeed",
  "esx_drugs:startSellWeed",
  "esx_drugs:startHarvestCoke",
  "esx_drugs:startTransformCoke",
  "esx_drugs:startSellCoke",
  "esx_drugs:startHarvestMeth",
  "esx_drugs:startTransformMeth",
  "esx_drugs:startSellMeth",
  "esx_drugs:startHarvestOpium",
  "esx_drugs:startTransformOpium",
  "esx_drugs:startSellOpium",
  "esx_drugs:stopHarvestCoke",
  "esx_drugs:stopTransformCoke",
  "esx_drugs:stopSellCoke",
  "esx_drugs:stopHarvestMeth",
  "esx_drugs:stopTransformMeth",
  "esx_drugs:stopSellMeth",
  "esx_drugs:stopHarvestWeed",
  "esx_drugs:stopTransformWeed",
  "esx_drugs:stopSellWeed",
  "esx_drugs:stopHarvestOpium",
  "esx_drugs:stopTransformOpium",
  "esx_drugs:stopSellOpium",
  "esx:enterpolicecar",
  "esx_fueldelivery:pay",
  "esx:giveInventoryItem",
  "esx_garbagejob:pay",
  "esx_godirtyjob:pay",
  "esx_gopostaljob:pay",
  "esx_gopostaljob:pay",
  "vrp_slotmachine:server:2"
}

if Config.Lang == "fr" then
	Text = Config.TextFr 
else
	print("FiveM-BanSql : Invalid Config.Lang")
end

local BlacklistedThings = {
	`xs_prop_hamburgher_wl`,
	`prop_fnclink_05crnr1`,
	`cargoplane`,
	`prop_prlg_snowpile`,
	`p_crahsed_heli_s`,
	`prop_rock_4_big2`,
	`prop_beachflag_le`,
	`jet`,
	`stt_prop_stunt_soccer_ball`,
	`p_spinning_anus_s`,
	`p_ld_soc_ball_01`,
	`vw_prop_casino_art_basketball_01a`,
	`vw_prop_casino_art_basketball_02a`,
	`v_16_basketball`,
	`prop_cs_hotdog_01`,
	`prop_cs_hotdog_02`,
	`blimp2`,
	`blimp3`,
	`akula`,
	`annihilator`,
	`hunter`,
	`savage`,
	`valkyrie`,
	`valkyrie2`,
	`chernobog`,
	`khanjali`,
	`scarab`,
	`scarab2`,
	`scarab3`,
	`thruster`,
	`barrage`,
	`halftrack`,
	`oppressor2`,
	`lazer`,
	`hydra`,
	`strikeforce`,
	`besra`,
	`scramjet`,
	`prop_barrel_02a`,
	`prop_barrel_02b`,
	`prop_windmill_01`,
	`prop_windmill_01_l1`,
	`prop_windmill_01_slod`,
	`prop_cs_dildo_01`,
	`stt_prop_stunt_track_bumps`,
	`stt_prop_stunt_track_cutout`,
	`stt_prop_stunt_track_dwlink`,
	`stt_prop_stunt_track_dwlink_02`,
	`stt_prop_stunt_track_dwsh15`,
	`stt_prop_stunt_track_dwshort`,
	`stt_prop_stunt_track_dwslope15`,
	`stt_prop_stunt_track_dwslope30`,
	`stt_prop_stunt_track_dwslope45`,
	`stt_prop_stunt_track_dwturn`,
	`stt_prop_stunt_track_dwuturn`,
	`stt_prop_stunt_track_exshort`,
	`stt_prop_stunt_track_fork`,
	`stt_prop_stunt_track_funlng`,
	`stt_prop_stunt_track_funnel`,
	`stt_prop_stunt_track_hill`,
	`stt_prop_stunt_track_hill2`,
	`stt_prop_stunt_track_jump`,
	`stt_prop_stunt_track_link`,
	`stt_prop_stunt_track_otake`,
	`stt_prop_stunt_track_sh15`,
	`stt_prop_stunt_track_sh30`,
	`stt_prop_stunt_track_sh45`,
	`stt_prop_stunt_track_sh45_a`,
	`stt_prop_stunt_track_short`,
	`stt_prop_stunt_track_slope15`,
	`stt_prop_stunt_track_slope30`,
	`stt_prop_stunt_track_slope45`,
	`stt_prop_stunt_track_start`
}

AddEventHandler('entityCreated', function(entity)
    if not DoesEntityExist(entity) then
        return
    end
    
    if DoesEntityExist(entity) then
		if GetEntityType(entity) > 0 then
			local model = GetEntityModel(entity)

			for i, objName in ipairs(BlacklistedThings) do
				if model == objName then
    				local src = NetworkGetEntityOwner(entity)
    				local xPlayer = ESX.GetPlayerFromId(src)

					if xPlayer then
						local playergroup = xPlayer.getGroup()
					
						if playergroup == "user" then
							if src ~= nil or src ~= 0 then
								local entID = NetworkGetNetworkIdFromEntity(entity)
								if entID ~= 0 or entID ~= nil then 
									TriggerEvent('SendToDiscord', src, "Spawn Detection", "**"..GetPlayerName(src).."** fait spawn des trucs, la il est ban :frowning: ", 16007897, "cheat")
									TriggerClientEvent('DespawnObj', src, entID)
									banAutist(src)
									if DoesEntityExist(entity) then
										TriggerClientEvent('DespawnObj', src, entID)
									end
								end
							end
						end
					end
				end
			end
		else
			return
		end
    end
end)

function banAutist(src)
	local source = src
	local reason = "Spawn Cheat"
	local license,identifier,liveid,xblid,discord,playerip
	local duree = 0

	if source and source > 0 then
		local ping = GetPlayerPing(source)

		if ping and ping > 0 then
			local sourceplayername = "Anti-Cheat"
			local targetplayername = GetPlayerName(source)
			for k,v in ipairs(GetPlayerIdentifiers(source))do
				if string.sub(v, 1, string.len("license:")) == "license:" then
					license = v
				elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
					identifier = v
				elseif string.sub(v, 1, string.len("live:")) == "live:" then
					liveid = v
				elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
					xblid  = v
				elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
					discord = v
				elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
					playerip = v
				end
			end
			ban(source,license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason, 1)
			DropPlayer(source, "Vous avez été ban perm pour : "..reason.." | Si vous pensez que c'est une erreur, postez votre demande de déban sur discord.")
		end
	end
end

CreateThread(function()
	while true do
		Wait(1000)
        if BanListLoad == false then
			loadBanList()
			if BanList ~= {} then
				BanListLoad = true
			else
				print(Text.starterror)
			end
		end
		if BanListHistoryLoad == false then
			loadBanListHistory()
            if BanListHistory ~= {} then
				BanListHistoryLoad = true
			else
				print(Text.starterror)
			end
		end
	end
end)

TriggerEvent('es:addGroupCommand', 'sqlbanreload', Config.permission, function (source)
  BanListLoad        = false
  BanListHistoryLoad = false
  Wait(5000)
  if BanListLoad == true then
	TriggerEvent('bansql:sendMessage', source, Text.banlistloaded)
	if BanListHistoryLoad == true then
		TriggerEvent('bansql:sendMessage', source, Text.historyloaded)
	end
  else
	TriggerEvent('bansql:sendMessage', source, Text.loaderror)
  end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM ', 'Insufficient Permissions.' } })
end, {help = Text.reload})


TriggerEvent('es:addGroupCommand', 'sqlbanhistory', Config.permission, function (source, args, user)
 if args[1] and BanListHistory then
	local nombre = tonumber(args[1])
	local name = table.concat(args, " ",1)
	if name ~= "" then

			if nombre and nombre > 0 then
					local expiration = BanListHistory[nombre].expiration
					local timeat     = BanListHistory[nombre].timeat
					local calcul1    = expiration - timeat
					local calcul2    = calcul1 / 86400
					local calcul2 	 = math.ceil(calcul2)
					local resultat   = tostring(BanListHistory[nombre].targetplayername.." , "..BanListHistory[nombre].sourceplayername.." , "..BanListHistory[nombre].reason.." , "..calcul2..Text.day.." , "..BanListHistory[nombre].added)
					
					TriggerEvent('bansql:sendMessage', source, (nombre .." : ".. resultat))
			else
					for i = 1, #BanListHistory, 1 do
						if (tostring(BanListHistory[i].targetplayername)) == tostring(name) then
							local expiration = BanListHistory[i].expiration
							local timeat     = BanListHistory[i].timeat
							local calcul1    = expiration - timeat
							local calcul2    = calcul1 / 86400
							local calcul2 	 = math.ceil(calcul2)					
							local resultat   = tostring(BanListHistory[i].targetplayername.." , "..BanListHistory[i].sourceplayername.." , "..BanListHistory[i].reason.." , "..calcul2..Text.day.." , "..BanListHistory[nombre].added)

							TriggerEvent('bansql:sendMessage', source, (i .." : ".. resultat))
						end
					end
			end
	else
		TriggerEvent('bansql:sendMessage', source, Text.invalidname)
	end
  else
	TriggerEvent('bansql:sendMessage', source, Text.cmdhistory)
  end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM ', 'Insufficient Permissions.' } })
end, {help = Text.history, params = {{name = "name", help = Text.steamname}, }})

RegisterServerEvent('bansql:sqlunban')
AddEventHandler('bansql:sqlunban', function(targetName)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		local playergroup = xPlayer.getGroup()

		if playergroup == 'superadmin' or playergroup == 'owner' or playergroup == 'admin' then
			MySQL.Async.fetchAll('SELECT * FROM banlist WHERE targetplayername like @playername', 
			{
				['@playername'] = ("%"..targetName.."%")
			}, function(data)
				if data[1] then
					if #data > 1 then
						TriggerEvent('bansql:sendMessage', source, Text.toomanyresult)
						for i=1, #data, 1 do
							TriggerEvent('bansql:sendMessage', source, data[i].targetplayername)
						end
					else
						MySQL.Async.execute('DELETE FROM banlist WHERE targetplayername = @name',
						{
						  ['@name']  = data[1].targetplayername
						},
							function ()
							loadBanList()
							TriggerEvent('SendToDiscord', source, "Logs", "**"..GetPlayerName(source).."** à unban **"..data[1].targetplayername.."**", 16007897, "admin")
							TriggerEvent('bansql:sendMessage', source, data[1].targetplayername .. Text.isunban)
						end)
					end
				else
					TriggerEvent('bansql:sendMessage', source, Text.invalidname)
				end

		    end)
		end
	end
end)

TriggerEvent('es:addGroupCommand', 'sqlunban', Config.permission, function (source, args, user)
  if args[1] then
    local target = table.concat(args, " ")
	MySQL.Async.fetchAll('SELECT * FROM banlist WHERE targetplayername like @playername', 
	{
		['@playername'] = ("%"..target.."%")
	}, function(data)
		if data[1] then
			if #data > 1 then
				TriggerEvent('bansql:sendMessage', source, Text.toomanyresult)
				for i=1, #data, 1 do
					TriggerEvent('bansql:sendMessage', source, data[i].targetplayername)
				end
			else
				MySQL.Async.execute(
				'DELETE FROM banlist WHERE targetplayername = @name',
				{
				  ['@name']  = data[1].targetplayername
				},
					function ()
					loadBanList()
					if source ~= nil or source ~= "" then
						TriggerEvent('SendToDiscord', source, "Logs", "**"..GetPlayerName(source).."** à unban **"..data[1].targetplayername.."**", 16007897, "admin")
					else
						TriggerEvent('SendToDiscord', source, "Logs", "**La Console à unban **"..data[1].targetplayername.."**", 16007897, "admin")
					end
					TriggerEvent('bansql:sendMessage', source, data[1].targetplayername .. Text.isunban)
				end)
			end
		else
			TriggerEvent('bansql:sendMessage', source, Text.invalidname)
		end

    end)
  else
	TriggerEvent('bansql:sendMessage', source, Text.cmdunban)
  end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM ', 'Insufficient Permissions.' } })
end, {help = Text.unban, params = {{name = "name", help = Text.steamname}}})

TriggerEvent('es:addGroupCommand', 'sqlban', Config.permission, function (source, args, user)
	local license,identifier,liveid,xblid,discord,playerip
	local target = tonumber(args[1])
	local duree = tonumber(args[2])
	local reason = table.concat(args, " ", 3)

	if args[1] then		
		if reason == "" then
			reason = Text.noreason
		end
		if target and target > 0 then
			local ping = GetPlayerPing(target)
        
			if ping and ping > 0 then
				if duree and duree < 365 then
					local sourceplayername = GetPlayerName(source)
					local targetplayername = GetPlayerName(target)
						for k,v in ipairs(GetPlayerIdentifiers(target))do
							if string.sub(v, 1, string.len("license:")) == "license:" then
								license = v
							elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
								identifier = v
							elseif string.sub(v, 1, string.len("live:")) == "live:" then
								liveid = v
							elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
								xblid  = v
							elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
								discord = v
							elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
								playerip = v
							end
						end
				
					TriggerEvent('SendToDiscord', source, "Logs", "**"..sourceplayername.."** à ban **"..targetplayername.."**", 16007897, "admin")
					if duree > 0 then
						ban(source,license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,0) --Timed ban here
						DropPlayer(target, "Raison: "..reason.." - Bannis par "..sourceplayername)
					elseif duree == 0 then
						ban(source,license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,1) --Perm ban here
						DropPlayer(target, "Raison: "..reason.." - Bannis par "..sourceplayername)
					end
				
				else
					TriggerEvent('bansql:sendMessage', source, Text.invalidtime)
				end	
			else
				TriggerEvent('bansql:sendMessage', source, Text.invalidid)
			end
		else
			TriggerEvent('bansql:sendMessage', source, Text.invalidid)
		end
	else
		TriggerEvent('bansql:sendMessage', source, Text.cmdban)
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM ', 'Insufficient Permissions.' } })
end, {help = Text.ban, params = {{name = "id"}, {name = "day", help = Text.dayhelp}, {name = "reason", help = Text.reason}}})

TriggerEvent('es:addGroupCommand', 'sqlsearch', Config.permission, function (source, args, user)
	if args ~= "" then
		local target = table.concat(args, " ")
		if target ~= "" then
			MySQL.Async.fetchAll('SELECT * FROM baninfo WHERE playername like @playername', 
			{
				['@playername'] = ("%"..target.."%")
			}, function(data)
				if data[1] then
					if #data < 50 then
						for i=1, #data, 1 do
							TriggerEvent('bansql:sendMessage', source, data[i].id.." "..data[i].playername)
						end
					else
						TriggerEvent('bansql:sendMessage', source, Text.toomanyresult)
					end
				else
					TriggerEvent('bansql:sendMessage', source, Text.invalidname)
				end
			end)
		else
			TriggerEvent('bansql:sendMessage', source, Text.invalidname)
		end
	else
		TriggerEvent('bansql:sendMessage', source, Text.cmdbanoff)
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM ', 'Insufficient Permissions.' } })
end, {help = Text.bansearch, params = {{name = "name", help = Text.steamname}}})

TriggerEvent('es:addGroupCommand', 'sqlbanoffline', Config.permission, function (source, args, user)
	if args ~= "" then
		local target           = tonumber(args[1])
		local duree            = tonumber(args[2])
		local reason           = table.concat(args, " ",3)
		local sourceplayername = GetPlayerName(source)

		if duree ~= "" then
			if target ~= "" then
				MySQL.Async.fetchAll('SELECT * FROM baninfo WHERE id = @id', 
				{
					['@id'] = target
				}, function(data)
					if data[1] then
						if duree and duree < 365 then
							if reason == "" then
								reason = Text.noreason
							end
							if duree > 0 then --Here if not perm ban
								ban(source,data[1].license,data[1].identifier,data[1].liveid,data[1].xblid,data[1].discord,data[1].playerip,data[1].playername,sourceplayername,duree,reason,0) --Timed ban here
							else --Here if perm ban
								ban(source,data[1].license,data[1].identifier,data[1].liveid,data[1].xblid,data[1].discord,data[1].playerip,data[1].playername,sourceplayername,duree,reason,1) --Perm ban here
							end

							TriggerEvent('SendToDiscord', source, "Logs", "**"..sourceplayername.."** à ban offline **"..data[1].playername.."**", 16007897, "admin")
						else
							TriggerEvent('bansql:sendMessage', source, Text.invalidtime)
						end
					else
						TriggerEvent('bansql:sendMessage', source, Text.invalidid)
					end
				end)
			else
				TriggerEvent('bansql:sendMessage', source, Text.invalidname)
			end
		else
			TriggerEvent('bansql:sendMessage', source, Text.invalidtime)
			TriggerEvent('bansql:sendMessage', source, Text.cmdbanoff)
		end
	else
		TriggerEvent('bansql:sendMessage', source, Text.cmdbanoff)
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM ', 'Insufficient Permissions.' } })
end, {help = Text.banoff, params = {{name = "permid", help = Text.permid}, {name = "day", help = Text.dayhelp}, {name = "reason", help = Text.reason}}})

-- console / rcon can also utilize es:command events, but breaks since the source isn't a connected player, ending up in error messages
AddEventHandler('bansql:sendMessage', function(source, message)
	if source ~= 0 then
		TriggerClientEvent('chat:addMessage', source, { args = { '^1Banlist ', message } } )
	else
		print('SqlBan: ' .. message)
	end
end)

AddEventHandler('playerConnecting', function (playerName,setKickReason)
	local license,steamID,liveid,xblid,discord,playerip  = "n/a","n/a","n/a","n/a","n/a","n/a"

	for k,v in ipairs(GetPlayerIdentifiers(source))do
		if string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
			steamID = v
		elseif string.sub(v, 1, string.len("live:")) == "live:" then
			liveid = v
		elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
			xblid  = v
		elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
			discord = v
		elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
			playerip = v
		end
	end

	--Si Banlist pas chargée
	if (Banlist == {}) then
		Citizen.Wait(1000)
	end

    if steamID == "n/a" and Config.ForceSteam then
		setKickReason(Text.invalidsteam)
		CancelEvent()
    end

	for i = 1, #BanList, 1 do
		if 
			  ((tostring(BanList[i].license)) == tostring(license) 
			or (tostring(BanList[i].identifier)) == tostring(steamID) 
			or (tostring(BanList[i].liveid)) == tostring(liveid) 
			or (tostring(BanList[i].xblid)) == tostring(xblid) 
			or (tostring(BanList[i].discord)) == tostring(discord) 
			or (tostring(BanList[i].playerip)) == tostring(playerip)) 
		then

			if (tonumber(BanList[i].permanent)) == 1 then

				setKickReason(Text.yourpermban .. BanList[i].reason)
				CancelEvent()
				break

			elseif (tonumber(BanList[i].expiration)) > os.time() then

				local tempsrestant     = (((tonumber(BanList[i].expiration)) - os.time())/60)
				if tempsrestant >= 1440 then
					local day        = (tempsrestant / 60) / 24
					local hrs        = (day - math.floor(day)) * 24
					local minutes    = (hrs - math.floor(hrs)) * 60
					local txtday     = math.floor(day)
					local txthrs     = math.floor(hrs)
					local txtminutes = math.ceil(minutes)
						setKickReason(Text.yourban .. BanList[i].reason .. Text.timeleft .. txtday .. Text.day ..txthrs .. Text.hour ..txtminutes .. Text.minute)
						CancelEvent()
						break
				elseif tempsrestant >= 60 and tempsrestant < 1440 then
					local day        = (tempsrestant / 60) / 24
					local hrs        = tempsrestant / 60
					local minutes    = (hrs - math.floor(hrs)) * 60
					local txtday     = math.floor(day)
					local txthrs     = math.floor(hrs)
					local txtminutes = math.ceil(minutes)
						setKickReason(Text.yourban .. BanList[i].reason .. Text.timeleft .. txtday .. Text.day .. txthrs .. Text.hour .. txtminutes .. Text.minute)
						CancelEvent()
						break
				elseif tempsrestant < 60 then
					local txtday     = 0
					local txthrs     = 0
					local txtminutes = math.ceil(tempsrestant)
						setKickReason(Text.yourban .. BanList[i].reason .. Text.timeleft .. txtday .. Text.day .. txthrs .. Text.hour .. txtminutes .. Text.minute)
						CancelEvent()
						break
				end

			elseif (tonumber(BanList[i].expiration)) < os.time() and (tonumber(BanList[i].permanent)) == 0 then

				deletebanned(license)
				break
			end
		end
	end
end)

AddEventHandler('es:playerLoaded',function(source)
	CreateThread(function()
	Wait(5000)
		local license,steamID,liveid,xblid,discord,playerip
		local playername = GetPlayerName(source)

		for k,v in ipairs(GetPlayerIdentifiers(source))do
			if string.sub(v, 1, string.len("license:")) == "license:" then
				license = v
			elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
				steamID = v
			elseif string.sub(v, 1, string.len("live:")) == "live:" then
				liveid = v
			elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
				xblid  = v
			elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
				discord = v
			elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
				playerip = v
			end
		end

		MySQL.Async.fetchAll('SELECT * FROM `baninfo` WHERE `license` = @license', {
			['@license'] = license
		}, function(data)
		local found = false
			for i=1, #data, 1 do
				if data[i].license == license then
					found = true
				end
			end
			if not found then
				MySQL.Async.execute('INSERT INTO baninfo (license,identifier,liveid,xblid,discord,playerip,playername) VALUES (@license,@identifier,@liveid,@xblid,@discord,@playerip,@playername)', 
					{ 
					['@license']    = license,
					['@identifier'] = steamID,
					['@liveid']     = liveid,
					['@xblid']      = xblid,
					['@discord']    = discord,
					['@playerip']   = playerip,
					['@playername'] = playername
					},
					function ()
				end)
			else
				MySQL.Async.execute('UPDATE `baninfo` SET `identifier` = @identifier, `liveid` = @liveid, `xblid` = @xblid, `discord` = @discord, `playerip` = @playerip, `playername` = @playername WHERE `license` = @license', 
					{ 
					['@license']    = license,
					['@identifier'] = steamID,
					['@liveid']     = liveid,
					['@xblid']      = xblid,
					['@discord']    = discord,
					['@playerip']   = playerip,
					['@playername'] = playername
					},
					function ()
				end)
			end
		end)
		if Config.MultiServerSync then
			doublecheck(source)
		end
	end)
end)

RegisterServerEvent('BanSql:CheckMe')
AddEventHandler('BanSql:CheckMe', function()
	doublecheck(source)
end)

function ban(source,license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,permanent)
--calcul total expiration (en secondes)
	local expiration = duree * 86400
	local timeat     = os.time()
	local added      = os.date()

	if expiration < os.time() then
		expiration = os.time()+expiration
	end
	
		table.insert(BanList, {
			license    = license,
			identifier = identifier,
			liveid     = liveid,
			xblid      = xblid,
			discord    = discord,
			playerip   = playerip,
			reason     = reason,
			expiration = expiration,
			permanent  = permanent
          })

		MySQL.Async.execute(
                'INSERT INTO banlist (license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,reason,expiration,timeat,permanent) VALUES (@license,@identifier,@liveid,@xblid,@discord,@playerip,@targetplayername,@sourceplayername,@reason,@expiration,@timeat,@permanent)',
                { 
				['@license']          = license,
				['@identifier']       = identifier,
				['@liveid']           = liveid,
				['@xblid']            = xblid,
				['@discord']          = discord,
				['@playerip']         = playerip,
				['@targetplayername'] = targetplayername,
				['@sourceplayername'] = sourceplayername,
				['@reason']           = reason,
				['@expiration']       = expiration,
				['@timeat']           = timeat,
				['@permanent']        = permanent,
				},
				function ()
		end)

		if permanent == 0 then
			TriggerEvent('bansql:sendMessage', source, (Text.youban .. targetplayername .. Text.during .. duree .. Text.forr .. reason))
		else
			TriggerEvent('bansql:sendMessage', source, (Text.youban .. targetplayername .. Text.permban .. reason))
		end

		MySQL.Async.execute(
                'INSERT INTO banlisthistory (license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,reason,added,expiration,timeat,permanent) VALUES (@license,@identifier,@liveid,@xblid,@discord,@playerip,@targetplayername,@sourceplayername,@reason,@added,@expiration,@timeat,@permanent)',
                { 
				['@license']          = license,
				['@identifier']       = identifier,
				['@liveid']           = liveid,
				['@xblid']            = xblid,
				['@discord']          = discord,
				['@playerip']         = playerip,
				['@targetplayername'] = targetplayername,
				['@sourceplayername'] = sourceplayername,
				['@reason']           = reason,
				['@added']            = added,
				['@expiration']       = expiration,
				['@timeat']           = timeat,
				['@permanent']        = permanent,
				},
				function ()
		end)
		
		BanListHistoryLoad = false
end

function loadBanList()
	MySQL.Async.fetchAll(
		'SELECT * FROM banlist',
		{},
		function (data)
		  BanList = {}

		  for i=1, #data, 1 do
			table.insert(BanList, {
				license    = data[i].license,
				identifier = data[i].identifier,
				liveid     = data[i].liveid,
				xblid      = data[i].xblid,
				discord    = data[i].discord,
				playerip   = data[i].playerip,
				reason     = data[i].reason,
				expiration = data[i].expiration,
				permanent  = data[i].permanent
			  })
		  end
    end)
end

function loadBanListHistory()
	MySQL.Async.fetchAll(
		'SELECT * FROM banlisthistory',
		{},
		function (data)
		  BanListHistory = {}

		  for i=1, #data, 1 do
			table.insert(BanListHistory, {
				license          = data[i].license,
				identifier       = data[i].identifier,
				liveid           = data[i].liveid,
				xblid            = data[i].xblid,
				discord          = data[i].discord,
				playerip         = data[i].playerip,
				targetplayername = data[i].targetplayername,
				sourceplayername = data[i].sourceplayername,
				reason           = data[i].reason,
				added            = data[i].added,
				expiration       = data[i].expiration,
				permanent        = data[i].permanent,
				timeat           = data[i].timeat
			  })
		  end
    end)
end

function deletebanned(license) 
	MySQL.Async.execute(
		'DELETE FROM banlist WHERE license=@license',
		{
		  ['@license']  = license
		},
		function ()
			loadBanList()
	end)
end

function doublecheck(player)
	if GetPlayerIdentifiers(player) then
		local license,steamID,liveid,xblid,discord,playerip  = "n/a","n/a","n/a","n/a","n/a","n/a"

		for k,v in ipairs(GetPlayerIdentifiers(player))do
			if string.sub(v, 1, string.len("license:")) == "license:" then
				license = v
			elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
				steamID = v
			elseif string.sub(v, 1, string.len("live:")) == "live:" then
				liveid = v
			elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
				xblid  = v
			elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
				discord = v
			elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
				playerip = v
			end
		end

		for i = 1, #BanList, 1 do
			if 
				  ((tostring(BanList[i].license)) == tostring(license) 
				or (tostring(BanList[i].identifier)) == tostring(steamID) 
				or (tostring(BanList[i].liveid)) == tostring(liveid) 
				or (tostring(BanList[i].xblid)) == tostring(xblid) 
				or (tostring(BanList[i].discord)) == tostring(discord) 
				or (tostring(BanList[i].playerip)) == tostring(playerip)) 
			then

				if (tonumber(BanList[i].permanent)) == 1 then
					DropPlayer(player, Text.yourban .. BanList[i].reason)
					break

				elseif (tonumber(BanList[i].expiration)) > os.time() then

					local tempsrestant     = (((tonumber(BanList[i].expiration)) - os.time())/60)
					if tempsrestant > 0 then
						DropPlayer(player, Text.yourban .. BanList[i].reason)
						break
					end

				elseif (tonumber(BanList[i].expiration)) < os.time() and (tonumber(BanList[i].permanent)) == 0 then

					deletebanned(license)
					break

				end
			end
		end
	end
end

RegisterServerEvent('BanSql:Ban')
AddEventHandler('BanSql:Ban', function(argz, reason)
	local license,identifier,liveid,xblid,discord,playerip
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		local playergroup = xPlayer.getGroup()

		local target = tonumber(argz)
		local targetPlayer = ESX.GetPlayerFromId(target)

		if targetPlayer then
			local targetgroup = targetPlayer.getGroup()

			if source == target or source == nil or source == "" then source = 1 end
			local duree = 0

			if source == 1 or playergroup == "admin" or playergroup == "owner" or playergroup == "superadmin" then
				if targetgroup == "user" or targetgroup == "admin" then
					if argz then
						if target and target > 0 then
							local ping = GetPlayerPing(target)

							if ping and ping > 0 then
								local sourceplayername = GetPlayerName(source)

								if reason == "Event Cheat" or reason == "H Cheat" then
									sourceplayername = "Anti-Cheat"
								end
								local targetplayername = GetPlayerName(target)
								for k,v in ipairs(GetPlayerIdentifiers(target))do
									if string.sub(v, 1, string.len("license:")) == "license:" then
										license = v
									elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
										identifier = v
									elseif string.sub(v, 1, string.len("live:")) == "live:" then
										liveid = v
									elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
										xblid  = v
									elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
										discord = v
									elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
										playerip = v
									end
								end


								xPlayer.showNotification('Vous avez ~g~ban~w~ ~b~['..target..'] '..targetplayername.."\nRaison: "..reason.."~w~")
								TriggerEvent('SendToDiscord', target, "Logs", "**"..sourceplayername.."** à ban **"..targetplayername.."** - Raison : "..reason, 16007897, "admin")
								Wait(100)
								ban(source, license, identifier, liveid, xblid, discord, playerip, targetplayername, sourceplayername, duree, reason.." - Bannis par "..sourceplayername,1)
								DropPlayer(target, "Vous avez été ban perm pour : ".. reason.." - Bannis par "..sourceplayername)
							end
						end
					end
				else
					TriggerEvent('SendToDiscord', source, "Logs", "**"..GetPlayerName(source).."** essaie de ban un admin: "..GetPlayerName(target), 16007897, "admin")
				end
			else
				TriggerEvent('SendToDiscord', source, "Event Exec", "**"..GetPlayerName(source).."** essaie de ban tout le monde", 16007897, "cheat")
			end
		end
	end
end)

for i, eventName in ipairs(ForbiddenEvents) do
	RegisterServerEvent(eventName)
	AddEventHandler(eventName, function()
		local source = source
		local license,identifier,liveid,xblid,discord,playerip
		local duree = 0
		local reason = "Hacker Event mdr"

		if source then
			local ping = GetPlayerPing(source)

			if ping and ping > 0 then
				local sourceplayername = "Anti-Cheat"
				local targetplayername = GetPlayerName(source)
				for k, v in pairs(GetPlayerIdentifiers(source)) do
					if string.sub(v, 1, string.len("license:")) == "license:" then
						license = v
					elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
						identifier = v
					elseif string.sub(v, 1, string.len("live:")) == "live:" then
						liveid = v
					elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
						xblid = v
					elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
						discord = v
					elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
						playerip = v
					end
				end
				TriggerEvent('SendToDiscord', source, "Ban Server", "**"..targetplayername.."** à été ban du serveur psk l'anti cheat a trigger son event pété au sol aka: "..eventName.."\n**Raison:** Hacker Event mdr.", 16007897, "cheat")
				Wait(100)
				ban(source,license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,"Hacker Event mdr.",1)
				DropPlayer(source, "Vous avez été ban perm pour : ".. reason)
			end
		end
    end)
end