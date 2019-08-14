-----------------------
-- Damaged Walk Mode --
-----------------------

local hurt = false
Citizen.CreateThread(function()
    while true do
        Wait(0)
        if GetEntityHealth(GetPlayerPed(-1)) <= 159 then
            setHurt()
        elseif hurt and GetEntityHealth(GetPlayerPed(-1)) > 160 then
            setNotHurt()
        end
    end
end)

function setHurt()
    hurt = true
    RequestAnimSet("move_m@injured")
    SetPedMovementClipset(GetPlayerPed(-1), "move_m@injured", true)
	SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
	DisableControlAction(0, 21) 
	DisableControlAction(0,22)
end

function setNotHurt()
    hurt = false
	SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
    ResetPedMovementClipset(GetPlayerPed(-1))
    ResetPedWeaponMovementClipset(GetPlayerPed(-1))
    ResetPedStrafeClipset(GetPlayerPed(-1))
end

----------------------------------
-- Fall while Running & Jumping --
----------------------------------

local ragdoll_chance = 0.75

print('chance of falling set to: ' .. ragdoll_chance)
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		local ped = PlayerPedId()
		if IsPedOnFoot(ped) and not IsPedSwimming(ped) and (IsPedRunning(ped) or IsPedSprinting(ped)) and not IsPedClimbing(ped) and IsPedJumping(ped) and not IsPedRagdoll(ped) then
			local chance_result = math.random()
			print('lose grip result: ' .. chance_result)
			if chance_result < ragdoll_chance then 
				Citizen.Wait(600)
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.25)
				SetPedToRagdoll(ped, 5000, 1, 2)
				print('falling!')
			else
				Citizen.Wait(2000)
			end
		end
	end
end)

--------------------------------
-- Walk Shake code by Xinerki --
--------------------------------

playerMoving = false

Citizen.CreateThread(function()
	while true do Wait(0)
		if not IsPedInAnyVehicle(PlayerPedId(), false) and GetEntitySpeed(PlayerPedId()) >= 0.5 and GetFollowPedCamViewMode() ~= 4 then
			if playerMoving == false then
				ShakeGameplayCam("ROAD_VIBRATION_SHAKE", 0.25)
				playerMoving = true
			end
		else
			if playerMoving == true then
				StopGameplayCamShaking(false)
				playerMoving = false
			end
		end
	end
end)
