local QBCore = exports['qb-core']:GetCoreObject()
local weapons = nil

-- Fetch weapon data from QBCore
Citizen.CreateThread(function()
    while weapons == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(200)
        weapons = QBCore.Shared.Weapons -- Fetch weapon data directly from QBCore
    end
    if Config.Debug then
        print("Debug: Weapon data fetched from QBCore")
        for hash, weapon in pairs(weapons) do
            print(string.format("Debug: Weapon - Hash: %s, Name: %s, Label: %s", hash, weapon.name, weapon.label))
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsPedShooting(PlayerPedId()) then
            local weaponHash = GetSelectedPedWeapon(PlayerPedId())
            if Config.Debug then
                print("Debug: weaponHash received: " .. tostring(weaponHash))
            end
            TriggerServerEvent('weaponFired', weaponHash)
            Citizen.Wait(Config.ScreenshotCooldown)  -- To prevent spam
        end
    end
end)

RegisterNetEvent('requestScreenshot')
AddEventHandler('requestScreenshot', function(data)
    if data and data.url then
        if Config.Debug then
            print("Debug: Requesting screenshot upload to URL: " .. data.url)
        end
        exports['screenshot-basic']:requestScreenshotUpload(data.url, 'files[]', Config.ScreenshotSettings, function(response)
            local resp = json.decode(response)
            if resp and resp.attachments then
                local imageUrl = resp.attachments[1].proxy_url
                if Config.Debug then
                    print("Debug: Screenshot taken, image URL: " .. imageUrl)
                end
                TriggerServerEvent('screenshotTaken', imageUrl, data.weaponName, data.playerName, data.playerLicense, data.playerJob, data.playerGang)
            else
                if Config.Debug then
                    print("Debug: No screenshot taken, response: " .. response)
                end
            end
        end)
    else
        if Config.Debug then
            print("Debug: No URL for screenshot upload received")
        end
    end
end)
