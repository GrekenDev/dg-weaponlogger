Config = {}

-- Settings for debug
Config.Debug = true

-- URL for Discord webhooks
Config.WebhookUrlMessage = "https://discord.com/api/webhooks/1232896992070602783/WDFH-__YhLIZwAGa3jZtL5qF0x1Q0j7LlMlPzCRB20awdaEYJ3Tx7phif8CNLW63iXfM"
Config.WebhookUrlScreenshot = "https://discord.com/api/webhooks/1248604172983734352/Dz7wud94RUJJT2DuMHRm-CbaLB96wHQR3DRxBzV84rJ_NTLVB6KPA6J7vdqotd0xmzXB"

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
