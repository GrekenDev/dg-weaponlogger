if Config.Debug then
    print("Debug: Server started, using Qbox/ox_inventory and FiveManage for screenshots.")
end

function table.includes(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

RegisterServerEvent('weaponFired')
AddEventHandler('weaponFired', function(weaponName)
    local src = source

    local player = exports['qbx-core']:GetPlayer(src)
    local name, job, gang, citizenid, license = "N/A", "N/A", "N/A", "N/A", "N/A"

    if player then
        name = (player.PlayerData.charinfo.firstname or "") .. " " .. (player.PlayerData.charinfo.lastname or "")
        job = player.PlayerData.job and player.PlayerData.job.name or "N/A"
        gang = player.PlayerData.gang and player.PlayerData.gang.name or "N/A"
        citizenid = player.PlayerData.citizenid or "N/A"
        license = player.PlayerData.license or "N/A"
    end

    if Config.Debug then
        print(("Debug: Player %s fired weapon %s"):format(name, weaponName))
    end

    if not table.includes(Config.BlacklistWeapons, weaponName) and not table.includes(Config.BlacklistJobs, job) then
        if Config.Debug then
            print("Debug: Weapon and job not blacklisted, requesting screenshot.")
        end
        TriggerClientEvent('requestScreenshot', src, {
            url = Config.FiveManageApiUrl,
            weaponName = weaponName,
            playerName = name,
            playerLicense = license,
            playerJob = job,
            playerGang = gang
        })
    else
        if Config.Debug then
            print("Debug: Weapon or job blacklisted, skipping screenshot.")
        end
    end
end)

RegisterServerEvent('screenshotTaken')
AddEventHandler('screenshotTaken', function(imageUrl, weaponName, playerName, citizenid, playerLicense, playerJob, playerGang)
    local src = source

    local discord = 'Not found'
    for _, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, 8) == 'discord:' then
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
                { name = "**Name**", value = playerName, inline = false },
                { name = "**CitizenID**", value = citizenid, inline = false },
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
        print("Debug: Sending embed to Discord with FiveManage image URL: " .. tostring(imageUrl))
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
end)