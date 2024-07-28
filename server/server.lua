QBCore = exports['qb-core']:GetCoreObject()

-- Fetch weapon data from QBCore
local weapons = QBCore.Shared.Weapons

if Config.Debug then
    print("Debug: Weapon data from QBCore:")
    for k, v in pairs(weapons) do
        print(string.format("Debug: Key: %s, Name: %s, Label: %s, Weapontype: %s", k, v.name, v.label, v.weapontype))
    end
end

RegisterServerEvent('weaponFired')
AddEventHandler('weaponFired', function(weaponHash)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    if xPlayer then
        local weaponData = weapons[weaponHash]

        if Config.Debug then
            print("Debug: weaponHash received: " .. tostring(weaponHash))
            print("Debug: weaponData: " .. tostring(weaponData))
        end

        if not weaponData then
            if Config.Debug then
                print("Debug: weaponData is nil for weaponHash " .. tostring(weaponHash))
            end

            -- Add a list of all keys in weapons to see if there is a match
            if Config.Debug then
                print("Debug: Available keys in weapons:")
                for k, v in pairs(weapons) do
                    print(string.format("Debug: Key: %s, Name: %s", k, v.name))
                end
            end
            return
        end

        local weaponLabel = weaponData.label or 'Unknown weapon'
        local playerJob = xPlayer.PlayerData.job.name
        local playerJobLabel = xPlayer.PlayerData.job.label
        local playerGang = xPlayer.PlayerData.gang.name
        local playerGangLabel = xPlayer.PlayerData.gang.label
        local citizenid = xPlayer.PlayerData.citizenid
        local name = xPlayer.PlayerData.charinfo.firstname .. ' ' .. xPlayer.PlayerData.charinfo.lastname
        local license = xPlayer.PlayerData.license

        if Config.Debug then
            print("Debug: Player with citizenid " .. citizenid .. " fired a weapon.")
            print("Debug: Weapon name: " .. tostring(weaponData.name))
            print("Debug: Weapon data: " .. tostring(weaponData))
            print("Debug: Weapon name: " .. weaponLabel)
            print("Debug: Player job: " .. playerJob)
            print("Debug: Player name: " .. name)
            print("Debug: Player license: " .. license)
        end

        if not table.includes(Config.BlacklistWeapons, weaponLabel) and not table.includes(Config.BlacklistJobs, playerJob) and weaponData.weapontype ~= 'Melee' then
            if Config.Debug then
                print("Debug: Weapon is not blacklisted and job is not blacklisted. Proceeding with screenshot.")
            end
            TriggerClientEvent('requestScreenshot', src, {url = Config.WebhookUrlScreenshot, weaponName = weaponLabel, playerName = name, playerLicense = license, playerJob = playerJobLabel, playerGang = playerGangLabel})
        else
            if Config.Debug then
                print("Debug: Blacklisted weapon or job: " .. weaponLabel .. " / " .. playerJob)
            end
        end
    else
        if Config.Debug then
            print("Debug: xPlayer is nil for source: " .. tostring(src))
        end
    end
end)

function table.includes(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

RegisterServerEvent('screenshotTaken')
AddEventHandler('screenshotTaken', function(imageUrl, weaponName, playerName, playerLicense, playerJob, playerGang)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    if xPlayer then
        if Config.Debug then
            print("Debug: Screenshot taken for weapon: " .. tostring(weaponName))
            print("Debug: Image URL: " .. imageUrl)
            print("Debug: Player name: " .. playerName)
            print("Debug: Player license: " .. playerLicense)
            print("Debug: Player job: " .. playerJob)
            print("Debug: Player gang: " .. playerGang)
        end
        SendToDiscord(src, xPlayer, imageUrl, weaponName, playerName, playerLicense, playerJob, playerGang)
    else
        if Config.Debug then
            print("Debug: xPlayer is nil for source: " .. tostring(src))
        end
    end
end)

function SendToDiscord(src, xPlayer, imageUrl, weaponName, playerName, playerLicense, playerJob, playerGang)
    local steamId, discord = 'Not found', 'Not found'

    for k, v in pairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, 6) == 'steam:' then
            steamId = string.sub(v, 7)
        elseif string.sub(v, 1, 8) == 'discord:' then
            discord = '<@' .. string.sub(v, 9) .. '>'
        end
    end

    local currentDateTime = os.date("%Y-%m-%d %H:%M:%S")
    local data = {
        username = Config.Username,
        avatar_url = Config.AvatarUrl,
        embeds = {{
            title = Config.DiscordMessageSettings.title,
            color = Config.DiscordMessageSettings.color,
            thumbnail = { url = Config.DiscordMessageSettings.thumbnail_url },
            fields = {
                { name = "**CitizenID**", value = tostring(xPlayer.PlayerData.citizenid), inline = false },
                { name = "**Name**", value = playerName, inline = false },
                { name = "**License**", value = playerLicense, inline = false },
                { name = "**Job**", value = playerJob, inline = false },
                { name = "**Gang**", value = playerGang, inline = false },
                { name = "**DiscordID**", value = discord, inline = false },
                { name = "**Weapon**", value = tostring(weaponName), inline = false },
                { name = "**Date and Time**", value = currentDateTime, inline = false }
            },
            image = { url = imageUrl }
        }}
    }

    if Config.Debug then
        print("Debug: Preparing to send message to Discord.")
        print("Debug: Data payload for Discord: " .. json.encode(data))
    end

    PerformHttpRequest(Config.WebhookUrlMessage, function(err, text, headers)
        if Config.Debug then
            if err ~= 0 then
                print("Debug: Error while sending message to Discord: " .. err)
            else
                print("Debug: Message sent successfully to Discord: " .. text)
            end
        end
    end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
end
