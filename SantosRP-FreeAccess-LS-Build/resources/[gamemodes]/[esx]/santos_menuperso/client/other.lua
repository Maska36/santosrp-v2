local crouched, croiser, handsup, thumbsup, ragdolled = false, false, false, false, false

Citizen.CreateThread( function()
	while true do
		Citizen.Wait(0)

		if (DoesEntityExist(PlayerPedId()) and not IsEntityDead(PlayerPedId())) and (IsPedOnFoot(PlayerPedId())) then
			if (not IsPauseMenuActive()) then
				DisableControlAction(1, 36, true) -- Disable Keyboard Crouch Stance

				if (IsDisabledControlJustPressed(1, 36)) then -- CTRL
					crouched = not crouched

					if crouched then
						ESX.Streaming.RequestAnimSet('move_ped_crouched', function()
							SetPedMovementClipset(PlayerPedId(), 'move_ped_crouched', 0.55)
							RemoveAnimSet('move_ped_crouched')
						end)
					else
						ResetPedMovementClipset(PlayerPedId(), 0)
						ResetPedStrafeClipset(PlayerPedId())
						ESX.Streaming.RequestAnimSet('MOVE_M@TOUGH_GUY@', function()
							SetPedMovementClipset(PlayerPedId(), 'MOVE_M@TOUGH_GUY@', 0.5)
							RemoveAnimSet('MOVE_M@TOUGH_GUY@')
						end)
					end
				end

				if IsDisabledControlJustPressed(1, 47) then -- G
					croiser = not croiser

					if croiser then
						ESX.Streaming.RequestAnimDict('amb@world_human_hang_out_street@female_arms_crossed@base', function()
							TaskPlayAnim(PlayerPedId(), 'amb@world_human_hang_out_street@female_arms_crossed@base', 'base', 8.0, 8.0, -1, 50, 0, false, false, false)
							RemoveAnimDict('amb@world_human_hang_out_street@female_arms_crossed@base')
						end)
					else
						ClearPedSecondaryTask(PlayerPedId())
					end
				end

				if IsDisabledControlJustPressed(1, 20) then -- W
					thumbsup = not thumbsup

					if thumbsup then
						ESX.Streaming.RequestAnimDict('anim@mp_player_intincarthumbs_upbodhi@ps@', function()
							TaskPlayAnim(PlayerPedId(), 'anim@mp_player_intincarthumbs_upbodhi@ps@', 'enter', 8.0, 8.0, -1, 50, 0, false, false, false)
							RemoveAnimDict('anim@mp_player_intincarthumbs_upbodhi@ps@')
						end)
					else
						ClearPedSecondaryTask(PlayerPedId())
					end
				end

				if IsDisabledControlJustPressed(1, 73) then -- X
					handsup = not handsup

					if handsup then
						ESX.Streaming.RequestAnimDict('random@mugging3', function()
							TaskPlayAnim(PlayerPedId(), 'random@mugging3', 'handsup_standing_base', 8.0, -8, -1, 49, 0, false, false, false)
							RemoveAnimDict('random@mugging3')
						end)
					else
						ClearPedSecondaryTask(PlayerPedId())
					end
				end

				if IsDisabledControlJustPressed(1, 82) then -- ;
					ragdolled = not ragdolled
				end

				if ragdolled then
					SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
				end
			else
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(500)
		end 
	end
end)