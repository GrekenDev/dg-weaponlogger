Config = {}

Config.Debug = true

-- Discord & FiveManage
Config.DiscordWebhook = "YOUR_DISCORD_WEBHOOK_URL" -- CHANGE THIS TO YOUR DISCORD WEBHOOK URL
Config.FiveManageApiUrl = "https://fmapi.net/api/v2/image" -- DO NOT CHANGE THIS URL
Config.FiveManageToken = "YOUR_FIVEMANAGE_TOKEN" -- CHANGE THIS TO UR TOKEN

-- Inventory system selection: "ox_inventory", "qb-inventory", "bb_inventory"
Config.Inventory = "bb_inventory"

-- Resource names (change if you renamed the folders/resources)
Config.OXInventoryResource = "ox_inventory"
Config.QBInventoryResource = "qb-inventory"
Config.BBInventoryResource = "bb_inventory"

-- Core system selection: "qbx_core", "qb-core", "es_extended", "ox_core"
Config.CoreResource = "qbx_core"

Config.ScreenshotCooldown = 5000 -- ms

Config.BlacklistWeapons = {
    "911657153", -- Weapon hash for Stun Gun
}

Config.BlacklistJobs = {
    "police",
}

Config.ScreenshotSettings = {
    encoding = "png",
    quality = 0.8
}

Config.Username = "Shooting Log" -- Username for Discord messages
Config.AvatarUrl = "https://your-avatar-url.com/avatar.png" -- Avatar URL for Discord messages

Config.DiscordMessageSettings = {
    title = "Shots fired!", -- Discord message title
    color = 16711680,       -- Red
    thumbnail_url = "https://example.com/thumbnail.jpg" -- Thumbnail image URL
}