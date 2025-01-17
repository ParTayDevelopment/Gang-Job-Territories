RegisterNetEvent('loaded:server:hometurfs:notifyGang', function(gang)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
    -- local Gang = xPlayer.job.name
	local Gang = ESX.GetExtendedPlayers("job", gang)

	for _, xPlayer in pairs(Gang) do
		if xPlayer.job.name == gang then
			TriggerClientEvent('loaded:client:hometurfs:notifyGang', xPlayer.source)
		end
	end
	
end)

RegisterNetEvent('loaded:hometurf:server:handleKill', function(PedKiller, Killer, KillerServerId, sentGang)
	local src = source -- player who died
	-- KillerServerId -- player who killed

	if not sentGang then return end
	
	local deadPlayer = ESX.GetPlayerFromId(src)
	local deadPlayerGang = deadPlayer.job.name
	
	local killerPlayer = ESX.GetPlayerFromId(KillerServerId)
	local killerPlayerGang = killerPlayer.job.name

	if not Config.AllGangs[deadPlayerGang] or not Config.AllGangs[killerPlayerGang] then return end

	if deadPlayerGang == killerPlayerGang then return end

	if killerPlayerGang ~= sentGang then return end
	
	local amount = Config.HomeTurfZones[killerPlayerGang]["killReward"]
	killerPlayer.addAccountMoney(Config.Moneytype, amount, "Hometurf Kill")

	
end)