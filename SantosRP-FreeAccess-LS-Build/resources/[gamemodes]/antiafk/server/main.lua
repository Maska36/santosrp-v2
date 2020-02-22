RegisterServerEvent("antiafk:kick")
AddEventHandler("antiafk:kick", function()
	DropPlayer(source, "Auto-Kick Serveur: T'étais AFK, sry bro")
end)