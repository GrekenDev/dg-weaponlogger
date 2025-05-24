-- Hämta vapendata från ox_inventory (om du behöver det för debug eller framtida funktioner)
local weapons = exports.ox_inventory:Items()

if Config.Debug then
    print("Debug: Weapon data fetched from ox_inventory")
    for name, weapon in pairs(weapons) do
        if weapon.type == 'weapon' then
            print(string.format("Debug: Weapon - Name: %s, Label: %s", name, weapon.label or 'N/A'))
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsPedShooting(PlayerPedId()) then
            local weapon = exports.ox_inventory:GetCurrentWeapon('player')
            if weapon and weapon.name and weapon.name ~= "" then
                if Config.Debug then
                    print(("Debug: Current weapon: %s"):format(weapon.name))
                end
                TriggerServerEvent('weaponFired', weapon.name:lower())
            else
                if Config.Debug then
                    print("Debug: No weapon detected from ox_inventory or weapon name is empty")
                end
            end
            Citizen.Wait(Config.ScreenshotCooldown) -- För att undvika spam
        end
    end
end)

RegisterNetEvent('requestScreenshot')
AddEventHandler('requestScreenshot', function(data)
    if data and data.url then
        if Config.Debug then
            print("Debug: Requesting screenshot upload to FiveManage via screenshot-basic, URL: " .. data.url)
        end
        exports['screenshot-basic']:requestScreenshotUpload(
            data.url,
            'files[]',
            Config.ScreenshotSettings,
            function(response)
                local resp = json.decode(response)
                if resp and resp.success and resp.url then
                    if Config.Debug then
                        print("Debug: Screenshot uploaded to FiveManage, image URL: " .. resp.url)
                    end
                    TriggerServerEvent('screenshotTaken', resp.url, data.weaponName, data.playerName, data.playerLicense, data.playerJob, data.playerGang)
                else
                    if Config.Debug then
                        print("Debug: Screenshot upload failed or unexpected response: " .. response)
                    end
                end
            end
        )
    else
        if Config.Debug then
            print("Debug: No URL for screenshot upload received")
        end
    end
end)