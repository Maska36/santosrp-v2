local connecte = false
AddEventHandler("playerSpawned", function()
	if (connecte == false) then
		TriggerServerEvent("santosrp-rocade:playerConnected")
		connecte = true
	end
end)