
Config = {}
Config.Debug = true
Config.WebhookUrlMessage = "https://discord.com/api/webhooks/YOUR_WEBHOOK_ID_MESSAGE"
Config.WebhookUrlScreenshot = "https://discord.com/api/webhooks/YOUR_WEBHOOK_ID_SCREENSHOT"
Config.ScreenshotSettings = {
    encoding = 'png',
    quality = 0.8
}
Config.BlacklistWeapons = {
    "Minigun",
    "Railgun",
    "Taser"
}
Config.ScreenshotCooldown = 5000
Config.DiscordMessageSettings = {
    title = "Shots fired!",
    color = 16711680,  -- Red
    thumbnail_url = "https://example.com/thumbnail.jpg"
}