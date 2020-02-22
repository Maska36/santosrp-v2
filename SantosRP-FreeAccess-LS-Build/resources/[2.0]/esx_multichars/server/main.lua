---------------------------------------------------------------------------------------
-- Edit this table to all the database tables and columns
-- where identifiers are used (such as users, owned_vehicles, owned_properties etc.)
---------------------------------------------------------------------------------------
local IdentifierTables = {
    {table = "addon_account_data", column = "owner"},
    {table = "addon_inventory_items", column = "owner"},
    {table = "billing", column = "identifier"},
    {table = "characters", column = "identifier"},
    {table = "datastore_data", column = "owner"},
    {table = "owned_vehicles", column = "owner"},
    {table = "rented_vehicles", column = "owner"},
    {table = "society_moneywash", column = "identifier"},
    {table = "users", column = "identifier"},
    {table = "user_accounts", column = "identifier"},
    {table = "user_inventory", column = "identifier"},
    {table = "user_licenses", column = "owner"},
    {table = "user_sim", column = "identifier"},
    {table = "phone_users_contacts", column = "identifier"},
}


RegisterServerEvent("esx_multichars:SetupCharacters")
AddEventHandler('esx_multichars:SetupCharacters', function()
    local src = source
    local LastCharId = GetLastCharacter(src)
    SetIdentifierToChar(GetPlayerIdentifiers(src)[1], LastCharId)
    
    local Characters = GetPlayerCharacters(src)
    TriggerClientEvent('esx_multichars:SetupUI', src, Characters)
end)

RegisterServerEvent("esx_multichars:CharacterChosen")
AddEventHandler('esx_multichars:CharacterChosen', function(charid, ischar)
    local src = source
    local spawn = {}
    SetLastCharacter(src, tonumber(charid))
    SetCharToIdentifier(GetPlayerIdentifiers(src)[1], tonumber(charid))

    if ischar == "true" then
        spawn = GetSpawnPos(src)
    else
		TriggerClientEvent('skinchanger:loadDefaultModel', src, true, cb)
        spawn = { x = 640.824, y = 136.624, z = 94.865 }
    end

    TriggerClientEvent("esx_multichars:SpawnCharacter", src, spawn)
end)

RegisterServerEvent("esx_multichars:DeleteCharacter")
AddEventHandler('esx_multichars:DeleteCharacter', function(charid)
    local src = source
    DeleteCharacter(GetPlayerIdentifiers(src)[1], charid)
    TriggerClientEvent("esx_multichars:ReloadCharacters", src)
end)

function GetPlayerCharacters(source)
    local identifier = GetIdentifierWithoutSteam(GetPlayerIdentifiers(source)[1])
    local Chars = MySQLAsyncExecute("SELECT * FROM `users` WHERE identifier LIKE '%"..identifier.."%'")

    for i = 1, #Chars, 1 do
        charJob = MySQLAsyncExecute("SELECT `label` FROM `jobs` WHERE `name` = '"..Chars[i].job.."'")
        charJobgrade = MySQLAsyncExecute("SELECT `label` FROM `job_grades` WHERE `grade` = '"..Chars[i].job_grade.."' AND `job_name` = '"..Chars[i].job.."'")
        Chars[i].job = charJob[1].label
        Chars[i].job_grade = charJobgrade[1].label

        charOrg = MySQLAsyncExecute("SELECT `label` FROM `orgs` WHERE `name` = '"..Chars[i].org.."'")
        charOrggrade = MySQLAsyncExecute("SELECT `label` FROM `org_grades` WHERE `org_grade` = '"..Chars[i].org_grade.."' AND `org_name` = '"..Chars[i].org.."'")
        Chars[i].org = charOrg[1].label
        Chars[i].org_grade = charOrggrade[1].label
    end

    return Chars
end

function GetLastCharacter(source)
    local LastChar = MySQLAsyncExecute("SELECT `charid` FROM `user_lastcharacter` WHERE `steamid` = '"..GetPlayerIdentifiers(source)[1].."'")
    if LastChar[1] ~= nil and LastChar[1].charid ~= nil then
        return tonumber(LastChar[1].charid)
    else
        MySQLAsyncExecute("INSERT INTO `user_lastcharacter` (`steamid`, `charid`) VALUES('"..GetPlayerIdentifiers(source)[1].."', 1)")
        return 1
    end
end

function SetLastCharacter(source, charid)
    MySQLAsyncExecute("UPDATE `user_lastcharacter` SET `charid` = '"..charid.."' WHERE `steamid` = '"..GetPlayerIdentifiers(source)[1].."'")
end

function SetIdentifierToChar(identifier, charid)
    for _, itable in pairs(IdentifierTables) do
        MySQLAsyncExecute("UPDATE `"..itable.table.."` SET `"..itable.column.."` = 'Char"..charid..GetIdentifierWithoutSteam(identifier).."' WHERE `"..itable.column.."` = '"..identifier.."'")
    end
end

function SetCharToIdentifier(identifier, charid)
    for _, itable in pairs(IdentifierTables) do
        MySQLAsyncExecute("UPDATE `"..itable.table.."` SET `"..itable.column.."` = '"..identifier.."' WHERE `"..itable.column.."` = 'Char"..charid..GetIdentifierWithoutSteam(identifier).."'")
    end
end

function DeleteCharacter(identifier, charid)
    for _, itable in pairs(IdentifierTables) do
        MySQLAsyncExecute("DELETE FROM `"..itable.table.."` WHERE `"..itable.column.."` = 'Char"..charid..GetIdentifierWithoutSteam(identifier).."'")
    end
end

function GetSpawnPos(source)
    local SpawnPos = MySQLAsyncExecute("SELECT `position` FROM `users` WHERE `identifier` = '"..GetPlayerIdentifiers(source)[1].."'")
    return json.decode(SpawnPos[1].position)
end

function GetIdentifierWithoutSteam(Identifier)
    return string.gsub(Identifier, "steam", "")
end

function MySQLAsyncExecute(query)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchAll(query, {}, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Citizen.Wait(0)
    end
    return result
end