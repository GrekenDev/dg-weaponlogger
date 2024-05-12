QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('weaponFired')
AddEventHandler('weaponFired', function(weaponHash)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    if xPlayer then
        local weaponData = QBCore.Shared.Weapons[weaponHash]
        local weaponLabel = weaponData and weaponData.label or 'Okänt vapen'

        if Config.Debug then
            print("Debug: Player " .. xPlayer.PlayerData.name .. " fired a weapon.")
            print("Debug: Weapon Hash: " .. tostring(weaponHash))
            print("Debug: Weapon Data: " .. tostring(weaponData))
            print("Debug: Weapon Label: " .. weaponLabel)
        end

        if not table.includes(Config.BlacklistWeapons, weaponLabel) then
            if Config.Debug then
                print("Debug: Weapon is not blacklisted. Proceeding with screenshot.")
            end
            TriggerClientEvent('requestScreenshot', src, {url = Config.WebhookUrlScreenshot, weaponName = weaponLabel})
        else
            if Config.Debug then
                print("Debug: Blacklisted weapon fired: " .. weaponLabel)
            end
        end
    end
end)

function table.includes(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

RegisterServerEvent('screenshotTaken')
AddEventHandler('screenshotTaken', function(imageUrl, weaponName)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    if xPlayer then
        if Config.Debug then
            print("Debug: Screenshot taken for weapon: " .. tostring(weaponName))
            print("Debug: Image URL: " .. imageUrl)
        end
        SendToDiscord(src, xPlayer, imageUrl, weaponName)
    end
end)

function SendToDiscord(src, xPlayer, imageUrl, weaponName)
    local steamId, license, discord = 'Not found', 'Not found', 'Not found'
    for k, v in pairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, 8) == 'license:' then
            steamId = v
        elseif string.sub(v, 1, 8) == 'discord:' then
            discord = '<@' .. string.sub(v, 9) .. '>'
        end
    end
    local currentDateTime = os.date("%Y-%m-%d %H:%M:%S")
    local data = {
        username = Config.Username,
        embeds = {{
            title = Config.DiscordMessageSettings.title,
            color = Config.DiscordMessageSettings.color,
            thumbnail = { url = Config.DiscordMessageSettings.thumbnail_url },
            fields = {
                { name = "CitizenID", value = tostring(xPlayer.PlayerData.citizenid), inline = false },
                { name = "Name", value = xPlayer.PlayerData.name, inline = false },
                { name = "License", value = license, inline = false },
                { name = "DiscordID", value = discord, inline = false },
                { name = "Weapon", value = tostring(weaponName), inline = false },
                { name = "Date and Time", value = currentDateTime, inline = false }
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
