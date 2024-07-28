Config = {}

-- Settings for debug
Config.Debug = true

-- URL for Discord webhooks
Config.WebhookUrlMessage = "YOUR_DISCORD_WEBHOOK_URL_FOR_MESSAGES"
Config.WebhookUrlScreenshot = "YOUR_DISCORD_WEBHOOK_URL_FOR_SCREENSHOTS"

-- Settings for screenshot
Config.ScreenshotSettings = {
    encoding = "png",
    quality = 0.8
}

-- Blacklisted weapons
Config.BlacklistWeapons = {
    "Minigun",
    "Railgun",
    "Taser"
}

-- Blacklisted jobs
Config.BlacklistJobs = {
    "police",
}

-- Cooldown time for screenshot (in milliseconds)
Config.ScreenshotCooldown = 5000

-- Settings for Discord messages
Config.DiscordMessageSettings = {
    title = "Shots fired!",
    color = 16711680,  -- Red
    thumbnail_url = "https://example.com/thumbnail.jpg"
}

-- Username for Discord webhook
Config.Username = "Shooting Log"

-- Avatar URL for Discord webhook
Config.AvatarUrl = "https://your-avatar-url.com/avatar.png"
