local QBCore = exports['qb-core']:GetCoreObject()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsPedShooting(PlayerPedId()) then
            local weaponHash = GetSelectedPedWeapon(PlayerPedId())
            TriggerServerEvent('weaponFired', weaponHash)
            Citizen.Wait(Config.ScreenshotCooldown)  -- To prevent spam
        end
    end
end)

RegisterNetEvent('requestScreenshot')
AddEventHandler('requestScreenshot', function(data)
    if data and data.url then
        exports['screenshot-basic']:requestScreenshotUpload(data.url, 'files[]', Config.ScreenshotSettings, function(response)
            local resp = json.decode(response)
            if resp and resp.attachments then
                local imageUrl = resp.attachments[1].proxy_url
                TriggerServerEvent('screenshotTaken', imageUrl, data.weaponName)  -- Inkludera 'weaponName' här
            end
        end)
    end
end)
