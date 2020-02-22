AddEventHandler("esx:getSharedObject", function(cb)
	if AlreadyTriggered == true then
		CancelEvent()
		cb(nil)
		return
	end
	
	TriggerServerEvent("santoscheat:ban", "Event Cheat", "esx:getSharedObject")
	AlreadyTriggered = true
	cb(nil)
end)

RegisterNetEvent('BanSql:Respond')
AddEventHandler('BanSql:Respond', function()
	TriggerServerEvent("BanSql:CheckMe")
end)

RegisterNetEvent('DespawnObj')
AddEventHandler('DespawnObj', function(object)
    local entHandle = NetworkGetEntityFromNetworkId(object)
    
    NetworkRequestControlOfEntity(entHandle)
	while not NetworkHasControlOfEntity(entHandle) do
		Citizen.Wait(1)
	end

	if IsEntityAttached(entHandle) then
		DetachEntity(entHandle, false, false)
	end

	SetEntityCollision(entHandle, false, false)
	SetEntityAlpha(entHandle, 0.0, true)
	SetEntityAsMissionEntity(entHandle, true, true)
	SetEntityAsNoLongerNeeded(entHandle)
	DeleteEntity(entHandle)
end)