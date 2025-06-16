local function getCurrentWeapon()
    local inventory = Config.Inventory
    if inventory == "ox_inventory" then
        local resource = Config.OXInventoryResource or "ox_inventory"
        return exports[resource]:GetCurrentWeapon('player')
    elseif inventory == "bb_inventory" then
        local resource = Config.BBInventoryResource or "bb_inventory"
        local api = exports[resource]:GetAPI()
        local weapon = api.GetCurrentWeapon()
        if weapon then
            weapon.name = weapon.name or (weapon.item and weapon.item.name) or nil
        end
        return weapon
    elseif inventory == "qb-inventory" then
        local resource = Config.QBInventoryResource or "qb-inventory"
        return exports[resource]:GetCurrentWeapon()
    else
        if Config.Debug then
            print("Debug: Unknown inventory type in config: " .. tostring(inventory))
        end
        return nil
    end
end

local lastShot = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10) -- Kör ofta, men inte varje frame
        if IsPedShooting(PlayerPedId()) then
            local now = GetGameTimer()
            if now - lastShot > Config.ScreenshotCooldown then
                lastShot = now
                local weapon = getCurrentWeapon()
                if Config.Debug then
                    print("Debug: Weapon object: " .. json.encode(weapon))
                end
                if weapon and weapon.name and weapon.name ~= "" then
                    if Config.Debug then
                        print(("Debug: Current weapon: %s"):format(weapon.name))
                    end
                    TriggerServerEvent('weaponFired', weapon.name:lower())
                else
                    if Config.Debug then
                        print("Debug: No weapon detected or weapon name is empty")
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('requestScreenshot')
AddEventHandler('requestScreenshot', function(data)
    if Config.FiveManageApiUrl and Config.FiveManageToken then
        if Config.Debug then
            print("Debug: Requesting screenshot upload to FiveManage via screenshot-basic, URL: " .. Config.FiveManageApiUrl)
        end
        exports['screenshot-basic']:requestScreenshotUpload(
            Config.FiveManageApiUrl,
            'file',
            {
                headers = {
                    Authorization = Config.FiveManageToken
                }
            },
            function(response)
                if Config.Debug then
                    print("Debug: Raw screenshot-basic response: " .. tostring(response))
                end
                local resp = json.decode(response or "")
                if resp and resp.data and resp.data.url then
                    if Config.Debug then
                        print("Debug: Screenshot uploaded to FiveManage, image URL: " .. resp.data.url)
                    end
                    TriggerServerEvent('screenshotTaken', resp.data.url, data.weaponName, data.playerName, data.playerLicense, data.playerJob, data.playerGang)
                else
                    if Config.Debug then
                        print("Debug: Screenshot upload failed or unexpected response: " .. response)
                    end
                end
            end
        )
    else
        if Config.Debug then
            print("Debug: FiveManage API URL or API Key not set in config")
        end
    end
end)