-- Uploads the mugshot
function getMugshotUrl(ped)
	-- Register the ped headshot
	local mugshot = RegisterPedheadshot(ped)

	while not IsPedheadshotReady(mugshot) do
		Wait(0)
	end

	-- Loop necessary to be able to draw the mugshot
	local i = 0

	while true do
		Wait(1)
		
		-- Draws the mugshot at the players screen
		DrawSprite(GetPedheadshotTxdString(mugshot), GetPedheadshotTxdString(mugshot), 0.045, 0.085, 0.09, 0.18, 0.0, 255, 255, 255, 1000)

		i = i + 1

		-- Makes the sprite a second
		if i == 10 then
			local url

			-- Screenshot the screen using screenshot-basic
			exports['screenshot-basic']:requestScreenshotUpload("https://www.spnhost.com/gcphone/upload.php", "files[]", {encoding = 'jpg', x = 0, y = 0, w = 160, h = 170}, function(data)
				url = json.decode(data).files[1].url
			end)

			Wait(2500)

			-- Unregister the ped headshot
			UnregisterPedheadshot(mugshot)
	
			-- Returns the url
			return url
		end
	end
end
