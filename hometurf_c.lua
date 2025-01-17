isLoggedIn = false
local currentZone = false


local deathLoop = false

if Config.RestartingScript then
	CreateThread(function()
		isLoggedIn = true
		ESX.PlayerData = ESX.GetPlayerData()
	end)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	isLoggedIn = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

local hasBeenNotified = false

RegisterNetEvent('loaded:client:hometurfs:notifyGang', function()
	CreateThread(function()
		if not hasBeenNotified then
			hasBeenNotified = true
			lib.notify({
				title = 'Gang Turf',
				description = 'Someone suspicious is on your turf!',
				type = 'error'
			})
			Wait(5000)
			hasBeenNotified = false
		end
	end)
end)


local createdZones = {}

Citizen.CreateThread(function()
	while not ESX.PlayerData.job do
		Wait(500)
	end
	for gang_name, tbl in pairs(Config.HomeTurfZones) do
		local data = tbl["blip"]
		
		if data.enable then
			local blip = AddBlipForCoord(data.coords.x, data.coords.y, data.coords.z)
			SetBlipSprite(blip, data.id)
			SetBlipDisplay(blip, data.display)
			SetBlipScale(blip, data.scale)
			SetBlipColour(blip, data.colour)
			SetBlipAsShortRange(blip, data.shortRange)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(data.text)
			EndTextCommandSetBlipName(blip)
		end
		
		for k, v in pairs(tbl["zoneParts"]) do
			local coords = v.coords
			local length = v.length
			local width = v.width
			local heading = v.heading
			local maxz = v.maxz
			local name = v.name
			local debugPoly = v.debugPoly
			handleTestStuff(coords, length, width, heading, maxz, name, debugPoly, tbl["zoneColour"], tbl["zoneAlpha"])
		end
		
		handleCreatedZonesTable(gang_name)
		
	end
end)

function handleTestStuff(center, length, width, heading, maxz, name, debugPoly, colour, alpha)
	local center = { x = center.x, y = center.y, z = 0.0 }
	
	local halfLength = length / 2
	local halfWidth = width / 2

	local bottomLeft = {
		x = center.x - halfLength,
		y = center.y - halfWidth,
		z = center.z
	}

	local topRight = {
		x = center.x + halfLength,
		y = center.y + halfWidth,
		z = center.z
	}
	
	DrawZonePart(bottomLeft.x, bottomLeft.y, topRight.x, topRight.y, maxz, name, debugPoly, colour, alpha, heading)
	
end

function isMyJobAGang(myGang)
	if Config.AllGangs[myGang] then return true end
	return false
end

function handleCreatedZonesTable(gang_name)
	local gang_name = ComboZone:Create(createdZones, {name = gang_name, debugPoly = Config.DebugPoly})
	gang_name:onPlayerInOut(function(isPointInside, point, zone)
		currentZone = gang_name.name
		local gang = gang_name.name
		local myGang = ESX.PlayerData.job.name
		while isPointInside do	
			
			local coords = GetEntityCoords(PlayerPedId())

			if coords.z < zone.data.maxheight then
				if myGang == gang then
					lib.notify({
						title = 'Gang Turf',
						description = 'Welcome Home!',
						type = 'success'
					})
				else
					lib.showTextUI('You entered '..gang..'s turf!')
					if isMyJobAGang(myGang) then
						TriggerServerEvent('loaded:server:hometurfs:notifyGang', gang)
					end
				end
				break
			end
			Wait(1000)
		end
		
		if not isPointInside then
			deathLoop = false
			if lib.isTextUIOpen() then
				lib.hideTextUI()
			end
		else
			deathLoop = true
			handleDeath()
		end
	end)
	
	createdZones = {}
end

function DrawZonePart(x1, y1, x2, y2, maxz, name, debugPoly, colour, alpha, heading)
    local centerX = (x1 + x2) / 2
    local centerY = (y1 + y2) / 2

    local width = math.abs(x1 - x2)
    local height = math.abs(y1 - y2)

    local blip = AddBlipForArea(centerX, centerY, 0.0, width, height)

    local colour = colour or 2
    local alpha = alpha or 80

    SetBlipColour(blip, colour)
    SetBlipAlpha(blip, alpha)
    SetBlipAsShortRange(blip, true)
    SetBlipDisplay(blip, 4)
	SetBlipRotation(blip, math.ceil(heading + 90))
	
	local coords = vector3(centerX, centerY, 0.0)

	local name = BoxZone:Create(coords, width, height, {
		name = name,
		heading = heading,
		debugPoly = debugPoly,
		data = {maxheight = maxz}
	})

	table.insert(createdZones, name)
end


function handleDeath()
	Citizen.CreateThread(function()	
		local DeathReason, Killer = nil
		local ped = PlayerPedId()
		while deathLoop do
			Citizen.Wait(0)
			
			if IsEntityDead(ped) then
				Citizen.Wait(0)
				local PedKiller = GetPedSourceOfDeath(PlayerPedId())
				local killername = GetPlayerName(PedKiller)
				
				if IsEntityAPed(PedKiller) and IsPedAPlayer(PedKiller) then
					Killer = NetworkGetPlayerIndexFromPed(PedKiller)
				elseif IsEntityAVehicle(PedKiller) and IsEntityAPed(GetPedInVehicleSeat(PedKiller, -1)) and IsPedAPlayer(GetPedInVehicleSeat(PedKiller, -1)) then
					Killer = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(PedKiller, -1))
				end
				
				DeathReason = (Killer == PlayerId()) and 'committed suicide' or (Killer and 'died from another player') or 'died'
				
				if DeathReason then
					TriggerServerEvent('loaded:hometurf:server:handleKill', PedKiller, Killer, GetPlayerServerId(Killer), currentZone)
				end
				
				Killer = nil
				DeathReason = nil
			end
			while IsEntityDead(ped) do
				Citizen.Wait(0)
			end
		end
	end)
end

function tPrint(tbl, indent)
    indent = indent or 0
    if type(tbl) == 'table' then
        for k, v in pairs(tbl) do
            local tblType = type(v)
            local formatting = ("%s ^3%s:^0"):format(string.rep("  ", indent), k)

            if tblType == "table" then
                print(formatting)
                tPrint(v, indent + 1)
            elseif tblType == 'boolean' then
                print(("%s^1 %s ^0"):format(formatting, v))
            elseif tblType == "function" then
                print(("%s^9 %s ^0"):format(formatting, v))
            elseif tblType == 'number' then
                print(("%s^5 %s ^0"):format(formatting, v))
            elseif tblType == 'string' then
                print(("%s ^2'%s' ^0"):format(formatting, v))
            else
                print(("%s^2 %s ^0"):format(formatting, v))
            end
        end
    else
        print(("%s ^0%s"):format(string.rep("  ", indent), tbl))
    end
end